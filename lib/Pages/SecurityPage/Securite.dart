import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/Components/BusyButton.dart';
import 'package:mauripress/Providers/AppSettingsProvider.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:provider/provider.dart';

class SecurePage extends StatefulWidget {
  @override
  _SecurePageState createState() => _SecurePageState();
}

class _SecurePageState extends State<SecurePage> with TickerProviderStateMixin {
  bool settingpass = false;
  bool errthere = false;
  bool goodnews = false;
  String errmsg = "";

  var passctrl = TextEditingController(), newpassctrl = TextEditingController();

  TickerProvider daticker;
  @override
  void initState() {
    super.initState();
    daticker = this;
  }

  @override
  Widget build(BuildContext context) {
    var daheight = MediaQuery.of(context).size.height;
    var dawidth = MediaQuery.of(context).size.width;
    var dauser = Provider.of<PhoneMaster>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: barMe(context: context, title: "Sécurité", issetting: false),
      body: SingleChildScrollView(
        child: Container(
          // height: daheight - 90,
          width: dawidth,
          child: Column(
            children: <Widget>[
              // SizedBox(height: 50),
              // SizedBox(height: 50),
              FlatButton(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Icon(MaterialCommunityIcons.check_all)),
                    // SizedBox(width: 30),
                    Flexible(
                      flex: 1,
                      child: Text(
                          "Éxiger l'authentification avant chaque commande",
                          style: habstyle),
                    ),
                    Container(
                        child: Consumer<AppSettingsProvider>(
                      builder: (context, dasets, child) => Switch(
                        activeColor: Color(0xff00cb53),
                        value: dasets.checkPassBeforeOrder,
                        onChanged: (val) {
                          dasets.doublecheck = val;
                        },
                      ),
                    ))
                  ],
                ),
              ),
              FlatButton(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                onPressed: () {
                  setState(() {
                    settingpass = !settingpass;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: Icon(
                                MaterialCommunityIcons.fingerprint,
                                color: settingpass
                                    ? Color(0xff59ADFF)
                                    : Colors.black,
                              )),
                          // SizedBox(width: 30),
                          Container(
                            child: Text("Changer le mot de passe",
                                style: TextStyle(
                                    color: settingpass
                                        ? Color(0xff59ADFF)
                                        : Colors.black,
                                    fontSize: 17)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: Icon(
                          FontAwesome.circle,
                          color: settingpass ? Color(0xff59ADFF) : Colors.black,
                          size: 16,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                // flex: 1,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: settingpass ? 1 : 0,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Wrap(
                        direction: Axis.vertical,
                        spacing: 15,
                        children: <Widget>[
                          Text("Ancien mot de passe :",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff59ADFF),
                              )),
                          Container(
                            alignment: Alignment.center,
                            height: 57,
                            width: 366,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xffF0F8FF), boxShadow: [gshaded]),
                            child: TextField(
                              controller: passctrl,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Saisir le vieux mot de passe",
                                  hintStyle: TextStyle(
                                      fontSize: 17, color: Colors.grey)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      Wrap(
                        direction: Axis.vertical,
                        spacing: 15,
                        children: <Widget>[
                          Text("Nouveau mot de passe :",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xff59ADFF),
                              )),
                          Container(
                            alignment: Alignment.center,
                            height: 57,
                            width: 366,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xffF0F8FF), boxShadow: [gshaded]),
                            child: TextField(
                              controller: newpassctrl,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Saisir le nouveau mot de passe",
                                  hintStyle: TextStyle(
                                      fontSize: 17, color: Colors.grey)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Wrap(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          direction: Axis.vertical,
                          spacing: 5,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            BusyButton(
                              title: "Confirmer",
                              todo: () async {
                                setState(() {
                                  errthere = false;
                                });
                                await dauser
                                    .setNewPass(passctrl.text, newpassctrl.text)
                                    .then((val) {
                                  print(val);
                                  if (val is bool) {
                                    if (val) {
                                      setState(() {
                                        goodnews = true;
                                        errmsg =
                                            "Mot de passe changé avec succés !";
                                        errthere = true;
                                      });
                                    }
                                  } else if (val is String) {
                                    print("waa");
                                    setState(() {
                                      goodnews = false;
                                      errthere = true;
                                      errmsg = val;
                                    });
                                  }
                                });
                              },
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Annuler",
                                style:
                                    TextStyle(fontSize: 17, color: Colors.grey),
                              ),
                            ),
                            AnimatedSize(
                              vsync: daticker,
                              duration: Duration(milliseconds: 200),
                              child: !errthere
                                  ? SizedBox()
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          goodnews
                                              ? MaterialCommunityIcons
                                                  .check_circle
                                              : MaterialCommunityIcons
                                                  .close_circle,
                                          color: goodnews
                                              ? Colors.green
                                              : Colors.orange,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          errmsg,
                                          style: TextStyle(
                                              color: goodnews
                                                  ? Colors.green
                                                  : Colors.orange,
                                              fontSize: 17),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
