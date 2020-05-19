import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Components/BusyButton.dart';
import 'package:mauripress/Models/OneUser.dart';
import 'package:mauripress/Pages/Administration/HomeCompos.dart';
import 'package:mauripress/Pages/Administration/Utilisateurs/ManageUsers_Model.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class EditUser extends StatefulWidget {
  final OneUser daUser;

  EditUser(this.daUser) {}
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  bool isDisabled;
  OneUser daUser;
  String imageUrl;
  bool isAssignment;
  var myModel = locator.get<ManageUsersModel>();

  @override
  void initState() {
    daUser = widget.daUser;
    isDisabled = daUser.isDisabled;
    isAssignment = myModel.isAssignment;
    if (isAssignment) myModel.daLine.refreshLine();
    try {
      FirebaseStorage.instance
          .ref()
          .child(daUser.id + '/profile/image.jpg')
          .getDownloadURL()
          .then((value) {
        setState(() {
          imageUrl = value;
        });
      }).catchError((error) {
        print('noooo');
      });
    } catch (e) {
      print('noooo');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          title: daUser.fullName,
          trailing: isAssignment
              ? SizedBox()
              : FlatButton(
                  child: Text(
                    isDisabled ? "Activer" : "Désactiver",
                    style: isDisabled
                        ? greenTxt.szA.medfont
                        : orangeTxt.szA.medfont,
                  ),
                  onPressed: () {
                    daUser.disableMe(!isDisabled).whenComplete(() {
                      setState(() {
                        isDisabled = daUser.isDisabled;
                      });
                    });
                  },
                )),
      body: Column(
        children: <Widget>[
          Center(
            child: Hero(
              tag: "profpic",
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, boxShadow: [matShade]),
                child: ClipOval(
                    child: InternetImage(
                  imageUri: imageUrl,
                  size: 250,
                )),
              ),
            ),
          ),
          SizedBox(height: 30),
          UserListTile(
            title: "Adresse électronique:",
            value: daUser.email,
            isImportant: true,
            trailing: MyIconButton(
                daColor: Colors.blue,
                daFunction: () async {
                  await launch('mailto:${daUser.email}');
                },
                daIcon: AntDesign.mail),
          ),
          UserListTile(
            title: "Numéro de téléphone:",
            value: "+(222) ${daUser.phoneNumber}",
            isImportant: true,
            trailing: Row(
              children: <Widget>[
                MyIconButton(
                    daColor: Colors.blue,
                    daFunction: () async {
                      await launch(
                          'whatsapp://send?phone=+222${daUser.phoneNumber}');
                    },
                    daIcon: MaterialCommunityIcons.whatsapp),
                MyIconButton(
                    daColor: Colors.blue,
                    daFunction: () async {
                      await launch("tel:+222${daUser.phoneNumber}");
                    },
                    daIcon: MaterialCommunityIcons.phone),
                MyIconButton(
                    daColor: Colors.blue,
                    daFunction: () async {
                      await launch("sms:+222${daUser.phoneNumber}");
                    },
                    daIcon: MaterialCommunityIcons.message_reply),
              ],
            ),
          ),
          UserListTile(
            title: "Prénom:",
            value: daUser.firstName,
            isImportant: false,
          ),
          UserListTile(
            title: "Nom:",
            value: daUser.lastName,
            isImportant: false,
          ),
          UserListTile(
            title: "Adresse:",
            value: daUser.address,
            isImportant: false,
          ),
          if (!isAssignment) BusyPopUpButton(daUser),
          if (isAssignment)
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BusyButton(
                  title: "Lui assigner la commande",
                  bgColor: Colors.cyan,
                  todo: () async {
                    await myModel.daLine.assignMeTo(daUser);
                    setState(() {
                      daUser = widget.daUser;
                    });
                    // print("waa");
                  },
                ),
                if (myModel.daLine.assignedTo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("Assigné à: ${myModel.daLine.assignedNawa}",
                        style: aoiTxt.szA.medfont),
                  ),
              ],
            )),
        ],
      ),
    );
  }
}
