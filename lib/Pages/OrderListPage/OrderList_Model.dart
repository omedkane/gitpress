import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mauripress/Models/OneLine.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/Services/DateOperations.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class SearchLines {
  List<OneLine> deliveredLines = [];
  List<OneLine> notYetLines = [];
  List<OneLine> canceledLines = [];
  List<OneLine> allLines = [];
  clearAll() {
    deliveredLines.clear();
    notYetLines.clear();
    canceledLines.clear();
    allLines.clear();
  }
}

class OrderListModel extends ChangeNotifier {
  OrderListModel() {
    initializeDateFormatting();
    thisWeekLinesNb = getDateMap();
  }

  static DbTalker talk = locator.get<Talk2Lines>();
  static PhoneMaster daMaster = locator.get<PhoneMaster>();

  var landingLines = SearchLines(), datedLines = SearchLines();

  List allDates = [
    <DateTime>[],
    <int>[],
    <String>[],
    <int>[]
  ]; // last is for Scores...
  Map<int, int> thisWeekLinesNb = {};
  List openedLines = [];

  bool hasFetched = false;
  bool isSearchingByDate = false;
  bool isDlMan = (daMaster).rightLevel == 87;

  @override
  void dispose() {}

  // switchBusyState({bool how = false}) {
  //   isFetching = how ?? !isFetching;
  // }

  Future fetchOrdersList() async {
    await (isDlMan
            ? talk.ref.where("assignedTo", isEqualTo: daMaster.id)
            : talk.ref)
        .orderBy("dadate", descending: true)
        .getDocuments()
        .then((snap) {
      landingLines.clearAll();
      allDates.forEach((elem) {
        elem.clear();
      });
      int i = 0;
      Timestamp lastMonday = getLastWeekDay(1);
      // mapToZeros(thisWeekLinesNb);
      // mapToZeros(thisWeekLinesNb);
      thisWeekLinesNb = getDateMap();
      snap.documents.forEach((dadoc) {
        Timestamp daStamp = dadoc.data['dadate'];
        DateTime dadate = daStamp.toDate();
        dadate = DateTime(dadate.year, dadate.month, dadate.day);
        OneLine daLine =
            OneLine.fromMap(dadoc.documentID, dadoc.data, frenchDate(dadate));

        if (!allDates[0].contains(dadate)) {
          allDates[0].add(dadate);
          allDates[2].add(frenchDate(dadate));
          allDates[1].add(i);
          // allDates[3].add(0);
        }
        // add Dates Scores...
        if (daStamp.compareTo(lastMonday) >= 0)
          thisWeekLinesNb[dadate.weekday]++;

        landingLines.allLines.add(daLine);
        if (dadoc.data['isCanceled'])
          landingLines.canceledLines.add(daLine);
        else if (dadoc.data['isDelivered'])
          landingLines.deliveredLines.add(daLine);
        else
          landingLines.notYetLines.add(daLine);
        i++;
      });
    });
    hasFetched = true;
    notifyListeners();
    // print(allDates[0][1]);
    // print(thisWeekLinesNb[1]);
  }

  getOrdersByDate({DateTime givenDate}) {
    if (givenDate == null) {
      isSearchingByDate = false;
      notifyListeners();
      return;
    }
    hasFetched = false;
    datedLines.clearAll();
    datedLines.notYetLines = landingLines.notYetLines
        .where((elem) => isSameDay(elem.dadate, givenDate))
        .toList();

    datedLines.canceledLines = landingLines.canceledLines
        .where((elem) => isSameDay(elem.dadate, givenDate))
        .toList();

    datedLines.deliveredLines = landingLines.deliveredLines
        .where((elem) => isSameDay(elem.dadate, givenDate))
        .toList();

    isSearchingByDate = true;
    hasFetched = true;

    notifyListeners();
  }
}
