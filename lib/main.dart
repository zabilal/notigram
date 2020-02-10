import 'package:flutter/services.dart';
import 'package:notigram/MainHome.dart';
import 'user/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'user/login_screen.dart';
import 'assets.dart';
import 'user/transition_route_observer.dart';
import 'package:notigram/walk_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:animated_splash/animated_splash.dart';
import 'animated_splash.dart';

// import 'package:flutter/foundation.dart'

// show debugDefaultTargetPlatformOverride; // for desktop embedder

Future<SharedPreferences> preferences = SharedPreferences.getInstance();


void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  // runApp(MyApp());
  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia; // for desktop embedder
  runApp(MyApp());
}

const String SERVER_KEY = "AAAAfnwG9WM:APA91bEfrqC-rbh_X6yB1Z0HpMn6DQWBQQSP7JPOTjybhg0Iz48VQbzCkYpsgpvlwxMTLPzxuUaiBKceHtvvexmIhwivtfVslY4b4_8JybVa2AgaHFxai4BEpKWxm995rGqVS8P5Nixz";

class MyApp extends StatefulWidget {
  // AppSetter(SharedPreferences prefs);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isSeen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBoolToSF();
  }

  getBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('seen') == null) isSeen = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notigram',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.red,
        accentColor: Colors.orange,
        cursorColor: Colors.orange,
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          display2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
            color: Colors.orange,
          ),
          button: TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          display4: TextStyle(fontFamily: 'Quicksand'),
          display3: TextStyle(fontFamily: 'Quicksand'),
          display1: TextStyle(fontFamily: 'Quicksand'),
          headline: TextStyle(fontFamily: 'NotoSans'),
          title: TextStyle(fontFamily: 'NotoSans'),
          subhead: TextStyle(fontFamily: 'NotoSans'),
          body2: TextStyle(fontFamily: 'NotoSans'),
          body1: TextStyle(fontFamily: 'NotoSans'),
          subtitle: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      // home: MainHome(),
      home: AnimatedSplash(
        backgroundColor: red1,
        imagePath: notigram,
        imageHeight: 50,
        imageWidth: 50,
        home: (isSeen == true) ? LoginScreen() : WalkthroughScreen(),
        // customFunction: duringSplash,
        duration: 5000,
        type: AnimatedSplashType.StaticDuration,
        // outputAndHome: routes,
      ),
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
        // "/": (context) => (isSeen == true) ? LoginScreen() : WalkthroughScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        // DashboardScreen.routeName: (context) => DashboardScreen(),
      },
    );
  }

}
