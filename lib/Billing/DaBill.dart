import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/Billing/DaBill_EnterAnime.dart';
import 'package:mauripress/Billing/UserVerifyDialog.dart';
import 'package:mauripress/Components/BusyButton.dart';
import 'package:mauripress/Models/ClotheCatalogue.dart';
import 'package:mauripress/locator.dart';
import 'package:provider/provider.dart';

import '../Providers/KartProvider.dart';

class DaBill extends StatefulWidget {
  DaBill({Key key, AnimationController coco})
      : maanime = Entanime(coco),
        super(key: key);

  final Entanime maanime;
  DaBillState createState() => DaBillState();
}

class DaBillState extends State<DaBill> {
  int datotal = 0;
  bool orderStatus = false;
  bool ordered = false;
  String statusMsg = "";
  bool dialogOpen = false;
  Widget build(BuildContext context) {
    final dacart = Provider.of<CartProvider>(context);
    var okorders = dacart.dakart;
    var daheight = MediaQuery.of(context).size.height;
    var dawidth = MediaQuery.of(context).size.width;
    var textmd = TextStyle(fontSize: 19, color: Colors.white);
    var textmdb = TextStyle(
        fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold);

    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: widget.maanime.baba,
        builder: (context, child) {
          return Column(
            children: <Widget>[
              Container(
                height: daheight * 0.75,
                // flex: 3,
                child: ClipPath(
                  clipper: Orenoclip(),
                  child: Hero(
                    tag: "dabill",
                    child: Container(
                      width: dawidth,
                      color: Color(0xff00cb53),
                      child: FadeTransition(
                        opacity: widget.maanime.opacited,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 100),
                            Text("Votre facture est prête...",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Roboto',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white)),
                            SizedBox(height: 150),
                            // Spacer(flex: 1),
                            Expanded(
                                child: Container(
                              width: dawidth * 0.85,
                              child: Table(
                                  // columnWidths: {2: FixedColumnWidth(200)},
                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                  children: okorders
                                      .where((elem) => elem.qty != 0)
                                      .map((elem) {
                                    return TableRow(children: [
                                      Icon(MaterialCommunityIcons.tshirt_v,
                                          color: Colors.white, size: 30),
                                      // SizedBox(width: 25),
                                      SizedBox(
                                          height: 50,
                                          child: Text("-", style: textmd)),
                                      Text("${elem.qty}x ${elem.daclothe.nawa}",
                                          style: textmd),
                                      // SizedBox(width: 25),
                                      Text("${elem.pixi}", style: textmdb),
                                    ]);
                                  }).toList()
                                  ),
                            )),
                            // Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: FadeTransition(
                  opacity: widget.maanime.opacited,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: orderStatus
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    ordered
                                        ? Icons.check_circle
                                        : Icons.remove_circle,
                                    color: ordered
                                        ? Color(0xff00cb53)
                                        : Colors.deepOrange,
                                    size: 30,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    statusMsg,
                                    style: TextStyle(
                                        color: ordered
                                            ? Color(0xff00cb53)
                                            : Colors.deepOrange,
                                        fontSize: 18),
                                  )
                                ],
                              )
                            : BusyButton(
                                title: "Confirmer",
                                isWithDialog: true,
                                dialogComplete: dialogOpen,
                                todo: () async {
                                  // await dauser
                                  //     .verifyUserStatus()
                                  //     .whenComplete(() {
                                  //   if (dauser.dauser.isEmailVerified ==
                                  //       false) {
                                  //     setState(() {
                                  //       statusMsg =
                                  //           "Votre compte n'est pas encore vérifié !";
                                  //       orderStatus = true;
                                  //     });
                                  //   } else if (dauser.isDisabled) {
                                  //     setState(() {
                                  //       statusMsg =
                                  //           "Votre compte est désactivé !";
                                  //       orderStatus = true;
                                  //     });
                                  //   } else
                                  //     isQualified = true;
                                  // });
                                  // if (!isQualified) return;
                                  setState(() {
                                    dialogOpen = true;
                                  });
                                  verifyMe(context, yesOnTap: () async {
                                    await dacart
                                        .submitCart(context)
                                        .then((val) {
                                      setState(() {
                                        ordered = val;
                                        statusMsg = val
                                            ? "Commande éffectuée avec succés !"
                                            : "Pas de connexion Internet !";
                                        orderStatus = true;
                                      });
                                    });
                                    var daCatalogue =
                                        locator.get<ClotheCatalogue>();
                                    daCatalogue.fetchClothes();
                                    setState(() {
                                      dialogOpen = false;
                                    });
                                  }, noOnTap: () {
                                    setState(() {
                                      dialogOpen = false;
                                    });
                                  });

//daActual Shit
                                },
                                bgColor: Color(0xff00cb53),
                              ),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                              flex: 1,
                              child: Center(
                                child: Text("Total :",
                                    style: TextStyle(
                                        color: Color(0xff00cb53),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700)),
                              )),
                          Center(
                            // fit: FlexFit.loose,
                            // flex: 1,
                            child: Text(
                              "${dacart.totalPixi}",
                              style: TextStyle(
                                  color: Color(0xff00cb53),
                                  fontSize: 45,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "MRU",
                                style: TextStyle(
                                    color: Color(0xff00cb53),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class Orenoclip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo((size.width / 4), (size.height * 0.95),
        (size.width / 2), (size.height));
    path.quadraticBezierTo((size.width * 3 / 4), (size.height * 0.95),
        (size.width), (size.height));
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
