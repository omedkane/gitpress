import 'package:mauripress/Models/OneLine.dart';
import 'package:mauripress/Models/OneOrder.dart';
import 'package:mauripress/Models/OneUser.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList_Model.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class LineDetailsModel {
  DbTalker talk2U = locator.get<Talk2Users>();
  DbTalker talk2O = locator.get<Talk2Orders>();
  OneUser daUser;
  final OneLine daLine;
  List<OneOrder> orders = [];
  OrderListModel oldm = locator.get<OrderListModel>();

  LineDetailsModel(this.daLine);

  add2OpenedLines() {
    oldm.openedLines.add([daLine.id, orders]);
  }

  Future getUserInfo() async {
    await talk2U.getDocumentById(daLine.userid).then((dadoc) {
      daUser = OneUser.fromMap(dadoc.documentID, dadoc.data);
    });
  }

  openInMaps() async {
    if (daUser == null) await getUserInfo();
    if (daUser.gpsPos != null)
      launch("geo:${daUser.gpsPos.latitude},${daUser.gpsPos.longitude}");
  }

  Future getOrdersByLine() async {
    var prevResults = oldm.openedLines
        .firstWhere(((elem) => elem[0] == daLine.id), orElse: () => false);
    if (!(prevResults is bool)) {
      orders = prevResults[1];
      return;
    }

    await talk2O.ref
        .where('lineid', isEqualTo: daLine.id)
        .getDocuments()
        .then((snaps) {
      snaps.documents.forEach((dadoc) {
        orders.add(OneOrder.fromMap(dadoc.documentID, dadoc.data));
      });
    });
  }
}
