import 'package:flutter/material.dart';
import 'package:mauripress/AppStyle.dart';
import 'package:mauripress/Models/OneLine.dart';
import 'package:mauripress/QuickElements.dart';

class OrderCard extends StatelessWidget {
  final OneLine daLine;
  final bool inList;

  const OrderCard({Key key, this.daLine, this.inList = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime dadate = daLine.dadate.toDate();
    var bgColor = daLine.isCanceled
        ? Colors.deepOrange.shade400
        : (daLine.isDelivered ? Color(0xffE8F0F9) : Color(0xff40c4ff));
    var textColor = daLine.isCanceled
        ? whiteTxt
        : (!daLine.isDelivered ? whiteTxt : blackTxt);
    var numberColor = daLine.isCanceled
        ? whiteTxt
        : (!daLine.isDelivered ? whiteTxt : DaWeights(Colors.blue.shade300));

    return FractionallySizedBox(
      widthFactor: 0.91,
      child: Container(
        margin: EdgeInsets.only(top: inList ? 40 : 0),
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [greyShaded]),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(daLine.frenchDate, style: numberColor.szC.regfont),
                      SizedBox(height: 5),
                      Text("${dadate.hour}:${dadate.minute}",
                          style: numberColor.szC.boldfont),
                    ],
                  ),
                  SizedBox(height: 85),
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: <Widget>[
                      Text("${daLine.totalPrice}",
                          style: numberColor.extSzD.boldfont),
                      Text("MRU", style: numberColor.extSzC.boldfont),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.topRight,
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 5,
                  children: <Widget>[
                    Text(daLine.fullName, style: textColor.szC.medfont),
                    Text(daLine.address, style: textColor.szC.medfont),
                    Text("+(222) ${daLine.phoneNumber}",
                        style: numberColor.szC.boldfont),
                    if (daLine.assignedNawa != null)
                      Row(
                        children: <Widget>[
                          if (daLine.isConfirmed)
                            CircleIcon(
                              iconColor: aoi,
                              size: 20,
                              iconSize: 16,
                              color: Colors.white,
                              daIcon: Icons.call,
                            ),
                          Container(
                            margin: EdgeInsets.only(
                                left: daLine.isConfirmed ? 5 : 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Text(
                              "L: " + daLine.assignedNawa,
                              style: aoiTxt.szC.medfont,
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
