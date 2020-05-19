import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/Providers/AppSettingsProvider.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    var phoneSettings =
        Provider.of<AppSettingsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          barMe(context: context, title: "À propos de nous", issetting: false),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50),
          Center(
            child: Image(
              width: 373,
              image: AssetImage("assets/images/Whosbad.png"),
            ),
          ),
          SizedBox(height: 35),
          Text("Vous pouvez nous suivre sur...", style: habstyle),
          SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await launch(phoneSettings.daLinks['Facebook']);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  width: 70,
                  child: Icon(
                    MaterialCommunityIcons.facebook,
                    color: Colors.white,
                    size: 30,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [gshaded],
                      color: Color(0xff1565c0)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await launch(phoneSettings.daLinks['Twitter']);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  width: 70,
                  child: Icon(
                    MaterialCommunityIcons.twitter,
                    color: Colors.white,
                    size: 30,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [gshaded],
                      color: Color(0xff00E5FF)),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (phoneSettings.daLinks['Instagram'] != null)
                    await launch(phoneSettings.daLinks['Instagram']);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  width: 70,
                  child: Icon(
                    MaterialCommunityIcons.instagram,
                    color: Colors.white,
                    size: 30,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [gshaded],
                      color: Color(0xffD42F7E)),
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
          Expanded(
              child: FractionallySizedBox(
            widthFactor: 0.7,
            alignment: Alignment.center,
            // padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              "N'hésitez pas à faire des remarques et à demander de nouvelles fonctionalités",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
