import 'package:mauripress/Models/ClotheCatalogue.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class OneOrder {
  final String id;
  final String clotheid;
  String clotheNawa;
  final int qty;
  final int pixi;
  final String lineId;
  DbTalker talk = locator.get<Talk2Orders>();
  static ClotheCatalogue daCatalogue = locator.get<ClotheCatalogue>();
  // Refine this shit afterwards ;

  OneOrder({this.id, this.clotheid, this.qty, this.lineId, this.pixi});

  OneOrder.fromMap(String daId, Map data)
      : id = daId,
        clotheid = data['clotheid'] ?? '',
        qty = data['qty'] ?? 0,
        pixi = data['pixi'] ?? 0,
        lineId = data['lineId'] ?? '',
        clotheNawa = daCatalogue.allClothes
            .firstWhere((elem) => elem.id == data['clotheid'])
            .nawa;

  Map toJson() {
    return {
      'id': id,
      'clotheid': clotheid,
      'qty': qty,
      'lineId': lineId,
    };
  }
}
