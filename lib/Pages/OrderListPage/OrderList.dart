import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Pages/HistoryPage/ListDatesDialog.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList_Model.dart';
import 'package:mauripress/Pages/OrderListPage/TabContent.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/locator.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatelessWidget {
  final bool isDLMan;
  List<Widget> daTabs;
  List<Widget> daTabPages;
  OrderListModel myModel;
  OrderListPage({this.isDLMan = false}) {
    if (!locator.isRegistered<OrderListModel>())
      locator.registerLazySingleton(() => OrderListModel());
    myModel = locator.get<OrderListModel>();
    myModel.fetchOrdersList();
    // initialise tabs !
    daTabs = isDLMan
        ? [
            Tab(
                icon: Icon(MaterialCommunityIcons.close, size: 20),
                text: "En attente"),
            Tab(
                icon: Icon(MaterialCommunityIcons.check, size: 20),
                text: "Éffectué(s)"),
            Tab(
                icon: Icon(MaterialCommunityIcons.cancel, size: 20),
                text: "Annulée(s)")
          ]
        : [
            Tab(
                icon: Icon(MaterialCommunityIcons.close, size: 20),
                text: "Pas Livrée(s)"),
            Tab(
                icon: Icon(MaterialCommunityIcons.check, size: 20),
                text: "Livrée(s)"),
            Tab(
                icon: Icon(MaterialCommunityIcons.cancel, size: 20),
                text: "Annulée(s)")
          ];

    daTabPages = [
      TabContent(),
      TabContent(isDelivered: true),
      TabContent(isCanceled: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: daTabs.length,
      child: ChangeNotifierProvider<OrderListModel>(
        create: (context) => locator.get<OrderListModel>(),
        child: Scaffold(
          floatingActionButton: Consumer<OrderListModel>(
              builder: (context, daModel, child) => FloatingActionButton(
                    onPressed: () {
                      int index = 0;
                      var daOptionList = [];
                      daOptionList.add(SimpleDialogOption(
                        onPressed: () {
                          myModel.getOrdersByDate();
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            "Tout",
                            style: aoiTxt.szB.medfont,
                          ),
                        ),
                      ));
                      daOptionList.addAll(myModel.allDates[2].map((elem) {
                        var i = index;
                        var shit = SimpleDialogOption(
                          onPressed: () {
                            myModel.getOrdersByDate(
                                givenDate: myModel.allDates[0][i]);
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              elem,
                              style: aoiTxt.szB.medfont,
                            ),
                          ),
                        );
                        index++;
                        return shit;
                      }).toList());
                      dialogMe(context, optionList: daOptionList);
                    },
                    child: Icon(
                      MaterialCommunityIcons.calendar,
                      color: daModel.isSearchingByDate ? Colors.white : aoi,
                    ),
                    backgroundColor:
                        myModel.isSearchingByDate ? Colors.blue : Colors.white,
                  )),
          appBar: AppBar(
            leading: MyIconButton(
              daIcon: AntDesign.left,
              size: 30,
              daColor: aoi,
              daFunction: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Commandes", style: aoiTxt.szB.medfont),
            centerTitle: true,
            elevation: 2,
            backgroundColor: Colors.white,
            bottom: TabBar(
                labelColor: aoi,
                indicatorColor: aoi,
                // labelStyle: blackTxt.szA.medfont,
                // unselectedLabelStyle: blackTxt.szA.medfont,
                tabs: daTabs),
          ),
          body: TabBarView(children: daTabPages),
        ),
      ),
    );
  }
}
