import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList.dart';
import 'package:one_context/one_context.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  // _fcm.
  Future initialise(context) async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>OrderListPage()));
        // print(message['notification']['body']);
        OneContext().showSnackBar(
            builder: (_) => SnackBar(
                  content: Text('On vous assigné une nouvelle tâche !'),
                  action: SnackBarAction(
                      label: "Ouvrir",
                      onPressed: () {
                        OneContext().pushReplacement(
                            MaterialPageRoute(builder: (_) => OrderListPage()));
                      }),
                ));
      },
      onLaunch: (Map<String, dynamic> message) async {
        OneContext().push(MaterialPageRoute(builder: (_) => OrderListPage()));
      },
      onResume: (Map<String, dynamic> message) async {
        OneContext().push(MaterialPageRoute(builder: (_) => OrderListPage()));
      },
    );
  }
}
