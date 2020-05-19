import 'package:flutter/material.dart';

import './Mahome.dart';

class HomeAnimator extends StatefulWidget {
  @override
  _HomeAnimatorState createState() => _HomeAnimatorState();
}

class _HomeAnimatorState extends State<HomeAnimator>
    with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _signupctrl;
  TickerProvider lyoko;

  @override
  void initState() {

    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _signupctrl =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    lyoko = this;
    // _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _signupctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dahome(controllers: [_controller, _signupctrl], matick: lyoko);
  }
}
