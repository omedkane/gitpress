import 'package:flutter/material.dart';
import 'package:mauripress/Billing/DaBill.dart';

class Billanime extends StatefulWidget {
  Billanime();
  @override
  _BillanimeState createState() => _BillanimeState();
}

class _BillanimeState extends State<Billanime>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DaBill(coco: _controller);
  }
}
