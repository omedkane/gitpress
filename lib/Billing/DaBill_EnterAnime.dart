import 'package:flutter/material.dart';

class Entanime {
  Entanime(this.baba):
        opacited = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: baba, curve: Interval(0.5, 0.75, curve: Curves.linear)));
  final AnimationController baba;
  final Animation<double> opacited;
}
