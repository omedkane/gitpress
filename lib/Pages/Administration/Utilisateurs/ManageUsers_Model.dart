import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mauripress/Models/OneLine.dart';
import 'package:mauripress/Models/OneUser.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/Services/DistanceCalculator.dart';
import 'package:mauripress/locator.dart';

class ManageUsersModel with ChangeNotifier {
  List<OneUser> allUsers = [];
  List<OneUser> searchResults = [];
  List<OneUser> closestUsers = [];
  bool staffOnly = false;
  bool isAssignment;
  bool isFetching = false;
  OneLine daLine;
  OneUser orderingUser;
  int test = 0;
  // TextEditingController sControl = TextEditingController();
  ManageUsersModel() {
    initModel();
  }
  Future initModel(
      {bool staff = false,
      bool isAssignment = false,
      OneLine assignedLine}) async {
    staffOnly = staff;
    this.isAssignment = isAssignment;
    this.daLine = assignedLine;

    await getUsers();
    searchUser("");
    if (isAssignment) {
      orderingUser = allUsers.firstWhere(
          (elem) => elem.id == assignedLine.userid,
          orElse: () => null);
      if (orderingUser.gpsPos != null) {
        closestUsers = [];
        closestUsers = sortByClosest(orderingUser.gpsPos, searchResults);
        // print(closestUsers);
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {}
  Future getUsers() async {
    isFetching = true;
    notifyListeners();

    DbTalker talk2Users = locator.get<Talk2Users>();
    await talk2Users.ref
        // .where('rightLevel', isEqualTo: 83)
        .getDocuments()
        .then((snap) {
      allUsers.clear();
      snap.documents.forEach((elem) {
        allUsers.add(OneUser.fromMap(elem.documentID, elem.data));
      });
    });
    isFetching = false;
    notifyListeners();
  }

  incTest() {
    test++;
    notifyListeners();
  }

  searchUser(String nawa) {
    searchResults.clear();

    if (nawa.trim() == "") {
      searchResults.addAll(isAssignment
          ? allUsers.where((elem) => elem.rightLevel == 87)
          : (!staffOnly
              ? allUsers
              : allUsers.where(
                  (elem) => (elem.rightLevel == 85 || elem.rightLevel == 87))));
    } else {
      searchResults.addAll(allUsers.where((elem) {
        bool cond1 = true;
        if (isAssignment)
          cond1 = (elem.rightLevel == 87);
        else if (staffOnly)
          cond1 = (elem.rightLevel == 87 || elem.rightLevel == 85);
        return cond1 &&
            (elem.fullName.toLowerCase().contains(nawa.toLowerCase()));
      }));
    }
    notifyListeners();
  }
}
