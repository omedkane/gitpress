import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mauripress/Mahome_animator.dart';
import 'package:mauripress/Providers/AppSettingsProvider.dart';
import 'package:mauripress/Providers/KartProvider.dart';
import 'package:mauripress/Providers/PhoneMaster.dart';
import 'package:mauripress/locator.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
// import 'package:mauripress/HomeScreen.dart';
// import 'Mahome.dart';

void main() {
  // Provider.debugCheckInvalidValueType = null;
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CartProvider>(
          lazy: true, create: (context) => CartProvider()),
      ChangeNotifierProvider(
          lazy: true, create: (context) => locator.get<PhoneMaster>()),
      // ChangeNotifierProvider(lazy: true,create: (context) => ClotheCatalogue()),
      ChangeNotifierProvider(
          lazy: true, create: (context) => AppSettingsProvider()),
    ],
    child: myApp(),
  ));
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      builder: OneContext().builder,
      navigatorKey: OneContext().key,
      title: 'Am Back',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'HNow',
          textTheme: TextTheme(bodyText2: TextStyle(fontSize: 18)),
          backgroundColor: Colors.white),
      // home: HomeScreen(
      //   title: "Yeah Buddy",
      // ),
      // home: Consumer<PhoneMaster>(
      //   builder: (context, umaster, child) {
      //     return umaster.dauser == null ? HomeAnimator() : HomeScreen();
      //   },
      // ),
      // home: SettingPage(),
      home: HomeAnimator(),
      // home: AdminHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
