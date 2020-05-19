import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mauripress/HomeScreen.dart';
import 'package:mauripress/Mahome_SignupAnime.dart';
import 'package:mauripress/Models/ClotheCatalogue.dart';
import 'package:mauripress/Pages/AddLocationPage/AddLocationScreen.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/locator.dart';
import 'package:mauripress/push_notifications.dart';

import 'Mahome_EnterAnime.dart';

class Dahome extends StatefulWidget {
  Dahome(
      {Key key,
      this.title,
      @required List<AnimationController> controllers,
      matick})
      : daanime = EntAnime(controllers[0]),
        signanime = SignupAnime(controllers[1]),
        daticker = matick,
        super(key: key);

  final EntAnime daanime;
  final SignupAnime signanime;
  final String title;
  final TickerProvider daticker;
  GlobalKey akey = GlobalKey();

  // Dastate createState() => Dastate(daanime, signanime);
  Dastate createState() => Dastate();
  // @override
}

class Dastate extends State<Dahome> {
  // Dastate(this.widget.daanime, this.loganime);
  // final EntAnime widget.daanime;
  // final SignupAnime loganime;
  bool cansignup = false;
  bool gonsignup = false;
  var ectrl = TextEditingController(),
      passctrl = TextEditingController(),
      fnamectrl = TextEditingController(),
      lnamectrl = TextEditingController();

  bool isworking = false;
  bool errthere = false;
  bool isSigningLastUser = true;
  String errmsg = "";
  // TextEditingController nawactrl = TextEditingController();
  // TextEditingController prenawactrl = TextEditingController();
  var listofNodes = List.generate(4, (index) => FocusNode());

  Future signInLastUser(BuildContext context) async {
    var _auth = FirebaseAuth.instance;
    var user = await _auth.onAuthStateChanged.first;
    // return user;
    if (user != null) await dauser.setUser(user);
    return user != null;
  }

  @override
  void initState() {
    // signInLastUser().then((value){
    //   if(value == null)
// animated shit agaain
    // });
    super.initState();
  }

  // print("waa");

  void switchwork(int dabit) {
    setState(() {
      isworking = dabit == 1 ? true : false;
    });
  }

  var catalogue = locator.get<ClotheCatalogue>();

  void checkLogResult(val) {
    if (val is bool) {
      if (val)
        catalogue.fetchClothes().whenComplete(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      gonsignup ? AddLocationScreen() : HomeScreen()));
        });
    } else
      setState(() {
        errmsg = val;
        errthere = true;
      });
  }

  int nbBuilds = 0;

  PhoneMaster dauser = locator.get<PhoneMaster>();

  @override
  Widget build(BuildContext context) {
    var dawidth = MediaQuery.of(context).size.width;
    var daheight = MediaQuery.of(context).size.height;
    double hres(double shit) => daheight * (shit / 830.857);
    double wres(double shit) => dawidth * (shit / 411.42857);

    if (nbBuilds == 0) {
      signInLastUser(context).then((value) {
        if (value) {
          checkLogResult(true);
        } else
          setState(() {
            isSigningLastUser = false;
          });
      });
      var notifier = locator.get<PushNotificationService>();
      notifier.initialise(context);
    }
    nbBuilds++;
    // print("rebuild");

    // debugPrint("w: $dawidth , h: $daheight");
    // var ze =
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // backgroundColor: Color(0xFF0F111A),
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation:
            cansignup ? widget.signanime.controller : widget.daanime.controller,
        builder: (context, child) {
          return SingleChildScrollView(
            // alignment: Alignment.center,
            child: Container(
              height: daheight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Spacer(flex: 1),
                  // SizedBox(height: widget.daanime.topmargin.value),
                  ClipRect(
                    child: Align(
                      heightFactor: widget.daanime.topmargin.value,
                      child: FadeTransition(
                        opacity: widget.daanime.opanime,
                        child: Padding(
                          padding: EdgeInsets.only(left: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: widget.daanime
                                    .capsize(hres(50), hres(0))
                                    .value,
                              ),
                              Text(
                                "Bienvenue sur",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Mauri",
                                    style: TextStyle(
                                        color: Color(0xff40c4ff),
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Pressing",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  // Container(
                  //   height: widget.daanime
                  //       .capsize(hres(70.0), hres(0))
                  //       .value, //polka ? 40 : 0,
                  // ),
                  SizedBox(
                    height: widget.daanime.capsize(hres(50), hres(0)).value,
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      // height: daheight * 0.7,//widget.daanime.capsize(470.0, 470.0).value,
                      width: dawidth * 0.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: widget.daanime.icontotop.value,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: SizedBox(
                                    width: widget.daanime
                                        .getsize(dawidth, dawidth * 0.20)
                                        .value, //dawidth * 0.85,
                                    // margin: EdgeInsets.only(right: 30),
                                    child: Image(
                                      // width: dawidth * 0.8,
                                      image: AssetImage(
                                          "assets/images/Whosbad.png"),
                                    ),
                                  ),
                                ),
                                foldable(
                                  dachild: FadeTransition(
                                    opacity: widget.daanime.r_opanime,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Mauri",
                                            style: TextStyle(
                                                color: Color(0xff40c4ff),
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Pressing",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          foldable(
                            dachild: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: SizedBox(
                                // height: 100,
                                width: dawidth * 0.8,
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: Text(
                                      gonsignup
                                          ? "Inscrivez-vous et commencez à utiliser MauriPress !"
                                          : "Connectez-vous pour continuer à commander",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.cyan[300])),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: widget.daanime.capsize(0.0, 20.0).value,
                          ),
                          foldable(
                            dachild: FadeTransition(
                              opacity: widget.daanime.r_opanime,
                              child: Column(
                                children: <Widget>[
                                  myInput("Email", false, dawidth, ectrl,
                                      context, listofNodes, 0,
                                      keyType: TextInputType.emailAddress),
                                  SizedBox(height: 20),
                                  myInput("Mot de passe", true, dawidth,
                                      passctrl, context, listofNodes, 1)
                                ],
                              ),
                            ),
                          ),
                          if (cansignup)
                            ClipRect(
                              child: Align(
                                heightFactor: widget.signanime.qhfact.value,
                                child: FadeTransition(
                                  opacity: widget.signanime.qopanime,
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    spacing: 20,
                                    children: <Widget>[
                                      SizedBox(),
                                      myInput("Prénom", false, dawidth,
                                          fnamectrl, context, listofNodes, 2),
                                      myInput("Nom", false, dawidth, lnamectrl,
                                          context, listofNodes, 3),
                                      // myInput("Adresse", false, dawidth,
                                      //     daheight),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          foldable(
                            dachild: Padding(
                              padding: const EdgeInsets.only(top: 35),
                              child: SizedBox(
                                width: dawidth * 0.9,
                                child: Center(
                                  child: AnimatedSize(
                                    vsync: widget.daticker,
                                    duration: Duration(milliseconds: 200),
                                    child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 200),
                                      child: gonsignup
                                          ? Text(
                                              "En s'inscrivant vous agréer à nos conditions générales et notre politique d'utilisation des données",
                                              style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 17),
                                              textAlign: TextAlign.center,
                                            )
                                          : FlatButton(
                                              onPressed: () {},
                                              child: Text(
                                                "Vous avez oublié votre mot de passe ? Cliquez-ici !",
                                                style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 17),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: widget.daanime
                                .capsize(hres(50), hres(30))
                                .value,
                          ),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: isSigningLastUser
                                ? CircularProgressIndicator(
                                    backgroundColor: Color(0xff40c4ff),
                                  )
                                : Column(children: <Widget>[
                                    ButtonTheme(
                                      minWidth: widget.daanime
                                          .capsize(hres(280), hres(200))
                                          .value,
                                      child: RaisedButton(
                                          elevation: 1,
                                          onPressed: isworking
                                              ? () {}
                                              : () {
                                                  if (!cansignup)
                                                    widget.daanime.controller
                                                        .forward()
                                                        .whenComplete(() {
                                                      setState(() {
                                                        cansignup = true;
                                                      });
                                                    });
                                                  else if (cansignup &&
                                                      !gonsignup) {
                                                    switchwork(1);
                                                    dauser
                                                        .logWmail(
                                                      // email: ectrl.text,
                                                      // pass: passctrl.text,
                                                      // email: "omedkane4@shitoo.com",
                                                      // pass: "jadonSancho",
                                                      // email: "omedkane5@gmail.com",
                                                      // pass: "brokugeta1",
                                                      email:
                                                          "omedkane4@outlook.com",
                                                      pass: "lionelMessi",
                                                    )
                                                        .then((val) {
                                                      checkLogResult(val);
                                                    }).whenComplete(() {
                                                      switchwork(0);
                                                    });
                                                  } else if (gonsignup) {
                                                    switchwork(1);
                                                    dauser
                                                        .signupWmail(
                                                            email: ectrl.text,
                                                            pass: passctrl.text,
                                                            firstName:
                                                                fnamectrl.text,
                                                            lastName:
                                                                lnamectrl.text)
                                                        .then((val) {
                                                      checkLogResult(val);
                                                    }).whenComplete(() {
                                                      switchwork(0);
                                                    });
                                                  }
                                                },
                                          color: widget.signanime.butcol.value,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          // highlightColor: Colors.black,
                                          splashColor: Color.fromRGBO(
                                              255, 255, 255, 0.8),
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          // shape: ,
                                          child: isworking
                                              ? SizedBox(
                                                  height: 18,
                                                  width: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                )
                                              : Text(
                                                  gonsignup
                                                      ? "Continuer"
                                                      : "Se connecter",
                                                  key: widget.akey,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                    ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    FlatButton(
                                      onPressed: () {
                                        if (!cansignup)
                                          widget.daanime.controller
                                              .forward()
                                              .whenComplete(() {
                                            setState(() {
                                              cansignup = true;
                                            });
                                            Future.delayed(
                                                Duration(milliseconds: 50), () {
                                              if (!gonsignup)
                                                widget.signanime.controller
                                                    .forward()
                                                    .whenComplete(() {
                                                  setState(() {
                                                    gonsignup = true;
                                                  });
                                                });
                                            });
                                          });
                                        else
                                          widget.signanime.controller
                                              .reverse()
                                              .whenComplete(() {
                                            setState(() {
                                              gonsignup = false;
                                            });
                                          });
                                      },
                                      // color: Color(0xff40c4ff).shade300,
                                      padding:
                                          EdgeInsets.only(top: 14, bottom: 14),
                                      // shape: ,
                                      child: Text(
                                        "${gonsignup ? 'J\'ai un' : 'Je n\'ai pas de'} compte !",
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 18),
                                      ),
                                    )
                                  ]),
                          ),
                          AnimatedSize(
                            vsync: widget.daticker,
                            duration: Duration(milliseconds: 200),
                            child: !errthere
                                ? SizedBox()
                                : Text(
                                    errmsg,
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 17),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(flex: 1)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ClipRect foldable({Widget dachild}) => ClipRect(
        child: Align(
          heightFactor: widget.daanime.hfact.value,
          child: dachild,
        ),
      );
}
