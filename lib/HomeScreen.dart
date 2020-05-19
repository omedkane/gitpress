import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Pages/HistoryPage/HistoryPage.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList.dart';
import 'package:mauripress/Pages/Settings.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:provider/provider.dart';

import 'MakeOrder.dart';
import 'Providers/PhoneMaster.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
  HState createState() => HState();
}

class OnePageView {
  final String title;
  final String image;
  final Color bgColor;
  final Color textColor;
  final String heroTag;
  final Function onTap;
  final double margin;
  final BoxFit imageFit;
  final Alignment imageAlignment;
  final Icon daIcon;
  OnePageView({
    this.title,
    this.image,
    this.bgColor,
    this.textColor,
    this.heroTag,
    this.onTap,
    this.margin,
    this.daIcon,
    this.imageFit,
    this.imageAlignment = Alignment.center,
  });
}

class HState extends State<HomeScreen> {
  bool isLoading = false;
  List<OnePageView> pageViewTiles;

  PageController dacontroller;
  var dacolors = ["assets/images/washmach.jpg", "assets/images/AClock.png"];
  int currentpage = 0;
  @override
  void initState() {
    isLoading = false;
    pageViewTiles = [
      OnePageView(
          bgColor: Color(0xffFCE8C3),
          heroTag: 'washmach',
          title: 'Pressing',
          margin: 15,
          image: 'assets/images/washmach.jpg',
          textColor: Colors.black26,
          imageFit: BoxFit.cover,
          imageAlignment: Alignment.bottomRight),
      OnePageView(
        bgColor: Color(0xffB6E6FF),
        title: 'Historique',
        margin: 15,
        image: 'assets/images/AClock.png',
        textColor: Colors.black38,
        imageFit: BoxFit.contain,
      ),
      OnePageView(
        bgColor: aoi,
        textColor: Colors.white,
        title: 'Tâches',
        margin: 15,
        daIcon: Icon(FontAwesome.tasks, color: Colors.white, size: 80),
        imageFit: BoxFit.contain,
      ),
    ];
    super.initState();
    dacontroller =
        PageController(initialPage: currentpage, viewportFraction: 0.9);
  }

  BoxShadow matShade =
      BoxShadow(blurRadius: 4, offset: Offset(0, 2), color: Color(0x7f646464));
  Widget build(BuildContext context) {
    var dawidth = MediaQuery.of(context).size.width;
    var dauser = Provider.of<PhoneMaster>(context);
    List<Function> functionList = [
      () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return OrderPage();
        }));
      },
      () {
        setState(() {
          isLoading = true;
        });
        dauser.getHistory().whenComplete(() {
          setState(() {
            isLoading = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return HistoryPage();
          }));
        });
      },
      () async {
        // FirebaseMessaging damess = FirebaseMessaging();
        // var daToken = await damess.getToken();

        // var shit = await post(
        //     "https://us-central1-mauripress-d1bc8.cloudfunctions.net/getUserImageUri",
        //     body: {'path': "userprof3.png"});
        // // DocumentSnapshot oula = shit.body;
        // print(shit.body);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => OrderListPage()));
      }
    ];
    // dauser.getHistory();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Salut,", style: blackTxt.cSz(23).medfont),
                        SizedBox(width: 5),
                        Text("${dauser.firstName}",
                            style: aoiTxt.cSz(23).medfont),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return SettingPage();
                        }));
                      },
                      child: Hero(
                        tag: "profpic",
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, boxShadow: [matShade]),
                          child: ClipOval(
                            child: ProfilePicture(
                              imageUri: dauser.imageURL,
                              size: 70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  "Que pouvons-nous faire pour vous ?",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    // fontFamily: 'Roboto',
                    color: Colors.grey,
                    height: 1.5,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 60),
                // Container(
                //   height: 230,
                //   width: 300,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(8),
                //       boxShadow: [matShade],
                //       color: Colors.blue.shade400),
                // ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: pageViewTiles.length,
              controller: dacontroller,
              onPageChanged: (index) {
                // setState(() {
                currentpage = index;
                // });
              },
              itemBuilder: (context, index) {
                var daChild = SizedBox(
                  width: index == 0 ? 350 : 150,
                  child: pageViewTiles[index].daIcon ??
                      Image(
                        image: AssetImage(dacolors[index]),
                        fit: pageViewTiles[index].imageFit,
                      ),
                );
                return Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: functionList[index],
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [ushaded],
                          // color: Color(0xffe0f7fa),
                          color: pageViewTiles[index].bgColor),
                      margin:
                          EdgeInsets.only(right: pageViewTiles[index].margin),
                      height: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(top: 30, left: 15),
                              child: Text(pageViewTiles[index].title,
                                  style: TextStyle(
                                      color: pageViewTiles[index].textColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600))),
                          Expanded(
                            child: Align(
                              alignment: pageViewTiles[index].imageAlignment,
                              child: Container(
                                margin: EdgeInsets.only(right: 0, bottom: 30),
                                height: 230,
                                width: 350,
                                child: pageViewTiles[index].heroTag == null
                                    ? daChild
                                    : Hero(
                                        tag: pageViewTiles[index].heroTag,
                                        child: daChild),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // if (isLoading)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 20,
                width: 20,
                margin: EdgeInsets.only(top: 15, bottom: 15, right: 15),
                child: !isLoading
                    ? SizedBox()
                    : CircularProgressIndicator(
                        backgroundColor: Colors.cyan,
                      ),
              ),
            )
        ],
      ),
    );
  }
}
