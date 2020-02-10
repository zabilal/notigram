// import 'dart:async';

// import 'package:notigram/SignUp.dart';
// import 'package:notigram/base_module.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:notigram/base_module.dart';
// import 'package:notigram/walk_screen.dart';
// import 'MainHome.dart';
// import 'PreLaunch.dart';
// import 'assets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_login/flutter_login.dart';

// BaseModel appSettingsModel;
// bool isAdmin = false;
// List<BaseModel> earnedUsers = List();
// StreamSubscription<DocumentSnapshot> userListenerController;
// StreamSubscription<DocumentSnapshot> appListenerController;
// Future<SharedPreferences> preferences = SharedPreferences.getInstance();
// SharedPreferences _preferences;

// void main() {
//   runApp(MyApp());
// }

// const String SERVER_KEY = "AAAANmzMafE:APA91bHH8pKQILWPZrPMtA_HRI3OsfXGHX"
//     "_CHS2e6QQvuy7iSlSiQHnC6LfhQ7qvosQ1XITumwKTOTVVJtD4Xt6XyFPBMPP_"
//     "aIGZ-NM4SNvjRNmwcMgz3ycr0qjAY4432QYdzhzfrSgH";

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'NotiGram',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primarySwatch: Colors.blue,
//           primaryColor: bgColor,
//           fontFamily: poppinBold),
//       color: white,
//       home: AppSetter(),
//     );
//   }
// }

// class AppSetter extends StatefulWidget {
//   // AppSetter(SharedPreferences prefs);

//   @override
//   _AppSetterState createState() => _AppSetterState();
// }

// //7d38ab7cd426413714018eadd07cd7ee7e4db1f8
// //7a80d386cb6e926dad00a48621f3e47bfea6b300
// class _AppSetterState extends State<AppSetter>
//     with SingleTickerProviderStateMixin {
//   AnimationController _animationController;
//   Animation _animation;

//   bool isSeen = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     BaseModule.init(
//         appColor: bgColor, appName: "NotiGram", appIcon: 'assets/notigram.png');

//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
// /*    cloudEmailPush(
//         type: 0,
//         email: "ammaugost@gmail.com",
//         fullName: "Maugost Okore",
//         referred: "");*/

//     getBoolToSF();

//     setUpAnimation();
//     // checkUser();
//     earnedUsersListener();
//     createBasicListeners();
//     fetchLinkData();
//   }

//   getBoolToSF() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.getBool('seen') == null)
//       isSeen = false;
//   }
 

//   @override
//   void dispose() {
//     super.dispose();
//     _animationController?.reset();
//   }

//   setUpAnimation() {
//     _animationController = new AnimationController(
//         vsync: this, duration: Duration(milliseconds: 700));
//     _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//         parent: _animationController, curve: Curves.easeInCirc));
//     _animationController.forward();
//   }

//   void fetchLinkData() async {
//     // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
//     var link = await FirebaseDynamicLinks.instance.getInitialLink();

//     // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
//     handleLinkData(link);

//     // This will handle incoming links if the application is already opened
//     FirebaseDynamicLinks.instance.onLink(
//         onSuccess: (PendingDynamicLinkData dynamicLink) async {
//       handleLinkData(dynamicLink);
//     }, onError: (OnLinkErrorException e) async {
//       showMessage(
//         context,
//         Icons.close,
//         red,
//         "Link Error",
//         "${e.message}",
//         cancellable: true,
//       );
//     });
//   }

//   void handleLinkData(PendingDynamicLinkData data) {
//     final Uri uri = data?.link;
//     if (uri != null) {
//       final queryParams = uri.queryParameters;
//       if (queryParams.length > 0) {
//         String p = queryParams["p2"];
//         // verify the username is parsed correctly
//         print("My p: $queryParams");
//         uid = p;
//         print("My Reward: $uid");
//         checkUser();
//       }
//     } else {
//       checkUser();
//     }
//   }

//   onError(e) {
//     showMessage(context, Icons.warning, Colors.red, "Link Error!", e.message,
//         cancellable: true, delayInMilli: 900, onClicked: (_) async {
//       showProgress(false, context);
//     });
//   }

//   checkUser() async {
//     FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //await createFirebaseDynamicLink();
//     await Future.delayed(Duration(milliseconds: 1500), () async {
//       if (user == null) {
//         Navigator.pushReplacement(
//             context,
//             PageRouteBuilder(
//                 opaque: true,
//                 pageBuilder: (a, b, c) {
//                   bool value = prefs.containsKey('seen');                  
//                   if (value) {
//                     // prefs.setBool('seen', false);
//                     print("Printing prefs value ${prefs.getBool('seen')}");
//                     if(prefs.getBool('seen') == false){
//                       return WalkthroughScreen();
//                     }else{
//                       return PreLaunch();
//                     }                    
//                   }
//                   else {
//                     prefs.setBool('seen', false);
//                     return WalkthroughScreen();
//                   }
//                 }));
//       } else {
//         Navigator.pushReplacement(
//             context,
//             PageRouteBuilder(
//                 opaque: true,
//                 pageBuilder: (a, b, c) {
//                   loadLocalUser(user.uid);
//                   return MainHome(); //
//                 }));
//       }
//     });
//   }

//   loadLocalUser(String userId, {Source source = Source.cache}) {
//     try {
//       Firestore.instance
//           .collection(USER_BASE)
//           .document(userId)
//           .get(source: source)
//           .then((doc) {
//         userModel = BaseModel(doc: doc);
//         isAdmin = userModel.isMaugost() || userModel.getBoolean(IS_ADMIN);
//       });
//       Firestore.instance
//           .collection(APP_SETTINGS_BASE)
//           .document(APP_SETTINGS)
//           .get(source: source)
//           .then((doc) {
//         appSettingsModel = BaseModel(doc: doc);
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       loadLocalUser(userId, source: Source.server);
//     }
//   }

//   createBasicListeners() async {
//     try {
//       FirebaseUser user = await FirebaseAuth.instance.currentUser();
//       if (user != null) {
//         loadLocalUser(user.uid);
//         userListenerController = Firestore.instance
//             .collection(USER_BASE)
//             .document(user.uid)
//             .snapshots()
//             .listen((shots) async {
//           if (shots.exists) {
//             userModel = BaseModel(doc: shots);
//             isAdmin = userModel.isMaugost() ||
//                 userModel.getEmail() == "chibuike.nwoke@gmail.com" ||
//                 userModel.getBoolean(IS_ADMIN);
//           }
//         });

//         appListenerController = Firestore.instance
//             .collection(APP_SETTINGS_BASE)
//             .document(APP_SETTINGS)
//             .snapshots()
//             //.get(source: Source.server)
//             .listen((shot) {
//           if (!shot.exists) {
//             BaseModel model = BaseModel();
//             model.saveItem(APP_SETTINGS_BASE, false, document: APP_SETTINGS);
//           }
//           if (shot != null) {
//             appSettingsModel = BaseModel(doc: shot);
//           }
//         });
//       }
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }

//   earnedUsersListener() async {
//     Firestore.instance.collection(USER_BASE).snapshots().listen((shots) async {
//       for (var doc in shots.documents) {
//         //print(doc.data);
//         BaseModel model = BaseModel(doc: doc);
//         bool isDummy = model.getBoolean(IS_DUMMY);

//         if (!isDummy && model.getList(REFERRALS).isEmpty) continue;
//         if (isDummy && model.getBoolean(DISABLED)) continue;

//         if (appSettingsModel != null &&
//             appSettingsModel.getBoolean(DISABLE_DUMMY) &&
//             isDummy) continue;

//         int p = earnedUsers.indexWhere((bm) => bm.getUId() == model.getUId());
//         bool exists = p != -1;
//         if (!exists) {
//           earnedUsers.insert(0, model);
//         } else {
//           earnedUsers.add(model);
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(earnedUsers.length);
//     return Scaffold(
//       body: FadeTransition(
//         opacity: _animation,
//         child: Stack(
//           children: <Widget>[
//             Container(
//               color: Color.fromRGBO(212, 20, 15, 1.0),
//             ),
//             Center(
//               child: Image.asset(
//                 notigram,
//                 width: 100,
//                 height: 100,
//               ),
//             ),
//             // Container(
//             //   decoration: BoxDecoration(
//             //       // color: APP_COLOR,
//             //       color: Color.fromRGBO(212, 20, 15, 1.0),
//             // // color: Colors.black.withOpacity(0.9),
//             // gradient: LinearGradient(
//             //   colors: [
//             //     Colors.black.withOpacity(0.1),
//             //     Colors.black.withOpacity(0.5)
//             //   ],
//             //   begin: Alignment.topCenter,
//             //   end: Alignment.bottomCenter,
//             //   //stops: [0.1, 0.1]
//             // )),
//             // ),
//             // Container(
//             //   decoration: BoxDecoration(
//             //       image: DecorationImage(
//             //           // image: AssetImage(klipp_splash), fit: BoxFit.cover)),
//             //           image: AssetImage(notigram),)),
//             // ),
//           ],
//         ),
//       ),
//     );
//     // return loadingLayout(icon: "assets/notigram.png");
//   }
// }

// createFakeAcct() async {
//   FirebaseAuth.instance.signOut().then((_) {
//     FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//             email: "terelouti9110@gmail.com", password: "123456")
//         .then((user) {
//       print(user.user.email + " " + user.user.uid);
//     }).catchError((e) {
//       print(e.toString());
//     });
//   });
// }

// cloudEmailPush(
//     {@required int type,
//     @required String email,
//     @required String fullName,
//     @required String referred}) async {
//   final HttpsCallable callable = CloudFunctions.instance
//       .getHttpsCallable(functionName: 'callEmailFromApp')
//         ..timeout = const Duration(seconds: 60);

//   var resp = await callable.call(<String, dynamic>{
//     'type': type,
//     'email': email,
//     'displayName': fullName,
//     'referred': referred,
//   });

//   print(resp.data);
// }

// createFirebaseDynamicLink() async {
//   final DynamicLinkParameters parameters = DynamicLinkParameters(
//     uriPrefix: 'klippitapp.page.link',
//     link: Uri.parse(
//         'https://klippitapp.com/invitedBy?p=${userModel.getString(REWARD_CODE)}'),
//     androidParameters: AndroidParameters(
//       packageName: 'com.Klippit',
//       minimumVersion: 16,
//     ),
//     iosParameters: IosParameters(
//       bundleId: 'com.fluidangle.klippitApp',
//       minimumVersion: '1.0.1',
//       appStoreId: '1479612085',
//     ),
//   );

//   parameters.buildUrl().then((ur) {
//     print("Dynamic Link : " + ur.toString());
//   }).catchError((e) {
//     print("e $e");
//   });
// }

