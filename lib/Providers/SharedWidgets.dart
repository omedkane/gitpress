import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Arsenal with ChangeNotifier {
  bool errthere = false;
  String errmsg = "";
  void checkLogResult(val, Function iftrue) {
    if (val is bool) {
      if (val) iftrue();
    } else if (val is String) {
      errmsg = val;
      errthere = true;
    }

    notifyListeners();
  }

  AnimatedSize gottaProblem(aticker) => AnimatedSize(
        vsync: aticker,
        duration: Duration(milliseconds: 200),
        child: !errthere
            ? SizedBox()
            : Text(
                errmsg,
                style: TextStyle(color: Colors.orange, fontSize: 17),
              ),
      );
}
