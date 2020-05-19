import 'package:flutter/material.dart';

// blueTxt.wA.medfont

String extFont = "Haboro-Ext";

class OneFont {
  OneFont(daColor, double size, {isExt = false})
      : regfont = TextStyle(
            fontFamily: isExt ? extFont : null, fontSize: size, color: daColor),
        medfont = TextStyle(
            fontFamily: isExt ? extFont : null,
            fontSize: size,
            color: daColor,
            fontWeight: FontWeight.w500),
        boldfont = TextStyle(
            fontFamily: isExt ? extFont : null,
            fontSize: size,
            color: daColor,
            fontWeight: FontWeight.bold);

  TextStyle regfont, medfont, boldfont;
}

class DaWeights {
  DaWeights(this.daColor)
      : szA = OneFont(daColor, 16),
        szB = OneFont(daColor, 17),
        szC = OneFont(daColor, 19),
        szD = OneFont(daColor, 49),
        extSzA = OneFont(daColor, 16, isExt: true),
        extSzB = OneFont(daColor, 17, isExt: true),
        extSzC = OneFont(daColor, 19, isExt: true),
        extSzD = OneFont(daColor, 49);
  // daColor = daColor;
  final Color daColor;
  final OneFont szA, extSzA, szB, extSzB, szC, extSzC, szD, extSzD;
  OneFont cSz(double fontSize) => OneFont(this.daColor, fontSize);
}

// DaWeights aoiTxt = DaWeights(Color(0xff59ADFF)),
DaWeights aoiTxt = DaWeights(Color(0xff40c4ff)),
    whiteTxt = DaWeights(Colors.white),
    orangeTxt = DaWeights(Colors.deepOrange),
    blackTxt = DaWeights(Colors.black),
    greyTxt = DaWeights(Colors.grey),
    greenTxt = DaWeights(Color(0xff00cb53));
Color midori = Color(0xff00cb53),
// aoi = Color(0xff59ADFF);
    aoi = Color(0xff40c4ff);

TextStyle greetStyle = TextStyle(
  fontWeight: FontWeight.w100,
  fontFamily: 'Roboto',
  height: 1.5,
  fontSize: 24,
);
