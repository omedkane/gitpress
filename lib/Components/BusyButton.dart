import 'package:flutter/material.dart';

class BusyButton extends StatefulWidget {
  BusyButton(
      {@required this.todo,
      @required this.title,
      this.bgColor = const Color(0xff59ADFF),
      this.textColor = Colors.white,
      this.isWithDialog = false,
      this.dialogComplete});
  @override
  _BusyButtonState createState() => _BusyButtonState();
  final Function todo;
  final String title;
  final Color bgColor;
  final Color textColor;
  final bool isWithDialog;
  final bool dialogComplete;

  Future doThis(Function todo) async {
    await todo();
  }
}

class _BusyButtonState extends State<BusyButton> {
  bool isworking = false;
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 155,
      height: 45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: RaisedButton(
        elevation: 1,
        onPressed: widget.isWithDialog
            ? widget.todo
            : () {
                if (!isworking) {
                  setState(() {
                    isworking = true;
                  });
                  widget.doThis(widget.todo).whenComplete(() {
                    setState(() {
                      isworking = false;
                    });
                  });
                }
              },
        color: widget.bgColor,
        child: isworking || (widget.isWithDialog && widget.dialogComplete)
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Text(
                widget.title,
                style: TextStyle(color: widget.textColor, fontSize: 17),
              ),
      ),
    );
  }
}
