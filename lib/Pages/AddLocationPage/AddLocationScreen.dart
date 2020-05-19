import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mauripress/HomeScreen.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:provider/provider.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen>
    with SingleTickerProviderStateMixin {
  var listofNodes = List.generate(2, (index) => FocusNode());
  bool isworking = false;
  bool athome = true;
  var addressCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();
  bool errthere = false;
  String errmsg = "";
  double latitude = 0.0;
  double longitude = 0.0;
  TickerProvider daticker;
  void checkLogResult(val) {
    if (!(val is String)) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else if (val is String) {
      setState(() {
        errmsg = val;
        errthere = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    daticker = this;
    locateMe().then((val) {
      if (val is LocationData) {
        setState(() {
          latitude = val.latitude;
          longitude = val.longitude;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var dawidth = MediaQuery.of(context).size.width;
    var daheight = MediaQuery.of(context).size.height;
    var dauser = Provider.of<PhoneMaster>(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: daheight,
        width: dawidth,
        child: Center(
          child: FractionallySizedBox(
            heightFactor: 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 0.3,
                  child: Image(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/images/LocationPageIcon.png"),
                  ),
                ),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 20,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    myInput(
                        "Adresse (Ex: Socogim PS devant Restaurant Amandine...)",
                        false,
                        dawidth,
                        addressCtrl,
                        context,
                        listofNodes,
                        0),
                    myInput("Numéro de téléphone (Ex: 44112233", false, dawidth,
                        phoneCtrl, context, listofNodes, 1,
                        keyType: TextInputType.phone),
                  ],
                ),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 20,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
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
                        Text("Je suis chez moi actuellement ! (Géolocalisation)",
                            style: TextStyle(color: Colors.green, fontSize: 18))
                      ],
                    ),
                    SizedBox(
                      width: dawidth * 0.9,
                      child: Text(
                        "Nous utiliserons ce numéro pour confirmer et cette adresse pour livrer !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue.shade200, fontSize: 17),
                      ),
                    ),
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
                                myPos: [latitude, longitude]).then((val) {
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
                    AnimatedSize(
                      vsync: daticker,
                      duration: Duration(milliseconds: 200),
                      child: !errthere
                          ? SizedBox()
                          : Text(
                              errmsg,
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 17),
                            ),
                    ),
                  ],
                ),
                // SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
