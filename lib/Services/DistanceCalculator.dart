import 'dart:math';

import 'package:mauripress/Models/OneUser.dart';

const double earthRadius = 6378;
haversineOf(double daShit) {
  return (1 - cos(daShit)) / 2;
}

archaversinOf(double daShit) {
  return acos(1 - (2 * daShit));
}

deg2rad(double daShit) {
  return daShit * (pi / 180);
}

distanceBetween(double latA, double longA, double latB, double longB) {
  latA = deg2rad(latA);
  latB = deg2rad(latB);
  longA = deg2rad(longA);
  longB = deg2rad(longB);
  var havOfTeta = haversineOf(latB - latA) +
      cos(latA) * cos(latB) * haversineOf(longB - longA);
  var teta = archaversinOf(havOfTeta);
  return teta * earthRadius;
}

havTest() async {
  print(distanceBetween(35, 130, 21, 39));
}

sortByClosest(OneLocation needle, List<OneUser> listOfUsers) {
  List<OneUser> oneShit =
      listOfUsers.where((user) => user.gpsPos != null).toList();
  oneShit.sort((a, b) {
    var needleToA = distanceBetween(a.gpsPos.latitude, a.gpsPos.longitude,
            needle.latitude, needle.longitude),
        needleToB = distanceBetween(b.gpsPos.latitude, b.gpsPos.longitude,
            needle.latitude, needle.longitude);

    if (needleToA > needleToB)
      return 1;
    else if (needleToA == needleToB)
      return 0;
    else
      return -1;
  });
  return oneShit;
}
