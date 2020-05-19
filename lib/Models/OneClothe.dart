import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class OneClothe {
  final String id;
  final String nawa;
  int pixi;
  final bool local;
  final String imgURI;
  final Color dacolor;
  bool isAvailable;
  DbTalker talk = locator.get<Talk2Clothes>();

  // Refine this shit afterwards ;

  OneClothe(
      {this.id, this.nawa, this.pixi, this.dacolor, this.imgURI, this.local});

  OneClothe.fromDoc(DocumentSnapshot dadoc)
      : id = dadoc.documentID,
        nawa = dadoc.data['nawa'],
        pixi = dadoc.data['pixi'],
        isAvailable = dadoc.data['isAvailable'],
        local = dadoc.data['local'] ?? false,
        imgURI = ((dadoc.data['local']) ? "assets/images/" : "") +
            (dadoc.data['imgURI']),
        dacolor =
            hexToColor(dadoc.data['dacolor'].toString()) ?? Color(0xff59ADFF);
  updatePrice(int daPixi) async {
    if (daPixi > 0) {
      await talk.updateDocument(id, {'pixi': daPixi});
      pixi = daPixi;
    }
  }

  switchAvailability({bool how}) async {
    await talk.updateDocument(id, {'isAvailable': how ?? !isAvailable});
    isAvailable = how ?? !isAvailable;
  }
  // Map toJson() {
  //   return {
  //     'id': id,
  //     'nawa': nawa,
  //     'pixi': pixi,
  //   };
  // }
}
