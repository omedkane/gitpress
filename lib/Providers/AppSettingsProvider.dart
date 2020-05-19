import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AppSettingsProvider with ChangeNotifier {
  bool checkPassBeforeOrder = true;
  Map daLinks = {'Facebook': null, 'Twitter': null, 'Instagram': null};
  
  getSocialLinks() {
    Firestore.instance
        .collection('miscellaneous')
        .document('daLinks')
        .get()
        .then((value) {
      daLinks['Facebook'] = value.data['Facebook'].toString().trim() == ""
          ? null
          : value.data['Facebook'].toString().trim();
      daLinks['Twitter'] = value.data['Twitter'].toString().trim() == ""
          ? null
          : value.data['Twitter'].toString().trim();
      daLinks['Instagram'] = value.data['Instagram'].toString().trim() == ""
          ? null
          : value.data['Instagram'].toString().trim();
    });
  }

  bool get doublecheck => checkPassBeforeOrder;
  set doublecheck(bool shit) {
    checkPassBeforeOrder = shit;
    notifyListeners();
  }
  // switchCheckPass() {
  //   checkPassBeforeOrder = !checkPassBeforeOrder;
  // }
}
