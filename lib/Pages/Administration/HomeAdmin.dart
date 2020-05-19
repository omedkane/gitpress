import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Pages/Administration/Dashboard/Dashboard.dart';
import 'package:mauripress/Pages/Administration/HomeCompos.dart';
import 'package:mauripress/Pages/Administration/PixiScreen/PixiScreen.dart';
import 'package:mauripress/Pages/Administration/Utilisateurs/ManageUsers.dart';
import 'package:mauripress/QuickElements.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OvalImage(
                  daImage: AssetImage("assets/images/userprof3.png"),
                  daSize: 40,
                ),
                SizedBox(height: 30),
                Text("Bonjour,", style: blackTxt.cSz(22).medfont),
                SizedBox(height: 10),
                Text("Administrateur,",
                    style: DaWeights(Colors.blue).cSz(24).medfont),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Bienvenue dans le menu d'Administration, Veuillez procéder avec caution",
              // style: GoogleFonts.hindSiliguri(fontSize: 22,fontWeight:FontWeight.w300),
              style: TextStyle(
                  // fontFamily: 'Roboto',
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  fontSize: 20),
            ),
            SizedBox(height: 60),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  zhomeOption(
                      daIcon: Entypo.bar_graph,
                      daTitle: "Tableau de bord",
                      daSub: "Vision détaillée des affaires",
                      daColor: Colors.cyan,
                      daFunction: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => DashboardScreen()));
                      }),
                  zhomeOption(
                      daIcon: Entypo.price_tag,
                      daTitle: "Gestion des prix",
                      daSub: "Modifier les prix de lavage des habits",
                      daColor: midori,
                      daFunction: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => PixiScreen()));
                      }),
                  zhomeOption(
                      daIcon: MaterialCommunityIcons.account_group,
                      daTitle: "Gestion des utilisateurs",
                      daSub: "Supprimer et attribuer des rôles",
                      daFunction: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ManageUsers()));
                      }),
                  zhomeOption(
                      daIcon: MaterialCommunityIcons.truck_delivery,
                      daTitle: "Gestion des livreurs",
                      daSub: "Gérer le système de livraison",
                      daColor: Color(0xff59ADFF),
                      daFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ManageUsers(staffOnly: true)));
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
