import 'package:flutter/material.dart';

class Logoni {
  Logoni(this.controller)
      : opanime = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
        )),

        hfact = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
        ));
  final AnimationController controller;
  final Animation<double> opanime;
  final Animation<double> hfact;

  Animation<double> getsize(adbegin, adend) {
    return Tween<double>(begin: adbegin, end: adend).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.2, 0.5),
    ));
  }

  Animation<double> capsize(adbegin, adend) {
    return Tween<double>(begin: adbegin, end: adend).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.2, 0.5),
    ));
  }
}
