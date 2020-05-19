import 'package:flutter/foundation.dart';
import 'package:mauripress/Models/OneClothe.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class ClotheCatalogue with ChangeNotifier {
  List<OneClothe> allClothes = [];
  DbTalker talk = locator.get<Talk2Clothes>();

  Future<void> fetchClothes() async {
    await talk.getDataCollection().then((val) {
      allClothes.clear();
      val.documents.forEach((dadoc) {
        allClothes.add(OneClothe.fromDoc(dadoc));
      });
    });
  }

  List clotheForId(String clotheId) {
    var daClothe = allClothes.firstWhere((elem) => elem.id == clotheId);
    return [daClothe.nawa,daClothe.pixi];
  }
}
