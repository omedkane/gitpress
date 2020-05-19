import 'package:flutter/material.dart';
import 'package:mauripress/AppStyle.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isPixi;
  final Widget leading;

  const InfoRow(
      {Key key, this.title, this.value, this.isPixi = false, this.leading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            leading,
            SizedBox(width: 15),
            Text("$title:", style: blackTxt.szB.medfont),
            // SizedBox(width: 30),
          ],
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
              value,
              style: greenTxt.szC.boldfont,
            ),
            if (isPixi)
              Text(
                "MRU",
                style: greenTxt.cSz(14).regfont,
              )
          ],
        )
      ],
    );
  }
}
