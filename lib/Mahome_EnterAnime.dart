import 'package:flutter/material.dart';

class EntAnime {
  EntAnime(this.controller)
      : opanime = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0, 0.5, curve: Curves.linear),
        )),
        topmargin = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.5, 0.7, curve: Curves.linear),
        )),
        r_opanime = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0, 0.5, curve: Curves.linear),
        )),
        hfact = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.2, 0.6, curve: Curves.linear),
        )),
        entwidth = Tween<double>(begin: 100, end: 250).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.5, 0.7, curve: Curves.linear),
        )),
        imgwidth = Tween<double>(begin: 250, end: 50).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.5, 0.7, curve: Curves.linear),
        )),
        towhite = ColorTween(
                begin: Colors.transparent, end: Colors.white)
            .animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.1, 0.9, curve: Curves.linear),
        )),
        icontotop =
            AlignmentTween(begin: Alignment.center, end: Alignment.topCenter)
                .animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.5, 0.9, curve: Curves.linear),
        ));

  final AnimationController controller;
  final Animation<double> opanime;
  final Animation<double> r_opanime;
  final Animation<double> hfact;
  final Animation<double> entwidth;
  final Animation<double> imgwidth;
  final Animation<double> topmargin;
  final Animation<Color> towhite;
  final Animation<Alignment> icontotop;

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
