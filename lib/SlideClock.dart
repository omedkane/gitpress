import 'package:flutter/material.dart';

class Slideclock extends StatefulWidget {
  @override
  _SlideclockState createState() => _SlideclockState();
}

class _SlideclockState extends State<Slideclock>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
