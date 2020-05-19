// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// FlutterLocalNotificationsPlugin daPlugin = FlutterLocalNotificationsPlugin();

// Future initNotifications() async {
//   var initSettingsAndroid = AndroidInitializationSettings('app_icon');
//   var initSettingsIos = IOSInitializationSettings();
//   var initSettings =
//       InitializationSettings(initSettingsAndroid, initSettingsIos);
//   await daPlugin.initialize(initSettings,
//       onSelectNotification: (String payload) async {
//     print("Heeeeeeelll Yeaaah");
//   });
// }

// Future displayNotification() async {
//   var androidSpecifics = AndroidNotificationDetails(
//       'cd17', 'Daniel Hardman', 'Got ousted by force that man !',
//       importance: Importance.Max, priority: Priority.High);
//   var iosSpecifics = IOSNotificationDetails();
//   var daSpecifics = NotificationDetails(androidSpecifics, iosSpecifics);
//   await daPlugin.show(0, "Nouvelle Tâche Pour Vous",
//       'Une nouvelle commande attends la livraison', daSpecifics,
//       payload: 'item x');
// }
