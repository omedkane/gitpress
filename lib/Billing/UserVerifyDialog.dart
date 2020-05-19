import 'package:flutter/material.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Providers/AppSettingsProvider.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/QuickElements.dart';
import 'package:mauripress/Services/DbTalker.dart';
import 'package:mauripress/locator.dart';
import 'package:provider/provider.dart';

verifyMe(BuildContext context, {Function yesOnTap, Function noOnTap}) {
  double dawidth = MediaQuery.of(context).size.width,
      dialogWidth = dawidth * 0.85,
      hPadding = 20,
      vPadding = 20,
      inputWidth = dialogWidth - hPadding * 2;
  TextEditingController daCtrl = TextEditingController();
  var daUser = locator.get<PhoneMaster>();
  var phoneSettings = Provider.of<AppSettingsProvider>(context, listen: false);
  print(phoneSettings.checkPassBeforeOrder);
  if (daUser.dauser.isEmailVerified && !(phoneSettings.checkPassBeforeOrder))
    yesOnTap();
  else
    showDialog(
        context: context,
        builder: (context) {
          bool isLoading = false;
          String errmsg = "";
          bool errThere = false;
          return StatefulBuilder(builder: (context, stateSet) {
            return SimpleDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              children: <Widget>[
                Container(
                  width: 400,
                  padding: EdgeInsets.only(
                      top: vPadding,
                      bottom: 0,
                      left: hPadding,
                      right: hPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Vérification", style: blackTxt.szC.boldfont),
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 25),
                        width: dialogWidth * 0.7,
                        child: Text(
                          !daUser.dauser.isEmailVerified
                              ? "Un email de vérification vous a été envoyé, ouvrez le lien puis saisir votre mot de passe !"
                              : "Pour procéder à votre commande, veuillez saisir votre mot de passe !",
                          style: aoiTxt.szB.regfont,
                        ),
                      ),
                      GreyInput(
                        daHint: "Mot de passe",
                        isPass: true,
                        // onSubmitted: (shit) {},
                        width: inputWidth,
                        daController: daCtrl,
                      ),
                      Container(
                          height: errThere && !isLoading ? null : 65,
                          alignment: Alignment.center,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: isLoading
                                ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          backgroundColor: midori,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          errmsg,
                                          style: DaWeights(Colors.pink)
                                              .szA
                                              .medfont,
                                        ),
                                      ),
                                      ButtonBar(
                                        children: <Widget>[
                                          FlatButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0),
                                            onPressed: () async {
                                              stateSet(() {
                                                isLoading = true;
                                              });
                                              var daUser =
                                                  locator.get<PhoneMaster>();
                                              await DbTalker.verifyUser(
                                                      daUser.email, daCtrl.text)
                                                  .then((value) {
                                                if (value is String) {
                                                  stateSet(() {
                                                    errmsg = value;
                                                    errThere = true;
                                                    isLoading = false;
                                                  });
                                                } else if (value is bool &&
                                                    value == true) {
                                                  Navigator.pop(context);
                                                  yesOnTap();
                                                  return true;
                                                }
                                                return true;
                                              });

                                              stateSet(() {
                                                isLoading = false;
                                              });
                                            },
                                            child: Text(
                                              "OK",
                                              style: aoiTxt.szA.medfont,
                                            ),
                                          ),
                                          FlatButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 0),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Annuler",
                                              style: aoiTxt.szA.medfont,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                          )),
                    ],
                  ),
                )
              ],
            );
          });
        }).then((value) {
      if (!(value is bool) || value != true) noOnTap();
    });
}
