import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/locator.dart';

class EditInfo extends StatefulWidget {
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  var dauser = locator.get<PhoneMaster>();

  var addressCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();
  bool isworking = false;
  bool athome = false;

  bool errthere = false;
  String errmsg = "";
  double latitude = 0.0;
  double longitude = 0.0;
  void checkLogResult(val) {
    if (!(val is String)) {
      // build(context);
      Navigator.pop(context);
    } else if (val is String) {
      setState(() {
        errmsg = val;
        errthere = true;
      });
    }
  }

  @override
  void initState() {
    locateMe().then((val) {
      if (val is LocationData) {
        setState(() {
          latitude = val.latitude;
          longitude = val.longitude;
        });
      }
    });

    super.initState();
  }

  var daImage;
  String daImageUrl = "";
  bool isChangingImage = false;
  @override
  Widget build(BuildContext context) {
    var dawidth = MediaQuery.of(context).size.width;
    var daheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: barMe(context: context, title: "Informations", issetting: false),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Hero(
                        tag: "profpic",
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isChangingImage = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [matShade]),
                            child: ClipOval(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 250,
                                    width: 250,
                                    color: Colors.black,
                                  ),
                                  CachedNetworkImage(
                                      imageUrl: dauser.imageURL,
                                      imageBuilder:
                                          (context, daImageProvider) =>
                                              FadeInImage(
                                                height: 250,
                                                width: 250,
                                                fit: BoxFit.cover,
                                                placeholder: AssetImage(
                                                    "assets/images/userprof3.png"),
                                                image: daImage != null
                                                    ? FileImage(daImage)
                                                    : daImageProvider,
                                              )),
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 500),
                                    child: !isChangingImage
                                        ? SizedBox()
                                        : Container(
                                            height: 250,
                                            width: 250,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black54),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                MyIconButton(
                                                  bgColor: Colors.white,
                                                  daColor: aoi,
                                                  iconSize: 24,
                                                  daIcon: Icons.camera,
                                                  daFunction: () async {
                                                    await ImagePicker.pickImage(
                                                            source: ImageSource
                                                                .camera,
                                                            maxHeight: 500,
                                                            maxWidth: 500)
                                                        .then((val) {
                                                      setState(() {
                                                        daImage = val;
                                                      });
                                                    });
                                                  },
                                                ),
                                                MyIconButton(
                                                  bgColor: Colors.white,
                                                  daColor: aoi,
                                                  iconSize: 24,
                                                  daIcon: Icons.camera_roll,
                                                  daFunction: () async {
                                                    await ImagePicker.pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                            maxHeight: 500,
                                                            maxWidth: 500)
                                                        .then((val) {
                                                      setState(() {
                                                        daImage = val;
                                                      });
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: Wrap(
                        direction: Axis.vertical,
                        spacing: 15,
                        children: <Widget>[
                          Text("Adresse",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              )),
                          Container(
                            alignment: Alignment.center,
                            height: 57,
                            width: 366,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xffF0F8FF), boxShadow: [gshaded]),
                            child: TextField(
                              controller: addressCtrl,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: dauser.address,
                                  hintStyle: TextStyle(
                                      fontSize: 17, color: Colors.grey)),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Wrap(
                        direction: Axis.vertical,
                        spacing: 15,
                        children: <Widget>[
                          Text("Téléphone",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              )),
                          Container(
                            alignment: Alignment.center,
                            height: 57,
                            width: 366,
                            padding: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: Color(0xffF0F8FF), boxShadow: [gshaded]),
                            child: TextField(
                              controller: phoneCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: dauser.phoneNumber.toString(),
                                  hintStyle: TextStyle(
                                      fontSize: 17, color: Colors.grey)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      // width: dawidth,
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            value: athome,
                            onChanged: (val) {
                              setState(() {
                                athome = val;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          Expanded(
                            child: Text("Je suis chez moi ! (Géolocalisation)",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(
                          AntDesign.info,
                          size: 30,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: Text(
                            "Nous utiliserons ce numéro pour confirmer et cette adresse pour livrer !",
                            style: TextStyle(color: Colors.blue, fontSize: 17),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Center(
                      child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        direction: Axis.vertical,
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 155,
                            height: 45,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: RaisedButton(
                              elevation: 1,
                              onPressed: () {
                                if (!isworking) {
                                  setState(() {
                                    isworking = true;
                                  });
                                  dauser.addMoreInfo(
                                      address: addressCtrl.text,
                                      phoneNumber: int.tryParse(phoneCtrl.text),
                                      daFile: daImage,
                                      myPos: [
                                        latitude,
                                        longitude
                                      ]).then((val) async {
                                    checkLogResult(val);
                                  }).whenComplete(() {
                                    setState(() {
                                      isworking = false;
                                    });
                                  });
                                }
                              },
                              color: Color(0xff59ADFF),
                              child: isworking
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      "Confirmer",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                            ),
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
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
