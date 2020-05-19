import 'package:flutter/material.dart';

dialogMe(BuildContext context, {List optionList = const []}) {
  // print(optionList.length);
  var daDialog = SimpleDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    children: List.generate(optionList.length, (index) => optionList[index]),
  );
  showDialog(context: context, builder: (BuildContext context) => daDialog);
}
