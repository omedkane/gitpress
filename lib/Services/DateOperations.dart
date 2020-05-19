import 'package:cloud_firestore/cloud_firestore.dart';

isSameDay(dateA, dateB) {
  var date1 = (dateA is Timestamp) ? dateA.toDate() : dateA,
      date2 = (dateB is Timestamp) ? dateB.toDate() : dateB;
  return getDateOnly(date1) == getDateOnly(date2);
}

DateTime getDateOnly(DateTime dadate) =>
    DateTime(dadate.year, dadate.month, dadate.day);

Timestamp getDateAWeekAgo() {
  var aweek = 7 * 24 * 60 * 60 * 1000;
  Timestamp timeNow = Timestamp.fromDate(getDateOnly(DateTime.now()));
  Timestamp aWeekAgo = Timestamp.fromMillisecondsSinceEpoch(
      timeNow.millisecondsSinceEpoch - aweek);
  return aWeekAgo;
}

Timestamp getLastWeekDay(int daday) {
  var po = DateTime.now();
  int daSub = po.weekday - daday;
  int rewindDays = daSub < 0 ? (7 + daSub) : daSub;
  var lastMondayToken = getDateOnly(po).millisecondsSinceEpoch -
      ((rewindDays) * 24 * 60 * 60 * 1000);
  Timestamp lastMonday = Timestamp.fromMillisecondsSinceEpoch(lastMondayToken);
  // print(lastMonday.toDate());
  return lastMonday;
}
