import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Habits.dart';
import 'package:mauripress/Pages/Administration/ChartSample.dart';
import 'package:mauripress/Pages/Administration/Dashboard/DashBoard_Compos.dart';
import 'package:mauripress/Pages/Administration/Dashboard/DashBoard_Model.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/Services/DateOperations.dart';
import 'package:mauripress/locator.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen() {
    if (!locator.isRegistered<DashboardModel>())
      locator.registerLazySingleton<DashboardModel>(() => DashboardModel());
  }
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

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

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  initState() {
    var daModel = locator.get<DashboardModel>();
    if (daModel.iniFetch) daModel.updateModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardModel>(
      lazy: true,
      create: (context) => locator.get<DashboardModel>(),
      child: Scaffold(
        appBar: MyAppBar(title: "Tableau de bord"),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Consumer<DashboardModel>(
                builder: (context, daModel, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BarChartSample3(
                      daMap: daModel.ordersNbThisWeek,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 40, bottom: 25, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Résultats de la semaine:",
                              style: blackTxt.szB.medfont,
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Vue d'ensemble des progressions hebdomadaires",
                              style: aoiTxt.szA.regfont,
                            )
                          ],
                        )),
                    SizedBox(
                      height: 230,
                      child: PageView.builder(
                          controller: PageController(viewportFraction: 0.8),
                          itemCount: daModel.daStats.length,
                          itemBuilder: (context, index) {
                            // print("waioi");
                            var daStat = daModel.daStats[index];
                            return GestureDetector(
                              onTap: () {
                                // DbTalker talk = locator.get<Talk2Lines>();
                                // talk.updateAll({
                                //   'deliveryDate': null,
                                //   'isDelivered': false
                                // });
                                getLastWeekDay(1);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  height: 200,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: daStat.daColor,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: tailShadow2,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Icon(daStat.daIcon,
                                                color: daStat.textWhite
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          Text(daStat.title,
                                              style: (daStat.textWhite
                                                      ? whiteTxt
                                                      : blackTxt)
                                                  .szB
                                                  .medfont)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            daStat.value,
                                            style: TextStyle(
                                                fontSize: 48,
                                                color: daStat.textWhite
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontFamily: 'Haboro',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          if (daStat.isPixi)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text("MRU",
                                                  style: (daStat.textWhite
                                                          ? whiteTxt
                                                          : blackTxt)
                                                      .szC
                                                      .boldfont),
                                            )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 30, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Plus d'informations:",
                              style: blackTxt.szB.medfont,
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Vue d'ensemble de la progression totale",
                              style: aoiTxt.szA.regfont,
                            ),
                            SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: FractionallySizedBox(
                                widthFactor: 1,
                                child: Container(
                                  child: Wrap(
                                    // direction: Axis.vertical,
                                    runSpacing: 10,
                                    children: <Widget>[
                                      InfoRow(
                                        isPixi: true,
                                        title: "Chiffre D'affaires Total",
                                        // value: "530,000",
                                        // value: "${daModel.turnOver}",
                                        value:
                                            "${formatMe.format(daModel.turnOver)}",
                                        leading: CircleIcon(
                                          color: Colors.white,
                                          iconColor: Colors.teal,
                                          daIcon:
                                              MaterialCommunityIcons.cash_usd,
                                        ),
                                      ),
                                      InfoRow(
                                        title: "Nombre D'Utilisateurs",
                                        // value: "26",
                                        value: daModel.usersNb.toString(),
                                        leading: CircleIcon(
                                          color: Colors.white,
                                          iconColor: Colors.blue,
                                          daIcon: MaterialCommunityIcons
                                              .account_multiple,
                                        ),
                                      ),
                                      InfoRow(
                                        title: "Nombre De Clients",
                                        // value: "12",
                                        value: daModel.customersNb.toString(),
                                        leading: CircleIcon(
                                          color: Colors.white,
                                          iconColor: Colors.pink,
                                          daIcon: MaterialCommunityIcons
                                              .nature_people,
                                        ),
                                      ),
                                      InfoRow(
                                        title: "Nombre De Livreurs",
                                        // value: "4",
                                        value: daModel.dlmNb.toString(),
                                        leading: CircleIcon(
                                          color: Colors.white,
                                          iconColor: Colors.purple,
                                          daIcon: MaterialCommunityIcons
                                              .truck_delivery,
                                        ),
                                      ),
                                      InfoRow(
                                        title: "Nombre De Gérants",
                                        // value: "2",
                                        value: daModel.managersNb.toString(),
                                        leading: CircleIcon(
                                          color: Colors.white,
                                          iconColor: Colors.cyan,
                                          daIcon: MaterialCommunityIcons
                                              .truck_delivery,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
