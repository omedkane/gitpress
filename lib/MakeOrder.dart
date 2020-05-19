import 'package:flutter/material.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Billing/DaBill_Animator.dart';
import 'package:mauripress/Models/OneClothe.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:provider/provider.dart';

import 'Providers/KartProvider.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);
  OrderState createState() => OrderState();
}

class OrderState extends State<OrderPage> {
  int datotal = 0;
  PageController dacontroller;
  int whichpage = 0;
  OneClothe daClothe;

  Widget build(BuildContext context) {
    var daheight = MediaQuery.of(context).size.height;
    var dawidth = MediaQuery.of(context).size.width;
    final dacart = Provider.of<CartProvider>(context, listen: false);
    if (daClothe == null) {
      setState(() {
        daClothe = dacart.dakart[0].daclothe;
      });
    }

    @override
    void initState() {
      super.initState();
      dacontroller = PageController(initialPage: 0, viewportFraction: 0.8);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: "washmach",
            child: Container(
              width: dawidth,
              height: 280,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(80)),
                  boxShadow: [ushaded],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/washmach.jpg"))),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: daClothe.isAvailable ? true : false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Ink(
                    decoration: ShapeDecoration(
                        shadows: kElevationToShadow[3],
                        color: Color(0xffBDBDBD),
                        shape: CircleBorder()),
                    child: IconButton(
                      onPressed: () {
                        // setState(() {
                        dacart.incQty(whichpage);
                        //   updateTotal();
                        // });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: dawidth,
                  height: 220,
                  child: PageView.builder(
                    itemCount: dacart.dakart.length,
                    controller: dacontroller,
                    onPageChanged: (index) {
                      setState(() {
                        whichpage = index;
                        daClothe = dacart.dakart[index].daclothe;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: Alignment.center,
                        child: Consumer<CartProvider>(
                          // selector: (context, cartList) => cartList.dakart,
                          builder: (context, myCart, child) => Container(
                              height: 210,
                              width: 340,
                              // padding: EdgeInsets.only(left: 30, right: 30),
                              decoration: BoxDecoration(
                                  // color: Colors.lightBlue[50],
                                  color: myCart.dakart[index].daclothe.dacolor,
                                  borderRadius: BorderRadius.circular(15),
                                  // boxShadow: [matShade],
                                  boxShadow: [ushaded]),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: !myCart
                                            .dakart[index].daclothe.isAvailable
                                        ? Center(
                                            child: Text(
                                              "Indisponible pour le moment",
                                              style: whiteTxt.szC.boldfont,
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : Center(
                                            child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  "${myCart.dakart[index].qty}x",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      "${myCart.dakart[index].pixi}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25)),
                                                  SizedBox(width: 5),
                                                  Text("MRU",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            ],
                                          )),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    // alignment: Alignment.centerRight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Image(
                                          fit: BoxFit.contain,
                                          height: 120,
                                          image: AssetImage(myCart
                                              .dakart[index].daclothe.imgURI),
                                        ),
                                        Text(myCart.dakart[index].daclothe.nawa,
                                            style: whiteTxt.szC.medfont),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 25),

                // elevation: 3,
                // shape: BoxShape.circle,

                Visibility(
                  visible: daClothe.isAvailable ? true : false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Ink(
                    decoration: ShapeDecoration(
                        shadows: kElevationToShadow[3],
                        color: Color(0xffBDBDBD),
                        shape: CircleBorder()),
                    child: IconButton(
                      onPressed: () {
                        // setState(() {
                        dacart.decQty(whichpage);
                        // updateTotal();
                        // });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),

                // Container(
                //   height: 50,
                //   width: 50,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(25),
                //     color: Color(0xffBDBDBD),
                //     boxShadow: kElevationToShadow[3],
                //   ),
                //   child:
                // ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        inkButton(
                            onPressed: () {
                              dacart.resetAll();
                            },
                            bgColor: Colors.white,
                            color: Colors.cyan[200],
                            shadow: [ushaded],
                            tooltip: "Remettre à zéro",
                            icon: Icons.settings_backup_restore),
                        Hero(
                          tag: "dabill",
                          child: Material(
                            color: Colors.white,
                            type: MaterialType.circle,
                            elevation: 3,
                            child: inkButton(
                                bgColor: Color(0xff00cb53),
                                shadow: [],
                                tooltip: "Confirmer",
                                onPressed: () {
                                  if (!dacart.cartIsEmpty())
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return Billanime();
                                    }));
                                },
                                icon: Icons.check),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: 100,
                    width: dawidth,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: Text("Total :",
                                style: TextStyle(
                                  color: Color(0xff26C6DA),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                          ),
                        ),
                        Container(
                          child: Selector<CartProvider, int>(
                            selector: (context, cart) => cart.totalPixi,
                            builder: (context, shit, child) => Text(
                              "${(shit)}",
                              style: TextStyle(
                                  color: Color(0xff26C6DA),
                                  fontSize: 50,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "MRU",
                              style: TextStyle(
                                  color: Color(0xff26C6DA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
