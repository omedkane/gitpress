import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Models/ClotheCatalogue.dart';
import 'package:mauripress/Models/OneClothe.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/locator.dart';

class PixiScreen extends StatefulWidget {
  @override
  _PixiScreenState createState() => _PixiScreenState();
}

class _PixiScreenState extends State<PixiScreen> {
  static ClotheCatalogue daCatalogue = locator.get<ClotheCatalogue>();
  OneClothe daClothe = daCatalogue.allClothes[0];
  bool isEditingPrice = false;
  var daController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var daHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MyAppBar(
        title: "Prix",
        // elevation: 1,
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Container(
            height: daHeight - 100,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: 30, bottom: 50, left: 20, right: 20),
                  child: Text(
                    "Notez que les prix ne changeront pas pour les commandes dêja éffectuées !",
                    style: aoiTxt.szB.medfont,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          daClothe = daCatalogue.allClothes[index];
                          isEditingPrice = false;
                        });
                      },
                      controller: PageController(
                          initialPage: 0, viewportFraction: 0.87),
                      itemCount: daCatalogue.allClothes.length,
                      itemBuilder: (context, index) => Column(
                            children: <Widget>[
                              FittedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 340,
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                      // color: Colors.lightBlue[50],
                                      color:
                                          daCatalogue.allClothes[index].dacolor,
                                      borderRadius: BorderRadius.circular(15),
                                      // boxShadow: [matShade],
                                      boxShadow: [ushaded]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.contain,
                                        image: AssetImage(daCatalogue
                                            .allClothes[index].imgURI),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(daCatalogue.allClothes[index].nawa,
                                  style: greyTxt.szB.medfont),
                            ],
                          )),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 50),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: SizedBox()),
                            !isEditingPrice
                                ? Text(
                                    daClothe.pixi.toString(),
                                    style: TextStyle(
                                        fontSize: 100,
                                        fontWeight: FontWeight.bold),
                                  )
                                : SizedBox(
                                    width: 120,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: daController,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 100,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: daClothe.pixi.toString(),
                                        contentPadding: EdgeInsets.all(0),
                                        hintStyle: TextStyle(
                                            fontSize: 100,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                            Expanded(
                              child: SizedBox(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 5),
                                  child: Text(
                                    "MRU",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: isEditingPrice
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 140,
                                    child: Column(
                                      children: <Widget>[
                                        MyIconButton(
                                          daIcon: MaterialCommunityIcons.cancel,
                                          daColor: Colors.white,
                                          bgColor: Colors.pink,
                                          splashColor: Colors.white54,
                                          iconSize: 24,
                                          elevation: [greyShaded],
                                          daFunction: () {
                                            setState(() {
                                              isEditingPrice = false;
                                            });
                                          },
                                          size: 55,
                                        ),
                                        SizedBox(height: 7),
                                        Text("Annuler",
                                            style: greyTxt.szA.medfont)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Column(
                                      children: <Widget>[
                                        MyIconButton(
                                          daIcon: MaterialCommunityIcons.check,
                                          daColor: Colors.white,
                                          bgColor: midori,
                                          splashColor: Colors.white54,
                                          iconSize: 24,
                                          elevation: [greyShaded],
                                          isAsync: true,
                                          daFunction: () async {
                                            try {
                                              int daText = int.parse(
                                                  daController.text.trim());
                                              if (daText > 0) {
                                                await daClothe
                                                    .updatePrice(daText);
                                                await daCatalogue
                                                    .fetchClothes();
                                              }
                                              setState(() {
                                                isEditingPrice = false;
                                              });
                                            } catch (e) {}
                                          },
                                          size: 55,
                                        ),
                                        SizedBox(height: 7),
                                        Text("Confirmer",
                                            style: greyTxt.szA.medfont)
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 140,
                                    child: Column(
                                      children: <Widget>[
                                        MyIconButton(
                                          daIcon: daClothe.isAvailable
                                              ? MaterialCommunityIcons.share
                                              : MaterialCommunityIcons.reply,
                                          daColor: Colors.white,
                                          bgColor: daClothe.isAvailable
                                              ? Colors.blueGrey
                                              : Colors.cyan,
                                          splashColor: Colors.white54,
                                          iconSize: 24,
                                          elevation: [greyShaded],
                                          isAsync: true,
                                          daFunction: () async {
                                            await daClothe.switchAvailability();
                                            setState(() {
                                              isEditingPrice = isEditingPrice;
                                            });
                                          },
                                          size: 55,
                                        ),
                                        SizedBox(height: 7),
                                        Text(daClothe.isAvailable ? "Rendre indisponible" : "Rendre disponible",
                                            style: greyTxt.szA.medfont)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Column(
                                      children: <Widget>[
                                        MyIconButton(
                                          daIcon: MaterialCommunityIcons
                                              .circle_edit_outline,
                                          daColor: Colors.grey,
                                          bgColor: Colors.white,
                                          splashColor: Colors.white54,
                                          iconSize: 24,
                                          elevation: [greyShaded],
                                          daFunction: () {
                                            setState(() {
                                              isEditingPrice = true;
                                            });
                                          },
                                          size: 55,
                                        ),
                                        SizedBox(height: 7),
                                        Text("Modifier le prix",
                                            style: greyTxt.szA.medfont)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
