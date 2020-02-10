import 'package:flutter/material.dart';
import "package:flutter_swiper/flutter_swiper.dart";
import 'package:notigram/base_module.dart';
import "package:notigram/models/walkthrough.dart";
import 'package:notigram/user/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notigram/custom_flat_button.dart';
import 'package:notigram/PreLaunch.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';

class WalkthroughScreen extends StatefulWidget {

    WalkthroughScreen();

  final List<Walkthrough> pages = [
  Walkthrough(
      icon: Icons.note_add,
      title: "Flutter Onboarding",
      description:
          "Build your onboarding flow in seconds.",
    ),
  Walkthrough(
    icon: Icons.layers,
    title: "Firebase Auth",
    description: "Use Firebase for user management.",
  ),
  Walkthrough(
    icon: Icons.info,
    title: "Facebook Login",
    description:
        "Leverage Facebook to log in user easily.",
  ),
  ];

  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () {
          // addBoolToSF();
          goToWidget(context, LoginScreen());
        },
        onSkipButtonPressed: () {
            // Navigator.of(context).pushReplacementNamed('/mainPage'),\
            // addBoolToSF();
            Navigator.of(context).pop();
            goToWidget(context, LoginScreen());
        }
      ),
    );
  }

  final pageList = [
    PageModel(
        // color: const Color(0xFF678FB4),
        color: Color.fromRGBO(212, 20, 15, 1.0),
        heroAssetPath: 'assets/notigram.png',
        title: Text('Hotels',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text('All hotels and hostels are sorted by hospitality rating',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconAssetPath: information        ),
    PageModel(
        color: const Color(0xFF65B0B4),
        heroAssetPath: 'assets/notigram.png',
        title: Text('Banks',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(
            'We carefully verify all banks before adding them into the app',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconAssetPath: information
        ),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroAssetPath: 'assets/notigram.png',
      title: Text('Store',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text('All local stores are categorized for your convenience',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      iconAssetPath: information,
    ),
  ];
 
  addBoolToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seen', true);
  }
}
