import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/locator.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage() : dauser = locator.get<PhoneMaster>();
  @override
  _HistoryPageState createState() => _HistoryPageState(dauser.myHistory);
  final dauser;
}

class _HistoryPageState extends State<HistoryPage> {
  PageController dacontroller;
  _HistoryPageState(histoire)
      : myHistory = histoire,
        daorders = histoire.length == 0 ? [] : histoire[0][1];
  // daorders = [];
  final List myHistory;

  var dadates = [
    "13 Mars",
    "12 Mars",
    "11 Mars",
    "10 Mars",
    "9 Mars",
    "8 Mars",
    "7 Mars"
  ];
  var daorders;
  int currpage = 0;
  var dFormatMe;
  @override
  void initState() {
    super.initState();
    dacontroller = PageController(initialPage: 0, viewportFraction: 0.2);
    initializeDateFormatting();
    dFormatMe = DateFormat.MMMMd('fr');
  }

  @override
  Widget build(BuildContext context) {
    var dawidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
              boxShadow: [ushaded],
              color: Color(0xffB6E6FF),
            ),
            child: Image(
              height: 200,
              fit: BoxFit.contain,
              image: AssetImage("assets/images/AClock.png"),
            ),
          ),
          SizedBox(height: 20),
          // ----------------------------
          if (daorders.length != 0)
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: dawidth,
                  child: PageView.builder(
                    controller: dacontroller,
                    // itemCount: daordersDb.length,
                    itemCount: myHistory.length,
                    onPageChanged: (dapage) {
                      setState(() {
                        currpage = dapage;
                        daorders = myHistory[dapage][1];
                      });
                    },
                    itemBuilder: (context, index) => Align(
                      alignment: Alignment.center,
                      child: Container(
                        // width: 200,
                        // padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          dFormatMe.format(myHistory[index][0]),
                          style: TextStyle(
                            color:
                                index == currpage ? Colors.blue : Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    FontAwesome.circle,
                    color: Color(0xff59ADFF),
                    size: 16,
                  ),
                ),
              ],
            ),
          Flexible(
            flex: 1,
            child: daorders.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(MaterialCommunityIcons.timer_sand_empty,
                          size: 80, color: Colors.blue.shade200),
                      SizedBox(height: 20),
                      FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Text(
                            "Aucune commande, veuillez en éffectuer dans la page de pressing !",
                            textAlign: TextAlign.center,
                            style: aoiTxt.szC.medfont,
                          )),
                    ],
                  )
                : ListView.builder(
                    itemCount: daorders.length,
                    itemBuilder: (context, index) {
                      int totalval = 0;
                      List<List<dynamic>> dadata = daorders[index][0];
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Text("${daorders[index][1]}", // Datime
                                  style: whiteTxt.szA.regfont),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [ushaded],
                                  color: Color(0xff59C6FF)),
                            ),
                            Container(
                              width: dawidth * 0.9,
                              height: 185,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              margin: EdgeInsets.only(bottom: 30),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [gshaded],
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    // flex: 1,
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      alignment: WrapAlignment.center,
                                      spacing: 15,
                                      direction: Axis.vertical,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceEvenly,
                                      children: dadata
                                          // .where((elem) => elem != 0)
                                          // .toList()
                                          // .asMap()
                                          // .entries
                                          .map((elem) {
                                        int val = elem[0];
                                        // int index = elem.key;
                                        String cnawa = elem[1];
                                        int price = elem[2];
                                        totalval += price;

                                        return Wrap(
                                          spacing: 10,
                                          children: <Widget>[
                                            Text("${val}x $cnawa",
                                                style: habstyle),
                                            Text(
                                              "$price",
                                              style: aoiTxt.szB.medfont,
                                            )
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: <Widget>[
                                      Spacer(flex: 1),
                                      Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "$totalval",
                                            style: TextStyle(
                                                color: Color(0xff59C6FF),
                                                fontSize: 60,
                                                fontWeight: FontWeight.w700),
                                          )),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "MRU",
                                          style: TextStyle(
                                              color: Color(0xff59C6FF),
                                              fontSize: 20),
                                        ),
                                      ),
                                      (!daorders[index][2])
                                          ? Spacer()
                                          : Flexible(
                                              flex: 1,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Wrap(
                                                  alignment: WrapAlignment.end,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  spacing: 10,
                                                  children: <Widget>[
                                                    Text("Commande livrée",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff00cb53),
                                                            fontSize: 18)),
                                                    Icon(
                                                        MaterialCommunityIcons
                                                            .check_circle,
                                                        color:
                                                            Color(0xff00cb53),
                                                        size: 25),
                                                  ],
                                                ),
                                              ),
                                            )
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
