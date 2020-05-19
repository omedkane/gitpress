import 'package:flutter/material.dart';

class SignupAnime {
  SignupAnime(this.controller):
  qopanime = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.3, 0.6, curve: Curves.linear),
        )),
        qhfact = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.0, 0.3, curve: Curves.linear),
        )),
        butcol = ColorTween(begin: Color(0xff40c4ff), end: Colors.cyan.shade500).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(0.0, 0.3, curve: Curves.linear),
        ));

  final AnimationController controller;
  final Animation<double> qopanime;
  final Animation<double> qhfact;
  final Animation<Color> butcol;
}