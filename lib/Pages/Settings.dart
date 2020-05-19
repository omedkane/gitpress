import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Mahome_animator.dart';
import 'package:mauripress/Pages/AboutUsPage/aboutus.dart';
import 'package:mauripress/Pages/Administration/HomeAdmin.dart';
import 'package:mauripress/Pages/EditInfo.dart';
import 'package:mauripress/Pages/OrderListPage/OrderList.dart';
import 'package:mauripress/Pages/SecurityPage/Securite.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/locator.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);
  SettingState createState() => SettingState();
}

class SettingState extends State<SettingPage> {
  String daImageUrl = "";
  var dauser = locator.get<PhoneMaster>();
  bool hasFetchInfo = false;
  @override
  void initState() {
    dauser.getOrdersNbThisWeek().whenComplete(() {
      setState(() {
        hasFetchInfo = true;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    var daheight = MediaQuery.of(context).size.height;
    var dawidth = MediaQuery.of(context).size.width;
    // dauser.fetchProfilePic().whenComplete(() {
    // print(dauser.imageURL);
    // });
    TextStyle habstyle = TextStyle(fontSize: 17);
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: PreferredSize(
      //     preferredSize: Size.fromHeight(80),
      //     child: barMe(context: context, title: "Compte", issetting: true)),
      appBar: MyAppBar(
        title: "Compte",
        trailing: MyIconButton(
          isAsync: true,
          daFunction: () async {
            await FirebaseAuth.instance.signOut();
            locator.reset();
            setupLocator();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeAnimator()));
          },
          daIcon: AntDesign.logout,
          daColor: Colors.pink.shade300,
        ),
      ),
      body: Column(
        children: <Widget>[
          // SizedBox(height: 50),
          // SizedBox(height: 25),
          Container(
            width: dawidth,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: "profpic",
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [matShade]),
                        child: ClipOval(
                          child: ProfilePicture(
                            imageUri: dauser.imageURL,
                          )
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: Container(
                          // margin: EdgeInsets.only(top:40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(dauser.firstName + " " + dauser.lastName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(dauser.address,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.shade400)),
                              SizedBox(height: 5),
                              Text("+(222) ${dauser.phoneNumber}",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.shade400)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 25),
                Text("Cette semaine vous avez effectué...",
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.grey,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic)),
                SizedBox(height: 30),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(dauser.ordersNb.toString(),
                              style: TextStyle(
                                  color: Colors.cyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 43)),
                          SizedBox(height: 10),
                          Text("Commandes", style: TextStyle(fontSize: 17))
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text("dont", style: greyTxt.szA.regfont),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(dauser.deliveredNb.toString(),
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 43)),
                            SizedBox(height: 10),
                            Text("Livrée(s)", style: TextStyle(fontSize: 17))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("et", style: greyTxt.szA.regfont),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(dauser.pendingNb.toString(),
                              style: TextStyle(
                                  color: Colors.cyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 43)),
                          SizedBox(height: 10),
                          Text("En cours", style: TextStyle(fontSize: 17))
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Divider(
                  color: Colors.black38,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(MaterialCommunityIcons.account_edit_outline),
                  title: Text("Modifier mes informations", style: habstyle),
                  subtitle: Text("Changer votre adresse et numéro de téléphone",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return EditInfo();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(AntDesign.lock),
                  title: Text("Sécurité", style: habstyle),
                  subtitle: Text("Configurer les divers paramètres de sécurité",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return SecurePage();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(AntDesign.setting),
                  title: Text("Administration", style: habstyle),
                  subtitle: Text("Divers paramètres d'administration",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return AdminHome();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(Feather.list),
                  title: Text("Listes des commandes", style: habstyle),
                  subtitle: Text(
                      "La liste des commandes éffectuées par les clients",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return OrderListPage();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(AntDesign.info),
                  title: Text("À propos de nous", style: habstyle),
                  subtitle: Text(
                      "Contactez-nous à travers différents réseaux sociaux",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return AboutUs();
                    }));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
