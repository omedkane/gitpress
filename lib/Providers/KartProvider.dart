import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mauripress/Models/ClotheCatalogue.dart';
import 'package:mauripress/Models/OneClothe.dart';
import 'package:mauripress/Models/OneLine.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';
import 'package:provider/provider.dart';

class CartSlot {
  int qty = 0;
  int pixi = 0;
  final OneClothe daclothe;

  CartSlot(this.daclothe);
  incQty() {
    qty++;
    pixi = daclothe.pixi * qty;
  }

  resetMe() {
    qty = 0;
    pixi = 0;
  }

  decQty() {
    if (qty > 0) {
      qty--;
      pixi = daclothe.pixi * qty;
    }
  }
}

class CartProvider with ChangeNotifier {
  ClotheCatalogue catalogue = locator.get<ClotheCatalogue>();
  List<CartSlot> dakart = [];
  int totalPixi = 0;

  // addtoKart(akart) {
  //   this.dakart = akart.map((elem) => elem).toList();
  // }
  CartProvider() {
    fetchCatalogue();
  }
  void resetAll() {
    if (totalPixi == 0) return;
    dakart.forEach((elem) {
      elem.resetMe();
    });
    totalPixi = 0;
    notifyListeners();
  }

  void incQty(int index) {
    dakart[index].incQty();
    updateTotalPixi();
    notifyListeners();
  }

  void decQty(int index) {
    dakart[index].decQty();
    updateTotalPixi();
    notifyListeners();
  }

  void updateTotalPixi() {
    totalPixi = 0;
    dakart.forEach((elem) {
      totalPixi += elem.pixi;
    });
  }

  bool cartIsEmpty() {
    return dakart.where((elem) => elem.qty > 0).length == 0;
  }

  Future submitCart(BuildContext context) async {
    if (cartIsEmpty()) return;
    if (!await checkInternet()) {
      return false;
    }
    DbTalker lineTalk = locator.get<Talk2Lines>();
    DbTalker orderTalk = locator.get<Talk2Orders>();
    var dauser = Provider.of<PhoneMaster>(context, listen: false);
    var dabatch = catalogue.talk.ref.firestore.batch();
    String lineid;
    bool justDoIt = false;
    try {
      await lineTalk
          .addDocument(OneLine(
        address: dauser.address,
        userid: dauser.id,
        fullName: dauser.fullName,
        totalPrice: totalPixi,
        phoneNumber: dauser.phoneNumber,
      ).toJson())
          .then((val) async {
        lineid = val.documentID;
        justDoIt = true;
      });
      if (justDoIt) {
        dakart.forEach((elem) {
          if (elem.qty > 0) {
            dabatch.setData(orderTalk.ref.document(), {
              'clotheid': elem.daclothe.id,
              'qty': elem.qty,
              'lineid': lineid,
              'pixi': elem.pixi
            });
          }
        });
        await dabatch.commit();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void fetchCatalogue() {
    dakart.clear();
    catalogue.allClothes.forEach((elem) {
      dakart.add(CartSlot(elem));
    });
  }
}

// List<dynamic> dakart = [
//   Contitems(0, "Shirts.png", "Chemise(s)", Color(0xff59ADFF), 30),
//   Contitems(0, "Pants.png", "Pantalon(s)", Color(0xffFFA726), 60),
//   Contitems(0, "Suits.png", "Veste(s)", Color(0xffFF8A65), 100),
//   Contitems(0, "Daras_1.png", "Boubou(s)", Color(0xff59ADFF), 100),
// ];
