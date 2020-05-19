import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:provider/provider.dart';

var itaStyle = TextStyle(
  fontWeight: FontWeight.w200,
  fontStyle: FontStyle.italic,
  fontFamily: 'Roboto',
  height: 1.5,
  fontSize: 24,
);

class myInput extends StatelessWidget {
  final String dahint;
  final bool ispass;
  final double dawidth;
  final TextEditingController dactrl;
  final BuildContext context;
  final List<FocusNode> focusList;
  final int focusNum;
  final TextInputType keyType;
  myInput(this.dahint, this.ispass, this.dawidth, this.dactrl, this.context,
      this.focusList, this.focusNum,
      {this.keyType = TextInputType.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      // color: Colors.transparent,
      width: dawidth * 0.85,
      padding: EdgeInsets.only(left: 15, top: 4),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(5.0)),
      child: TextField(
        keyboardType: keyType,
        textInputAction:
            (focusList != null && focusNum < (focusList.length - 1))
                ? TextInputAction.next
                : TextInputAction.done,
        onSubmitted: (elem) {
          if (focusList != null) {
            focusList[focusNum].unfocus();
            if (focusNum < (focusList.length - 1)) {
              FocusScope.of(context).requestFocus(focusList[focusNum + 1]);
            }
          }
        },
        focusNode: focusList != null ? focusList[focusNum] : null,
        controller: dactrl,
        obscureText: ispass,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Colors.grey),
        decoration: InputDecoration(
            hintText: dahint,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 17)),
      ),
    );
  }
}

BoxShadow ushaded = BoxShadow(
    color: Color(0xffdadada),
    offset: Offset(0, 8),
    blurRadius: 10,
    spreadRadius: -4);
BoxShadow gshaded = BoxShadow(
    color: Color.fromRGBO(154, 154, 154, 0.35),
    offset: Offset(0, 2),
    blurRadius: 5,
    spreadRadius: 0);
BoxShadow greyShaded =
    BoxShadow(blurRadius: 4, offset: Offset(0, 2), color: Colors.grey.shade300);

BoxShadow matShade =
    BoxShadow(blurRadius: 4, offset: Offset(0, 2), color: Colors.black45);
TextStyle habstyle = TextStyle(fontSize: 17);
Color hexToColor(String code) {
  return new Color(int.parse(code, radix: 16) + 0xFF000000);
}

barMe({context, title, issetting}) => PreferredSize(
      preferredSize: Size.fromHeight(80),
      child: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "$title",
          style: TextStyle(
              fontSize: 19, fontFamily: 'Haboro', color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 20,
          padding: EdgeInsets.all(0),
          tooltip: "Page précédente",
          icon: Icon(
            AntDesign.left,
            size: 20,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          if (issetting)
            IconButton(
              onPressed: () {},
              icon: Icon(
                AntDesign.logout,
                color: Colors.deepOrange,
                size: 24,
              ),
            )
        ],
      ),
    );

Future locateMe() async {
  Location location = Location();
  LocationData whereami;
  PermissionStatus mayI;
  bool gotGPS;
  gotGPS = await location.serviceEnabled();
  if (!gotGPS) {
    gotGPS = await location.requestService();
    if (!gotGPS) return;
  }
  mayI = await location.hasPermission();
  if (mayI == PermissionStatus.DENIED) {
    mayI = await location.requestPermission();
    if (mayI != PermissionStatus.GRANTED) return;
  }
  whereami = await location.getLocation();
  return whereami;
}

class inkButton extends StatelessWidget {
  inkButton(
      {this.onPressed,
      this.bgColor = const Color(0xffBDBDBD),
      this.color = Colors.white,
      this.iconSize = 30,
      this.icon,
      this.tooltip,
      this.shadow});
  final Function onPressed;
  final Color bgColor;
  final Color color;
  final double iconSize;
  final IconData icon;
  final String tooltip;
  final List<BoxShadow> shadow;

  Widget build(BuildContext context) => Ink(
        decoration: ShapeDecoration(
            shadows: shadow ?? kElevationToShadow[3],
            color: bgColor,
            shape: CircleBorder()),
        child: IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: color,
            size: iconSize,
          ),
        ),
      );
}

class MyIconButton extends StatefulWidget {
  final Color daColor;
  final IconData daIcon;
  final Function daFunction;
  final double size;
  final double iconSize;
  final List<BoxShadow> elevation;
  final Color bgColor;
  final Color splashColor;
  final bool isAsync;

  MyIconButton(
      {Key key,
      this.daColor = Colors.black,
      this.daIcon,
      this.daFunction,
      this.size = 50,
      this.bgColor = Colors.transparent,
      this.splashColor,
      this.iconSize = 20,
      this.elevation,
      this.isAsync = false})
      : super(key: key);
  MyIconButtonState createState() => MyIconButtonState();
}

class MyIconButtonState extends State<MyIconButton> {
  bool isLoading = false;
  switchLoading({bool how}) {
    setState(() {
      isLoading = how ?? !isLoading;
    });
  }

  Future doThis() async {
    await widget.daFunction();
    switchLoading(how: false);
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, boxShadow: widget.elevation ?? null),
        child: ClipOval(
          child: Material(
            color: widget.bgColor,
            child: InkWell(
              splashColor: widget.splashColor,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : Icon(
                        widget.daIcon,
                        size: widget.iconSize,
                        color: widget.daColor,
                      ),
              ),
              onTap: !widget.isAsync
                  ? widget.daFunction
                  : () {
                      if (!isLoading) {
                        switchLoading(how: true);
                        doThis();
                      }
                    },
            ),
          ),
        ),
      );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  MyAppBar({this.title, this.trailing, this.elevation = 0});
  final String title;
  final Widget trailing;
  final double appBarHeight = 70;
  final double elevation;
  @override
  get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.white,
            elevation: elevation,
            centerTitle: true,
            title: Text(
              "$title",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            leading: MyIconButton(
              daIcon: AntDesign.left,
              size: 30,
              daFunction: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[if (trailing != null) trailing],
          ),
        ],
      ),
    );
  }
}

frenchDate(DateTime dadate) {
  var formatMe = DateFormat.yMMMEd('fr');
  return formatMe.format(dadate);
}

class OvalImage extends StatelessWidget {
  final ImageProvider daImage;
  final double daSize;

  const OvalImage({Key key, this.daImage, this.daSize = 80}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [ushaded]),
      child: ClipOval(
        child: Image(
          image: daImage,
          height: daSize,
          width: daSize,
          fit: BoxFit.cover,
          // color: Colors.white,
        ),
      ),
    );
  }
}

// drawMyLine(List<double> daVals) {
//   double maxVal = daVals[0];
//   daVals.forEach((elem) {
//     if (elem > maxVal) maxVal = elem;
//   });
//   List<double> perCents = [];
//   daVals.forEach((elem) {
//     perCents.add(elem / maxVal);
//   });
// }

class CircleIcon extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final double size;
  final double iconSize;
  final IconData daIcon;
  const CircleIcon(
      {Key key,
      this.color = Colors.blue,
      this.size = 50,
      this.iconColor = Colors.white,
      this.iconSize = 25,
      this.daIcon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle, boxShadow: tailShadow2, color: color),
      child: Icon(
        daIcon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}

List<BoxShadow> tailShadow = [
  BoxShadow(
    offset: Offset(0, 20),
    blurRadius: 25,
    spreadRadius: -20,
    color: Color.fromRGBO(0, 0, 0, 0.1),
  ),
  BoxShadow(
    offset: Offset(0, 10),
    blurRadius: 10,
    spreadRadius: -5,
    color: Color.fromRGBO(0, 0, 0, 0.15),
  ),
];
List<BoxShadow> tailShadow2 = [
  BoxShadow(
    offset: Offset(0, 20),
    blurRadius: 25,
    spreadRadius: -20,
    color: Color.fromRGBO(0, 0, 0, 0.1),
  ),
  BoxShadow(
    offset: Offset(0, 10),
    blurRadius: 10,
    spreadRadius: -5,
    color: Color.fromRGBO(0, 0, 0, 0.15),
  ),
  BoxShadow(
    offset: Offset(0, -1),
    blurRadius: 10,
    spreadRadius: -5,
    color: Color.fromRGBO(0, 0, 0, 0.15),
  ),
];

getDateMap() {
  Map<int, int> daMap = {};
  for (int i = 1; i <= 7; i++) {
    daMap.addAll({i: 0});
  }
  return daMap;
}

class GreyInput extends StatelessWidget {
  final double width;
  final bool isSearch;
  final Function onSubmitted;
  final bool isPass;
  final String daHint;
  final TextEditingController daController;

  const GreyInput(
      {Key key,
      this.width,
      this.isSearch = false,
      this.onSubmitted,
      this.isPass = false,
      this.daHint,
      this.daController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        // margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: <Widget>[
            if (isSearch)
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Icon(MaterialCommunityIcons.account_search),
              )
            else
              SizedBox(width: 15),
            Expanded(
              child: TextField(
                obscureText: isPass,
                onSubmitted: onSubmitted,
                controller: daController,
                decoration: InputDecoration(
                    hintText: daHint ?? "Placez votre rechecher ici...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InternetImage extends StatelessWidget {
  final ImageProvider defaultImage;
  final String imageUri;
  final double size;

  const InternetImage({
    Key key,
    this.defaultImage,
    this.size = 180,
    this.imageUri,
  }) : super(key: key);

  Image imgWidget({ImageProvider daProvider}) => Image(
        height: size,
        width: size,
        fit: BoxFit.cover,
        image: daProvider ??
            defaultImage ??
            AssetImage("assets/images/userprof3.png"),
      );
  @override
  Widget build(BuildContext context) {
    return imageUri == null
        ? imgWidget()
        : CachedNetworkImage(
            imageUrl: imageUri,
            placeholder: (context, daImage) => imgWidget(),
            imageBuilder: (context, daImageProvider) =>
                imgWidget(daProvider: daImageProvider));
  }
}

class ProfilePicture extends StatelessWidget {
  final ImageProvider defaultImage;
  final String imageUri;
  final double size;

  const ProfilePicture({
    Key key,
    this.defaultImage,
    this.size = 180,
    this.imageUri,
  }) : super(key: key);

  Image imgWidget({ImageProvider daProvider}) => Image(
        height: size,
        width: size,
        fit: BoxFit.cover,
        image: daProvider ??
            defaultImage ??
            AssetImage("assets/images/userprof3.png"),
      );
  @override
  Widget build(BuildContext context) {
    return Selector<PhoneMaster, String>(
      selector: (context, daModel) => daModel.imageURL,
      builder: (context, daUrl, child) => CachedNetworkImage(
          imageUrl: daUrl,
          placeholder: (context, daImage) => imgWidget(),
          imageBuilder: (context, daImageProvider) =>
              imgWidget(daProvider: daImageProvider)),
    );
  }
}
