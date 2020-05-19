import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Models/OneLine.dart';
import 'package:mauripress/Pages/Administration/Utilisateurs/ManageUsers.dart';
import 'package:mauripress/Pages/OrderListPage/LineDetailsModel.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList_Compos.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';

class LineDetails extends StatefulWidget {
  final OneLine daLine;
  final String heroTag;
  bool isManager = locator.get<PhoneMaster>().rightLevel == 85;
  LineDetails({Key key, this.daLine, this.heroTag}) : super(key: key) {
    // locator.unregister<LineDetailsModel>();
    // if (!locator.isRegistered<LineDetailsModel>())
    //   locator.registerFactory(() => LineDetailsModel());
    // myModel = locator.get<LineDetailsModel>();
    // myModel.setLine(daLine);
    // myModel.getOrdersByLine();
  }
  LineDetailsState createState() => LineDetailsState();
}

class LineDetailsState extends State<LineDetails> {
  LineDetailsModel myModel;
  OneLine daLine;
  bool hasFetched = false;
  @override
  void initState() {
    myModel = LineDetailsModel(widget.daLine);
    print(myModel.oldm.isDlMan);
    daLine = widget.daLine;
    myModel.getOrdersByLine().whenComplete(() {
      setState(() {
        hasFetched = true;
      });
      myModel.add2OpenedLines();
    });
    super.initState();
  }

  rebuildState() {
    setState(() {
      hasFetched = !hasFetched;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        myModel.oldm.fetchOrdersList();
        return true;
      },
      child: Scaffold(
        appBar: MyAppBar(
            title: "Détails",
            trailing: myModel.oldm.isDlMan
                ? null
                : Row(
                    children: <Widget>[
                      if (widget.isManager)
                        MyIconButton(
                          daIcon: MaterialCommunityIcons.map_marker,
                          daColor: Colors.orange,
                          isAsync: true,
                          daFunction: () async {
                            await myModel.openInMaps();
                          },
                        ),
                      // ---------------- The real Deal
                      MyIconButton(
                        daIcon: daLine.isConfirmed
                            ? MaterialCommunityIcons.rewind
                            : MaterialCommunityIcons.check_all,
                        daColor: daLine.isConfirmed ? Colors.pink : midori,
                        isAsync: true,
                        daFunction: () async {
                          await daLine.confirmMe();
                          rebuildState();
                        },
                      ),
                      // MyIconButton(
                      //   daIcon: daLine.isDelivered
                      //       ? MaterialCommunityIcons.rewind
                      //       : MaterialCommunityIcons.check_all,
                      //   daColor: daLine.isDelivered ? Colors.pink : midori,
                      //   isAsync: true,
                      //   daFunction: () async {
                      //     await daLine.deliverMe();
                      //     // myModel.oldm.fetchOrdersList();
                      //     rebuildState();
                      //   },
                      // ),
                    ],
                  )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Align(
                  alignment: Alignment.center,
                  child: OrderCard(daLine: widget.daLine)),
              Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text("Commandes", style: greyTxt.szB.medfont)),
              FractionallySizedBox(
                widthFactor: 0.91,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 30,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff00D4AF),
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [greyShaded]),
                  child: Align(
                    // alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Column(
                          children: myModel.orders.length == 0
                              ? [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                ]
                              : List.generate(
                                  myModel.orders.length,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(
                                            top: index == 0 ? 0 : 15),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Text(
                                                        "${myModel.orders[index].qty}x",
                                                        style: whiteTxt
                                                            .szC.boldfont),
                                                  ),
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      myModel.orders[index]
                                                          .clotheNawa,
                                                      style: whiteTxt
                                                          .szC.medfont)),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      "${myModel.orders[index].pixi}",
                                                      style: whiteTxt
                                                          .szC.boldfont)),
                                            ),
                                          ],
                                        ),
                                      ))),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Text(
                    "Vérifier qu'il s'agisse de la bonne commande avant de procéder !",
                    style: aoiTxt.szB.medfont,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              daLine.isCanceled && !widget.isManager
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(MaterialCommunityIcons.cancel,
                              color: Colors.orange),
                        ),
                        Text(
                          "Cette commande a été annulée !",
                          style: DaWeights(Colors.orange).szB.medfont,
                        )
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: myModel.oldm.isDlMan
                          ? <Widget>[
                              Column(
                                children: <Widget>[
                                  MyIconButton(
                                    daIcon: MaterialCommunityIcons
                                        .map_marker_circle,
                                    daColor: Colors.white,
                                    bgColor: aoi,
                                    splashColor: Colors.white54,
                                    iconSize: 24,
                                    isAsync: true,
                                    elevation: [greyShaded],
                                    daFunction: () async {
                                      await myModel.openInMaps();
                                    },
                                    size: 55,
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    "Ouvrir sur Maps",
                                    style: greyTxt.szB.medfont,
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  MyIconButton(
                                    daIcon: MaterialCommunityIcons.check_all,
                                    daColor: Colors.white,
                                    bgColor: daLine.isDelivered
                                        ? Colors.green
                                        : midori,
                                    splashColor: Colors.white54,
                                    iconSize: 24,
                                    isAsync: true,
                                    elevation: [greyShaded],
                                    daFunction: () async {
                                      await daLine.deliverMe();
                                      rebuildState();
                                    },
                                    size: 55,
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    !daLine.isDelivered
                                        ? "Commande Livrée"
                                        : "Pas encore livrée",
                                    style: greyTxt.szB.medfont,
                                  ),
                                ],
                              ),
                            ]
                          : <Widget>[
                              Column(
                                children: <Widget>[
                                  MyIconButton(
                                    daIcon: daLine.isCanceled
                                        ? MaterialCommunityIcons.restore
                                        : MaterialCommunityIcons.cancel,
                                    daColor: Colors.white,
                                    bgColor: daLine.isCanceled
                                        ? Colors.teal
                                        : Color(0xffFF4A52),
                                    splashColor: Colors.white54,
                                    iconSize: 24,
                                    isAsync: true,
                                    elevation: [greyShaded],
                                    daFunction: () async {
                                      await daLine.cancelMe().whenComplete(() {
                                        rebuildState();
                                      });
                                    },
                                    size: 55,
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    (daLine.isCanceled
                                            ? "Restaurer"
                                            : "Annuler") +
                                        " la commande",
                                    style: greyTxt.szB.medfont,
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  MyIconButton(
                                    daIcon: MaterialCommunityIcons.worker,
                                    daColor: Colors.white,
                                    bgColor: midori,
                                    splashColor: Colors.white54,
                                    iconSize: 24,
                                    elevation: [greyShaded],
                                    isAsync: true,
                                    daFunction: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => ManageUsers(
                                                    isAssignment: true,
                                                    assignedLine: daLine,
                                                  )));
                                    },
                                    size: 55,
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    "Assigner à",
                                    style: greyTxt.szB.medfont,
                                  ),
                                  if (daLine.assignedTo != null)
                                    SizedBox(height: 7),
                                  if (daLine.assignedTo != null)
                                    Text("Assigné à: ${daLine.assignedNawa}",
                                        style: greenTxt.szA.medfont)
                                ],
                              ),
                            ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
