import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/Pages/Administration/Utilisateurs/ManageUsers_Model.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList_Model.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/Services/DateOperations.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class OneStatCard {
  final String title;
  final String value;
  final IconData daIcon;
  final Color daColor;
  final bool textWhite;
  final bool isPixi;

  OneStatCard(
      {this.isPixi = false,
      this.textWhite = true,
      this.title,
      this.value,
      this.daIcon,
      this.daColor});
}

class DashboardModel with ChangeNotifier {
  DashboardModel() {
    if (!locator.isRegistered<ManageUsersModel>())
      locator.registerLazySingleton<ManageUsersModel>(() => ManageUsersModel());
    if (!locator.isRegistered<OrderListModel>())
      locator.registerLazySingleton(() => OrderListModel());
    userModel = locator.get<ManageUsersModel>();
    orderModel = locator.get<OrderListModel>();

    initModel().whenComplete(() async {
      await updateModel();
      iniFetch = true;
    });
  }

  Future initModel() async {
    getTurnOverLocale();
    getThisWeekTurnOverLocale();
    getUsersNumberLocale();

    notifyListeners();
    // await updateModel();
  }

  updateModel() async {
    // await getTurnOver();
    // await getThisWeekTurnOver();
    // await getUsersNumber();
    // await getThisWeekUsersNumber();

    await getThisWeekUsersNumber();
    await orderModel.fetchOrdersList();
    await initModel();
    daStats = getCarouselData();
    getOrdersForChart();
    // notifyListeners();
  }

  ManageUsersModel userModel;
  OrderListModel orderModel;
  DbTalker talkLines = locator.get<Talk2Lines>();
  DbTalker talkUsers = locator.get<Talk2Users>();
  bool iniFetch = false;
  int usersNb = 0;
  int managersNb = 0;
  int dlmNb = 0;
  int customersNb = 0;
  int usersNbThisWeek = 0;
  int turnOver = 0;
  int turnOverThisWeek = 0;
  int delivriesNb = 0;
  Map<int, int> ordersNbThisWeek = getDateMap();
  List<OneStatCard> daStats = [
    OneStatCard(
        title: "Chiffres d'affaires",
        value: "...",
        isPixi: false,
        daIcon: MaterialCommunityIcons.cash_multiple,
        daColor: Colors.blue),
    OneStatCard(
        title: "Nombres d'utilisateurs",
        value: "...",
        daIcon: MaterialCommunityIcons.account_multiple,
        daColor: Colors.pink),
    OneStatCard(
        title: "Livraisons éffectuées",
        value: "...",
        textWhite: false,
        daIcon: MaterialCommunityIcons.truck_delivery,
        daColor: Color(0xfff0b000)),
  ];
  Timestamp lastMonday = getLastWeekDay(1);

  getCarouselData() => [
        OneStatCard(
            title: "Chiffres d'affaires",
            value: turnOverThisWeek.toString(),
            isPixi: true,
            daIcon: MaterialCommunityIcons.cash_multiple,
            daColor: Colors.blue),
        OneStatCard(
            title: "Nombres d'utilisateurs",
            value: usersNbThisWeek.toString(),
            daIcon: MaterialCommunityIcons.account_multiple,
            daColor: Colors.pink),
        OneStatCard(
            title: "Livraisons éffectuées",
            value: delivriesNb.toString(),
            textWhite: false,
            daIcon: MaterialCommunityIcons.truck_delivery,
            daColor: Color(0xfff0b000)),
      ];

  @override
  dispose() {}

  getUsersNumberLocale() {
    usersNb = userModel.allUsers.length;
    dlmNb = 0;
    managersNb = 0;

    userModel.allUsers.forEach((elem) {
      switch (elem.rightLevel) {
        case 87:
          dlmNb++;
          break;
        case 85:
          managersNb++;
          break;
        default:
          customersNb++;
      }
    });
  }

  getUsersNumber() async {
    await userModel.initModel();
    getUsersNumberLocale();
  }

  getThisWeekUsersNumber() async {
    await talkUsers.ref
        .where('creationDate', isGreaterThanOrEqualTo: lastMonday)
        .getDocuments()
        .then((val) {
      usersNbThisWeek = val.documents.length;
    });
  }

  getTurnOverLocale() {
    turnOver = 0;
    orderModel.landingLines.deliveredLines.forEach((elem) {
      turnOver += elem.totalPrice;
    });
  }

  getTurnOver() async {
    await orderModel.fetchOrdersList().then((value) {
      turnOver = 0;
      orderModel.landingLines.deliveredLines.forEach((elem) {
        turnOver += elem.totalPrice;
      });
    });
    getTurnOverLocale();
  }

  getThisWeekTurnOverLocale() {
    turnOverThisWeek = 0;
    var thisWeekDeliveries = orderModel.landingLines.deliveredLines
        .where((elem) => elem.dadate.compareTo(lastMonday) >= 0);

    delivriesNb = thisWeekDeliveries.length;

    thisWeekDeliveries.forEach((elem) {
      turnOverThisWeek += elem.totalPrice;
    });
  }

  getThisWeekTurnOver() async {
    // Fix this shit;
    orderModel.fetchOrdersList();
    getThisWeekTurnOverLocale();
  }

  getOrdersForChart() {
    ordersNbThisWeek = orderModel.thisWeekLinesNb;
  }
}
