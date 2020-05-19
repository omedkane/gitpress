// ButtonTheme(
//               minWidth: 280,
//               child: RaisedButton(
//                 onPressed: () => {},
//                 color: Colors.blue.shade500,
//                 // highlightColor: Colors.white,
//                 splashColor: Colors.white,

//                 padding: EdgeInsets.only(top: 14, bottom: 14),
//                 // shape: ,
//                 child: polka ? Text(
//                   "Se connecter",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ) : Text(
//                   "Se déconnecter",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),

// TweenAnimationBuilder(
//               tween: Tween<double>(begin: polka ? 0 : 1, end: !polka ? 0 : 1),
//               duration: fdur,
//               builder: (BuildContext context, double aval, Widget child) {
//                 return AnimatedContainer(
//                   duration: Duration(milliseconds: 500),
//                   height: polka ? 58 : 0,
//                   child: Transform.scale(
//                     scale: aval,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 40),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             "Bienvenue sur",
//                             style: TextStyle(color: Colors.white, fontSize: 20),
//                           ),
//                           SizedBox(height: 5),
//                           Row(
//                             children: <Widget>[
//                               Text(
//                                 "Mauri",
//                                 style:
//                                     TextStyle(color: Colors.blue, fontSize: 30),
//                               ),
//                               Text(
//                                 "Pressing",
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 30),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),