import 'dart:async';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:notigram/backbone/basemodel.dart';
import 'package:notigram/base_module.dart';
import 'package:notigram/base_module.dart';
import 'package:notigram/navigationUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notigram/assets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

var _firebaseMessaging = FirebaseMessaging();

class AbraScreen extends StatefulWidget {
  @override
  _AbraScreenState createState() => _AbraScreenState();
}

class _AbraScreenState extends State<AbraScreen> {
  bool reverseScroll = false;
  var scrollController = ScrollController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Timer timer;
  bool enableInfinity = true;
  int realPage = 10000;
  double counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // createBasicListeners();
    setupPush();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setupPush() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: ${message['data']}");
        BaseModel bm = BaseModel(items: message['data']);
        print(bm.items);
        //NotifyEngine(context, bm, HandleType.incomingNotification);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: ${message['data']}");
        BaseModel bm = BaseModel(items: message['data']);
        print(bm.items);
        //NotifyEngine(context, bm, HandleType.incomingNotification);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: ${message['data']}");
        BaseModel bm = BaseModel(items: message['data']);
        print(bm.items);
        //NotifyEngine(context, bm, HandleType.incomingNotification);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((String token) async {
      userModel.put(PUSH_NOTIFICATION_TOKEN, token);
      userModel.updateItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: bgColor1, key: scaffoldKey, body: pageB());
  }

  pageB() {
    return Stack(
      //fit: StackFit.expand,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(150, 50),
                bottomRight: Radius.elliptical(150, 50),
              )),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BackButton(color: white),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        addSpace(10),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[],
                          ),
                        ),
                        // addSpace(15),
                        Text(
                          "notigram uses ABRA to send money.",
                          style: textStyle(true, 15, white),
                        ),
                        addSpace(10),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(15)),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                addSpace(10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 70),
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        logo_bg,
                                        width: 70,
                                        height: 55,
                                      ),
                                      // addSpace(30),
                                      Image.asset(
                                        abra,
                                        width: 55,
                                        height: 55,
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  "Why we choose ABRA as our "
                                  "preferred wallet",
                                  textAlign: TextAlign.center,
                                  style: textStyle(true, 20, txColor),
                                ),
                                addSpace(20),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset(
                                        lock,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Text(
                                        "Secure, modern encryption \n"
                                        "technology to secure your \n"
                                        "information",
                                        textAlign: TextAlign.left)
                                  ],
                                ),
                                // addSpace(20),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset(
                                        shield,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Text(
                                      "Versatile, withdraw the money \n"
                                      "and send to a bank account, or \n"
                                      "reinvest in Crypto. You choose",
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                                // addSpace(20),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset(
                                        bank,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Text(
                                        "Rewards for our Users, Get \$10 \n"
                                        "just for activating an ABRA wallet",
                                        textAlign: TextAlign.left)
                                  ],
                                ),
                                addSpace(20),
                                RaisedButton(
                                    onPressed: _launchURL, //() {

                                    // if (abraStatus == 0) {
                                    //   // Enter cashout process
                                    //   // goToWidget(context, ConfirmScreen());
                                    // } else {
                                    //   goToWidget(context, AbraScreen());
                                    // }
                                    // Navigator.pop(context);
                                    //},
                                    padding: EdgeInsets.all(15),
                                    color: bgColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Text(
                                      "Download ABRA to Receive Your Money",
                                      style: textStyle(true, 14, white),
                                    ))),
                                addSpace(30),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _launchURL() async {
    const url = 'https://invite.abra.com/d7WCbGNXsR';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  makeAdmin(String email, bool add) async {
    QuerySnapshot shots = await Firestore.instance
        .collection(USER_BASE)
        .where(EMAIL, isEqualTo: email)
        .limit(1)
        .getDocuments();
    for (DocumentSnapshot doc in shots.documents) {
      BaseModel model = BaseModel(doc: doc);
      model.put(IS_ADMIN, true);
      model.updateItems();
      toastInAndroid("Added");
    }
    showMessage(
        context,
        Icons.check,
        dark_green1,
        "Admin ${add ? "Added" : "Removed"}!?",
        "$email has been successfully added as an admin user!",
        clickYesText: "Ok",
        cancellable: true,
        delayInMilli: 900);
  }

  resetUsers() async {
    showProgress(true, context, msg: "Resetting Users...");
    QuerySnapshot shots =
        await Firestore.instance.collection(USER_BASE).getDocuments();
    for (DocumentSnapshot doc in shots.documents) {
      BaseModel model = BaseModel(doc: doc);
      bool isDummy = model.getBoolean(IS_DUMMY);
      if (isDummy) continue;
      var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: model.getEmail(), password: "%%*01234*%%");
      if (user != null) {
        await user.user.delete();
        model.deleteItem();
      }
    }
    showProgress(false, context);
    showMessage(context, Icons.check, dark_green1, "Reset Successful!",
        "Users has been successfully resetted and cleared!",
        clickYesText: "Ok", cancellable: true, delayInMilli: 900);
  }

  onError(e) {
    showMessage(context, Icons.warning, Colors.red, "Link Error!", e.message,
        cancellable: true, delayInMilli: 900, onClicked: (_) async {
      showProgress(false, context);
    });
  }
}
