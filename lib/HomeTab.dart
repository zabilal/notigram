import 'dart:async';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:notigram/AddBoard.dart';
import 'package:notigram/PostCard.dart';
import 'package:notigram/backbone/basemodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notigram/base_module.dart';
import 'package:notigram/base_module.dart';
import 'package:notigram/navigationUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notigram/screens/InfoDialog.dart';
import 'package:share/share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notigram/assets.dart';
import 'package:notigram/screens/Terms.dart';
import 'package:dotted_border/dotted_border.dart';
import 'CreateDummy.dart';
import 'PreLaunch.dart';
import 'ViewDummy.dart';
import 'ViewUsers.dart';
import 'main.dart';
import 'DetailPage.dart';
import 'screens/HowitWorks.dart';
import 'screens/AboutKlippit.dart';
import 'screens/Earnings.dart';
import 'screens/NeedHelp.dart';
import 'screens/PrivacyPolicy.dart';
import 'screens/VerifiedInfluencers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import './bottombar/fab_with_icons.dart';
import './bottombar/fab_bottom_app_bar.dart';
import './bottombar/layout.dart';

var _firebaseMessaging = FirebaseMessaging();

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool reverseScroll = false;
  var scrollController = ScrollController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Timer timer;
  bool enableInfinity = true;
  int realPage = 10000;
  double counter = 0;

  DecorationImage img;

  String _lastSelected = 'TAB: 0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // createBasicListeners();
    // setupPush();
    scrollController.addListener(autoScrollListener);
    Future.delayed(Duration(milliseconds: 15), () {
      scrollController.animateTo(
        1,
        duration: new Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    });
  }

  createFirebaseDynamicLink(onLinkCreated) async {
    print("url......");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://klippitapp.com',
      link: Uri.parse(
          // 'https://klippitapp.com/invitedBy?p1=${userModel.getFullName()}&p2=${userModel.getUId()}'),
          // 'https://klippitapp.com/invitedBy?p=${userModel.getString(REWARD_CODE)}'),
          'https://klippitapp.com/invitedBy?p=${userModel.getRewardCode()}'),
      androidParameters: AndroidParameters(
        packageName: 'com.klippit',
        minimumVersion: 16,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.fluidangle.klippitApp',
        minimumVersion: '1.0.1',
        appStoreId: '1479612085',
      ),
    );
    parameters.buildShortLink().then((ur) {
      onLinkCreated(ur.shortUrl.toString());
    }).catchError(onError);
  }

  bool hasStarted = false;
  List<StreamSubscription> subscriptions = List();

  createBasicListeners() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // print(user.uid);
    if (user != null) {
      var sub = Firestore.instance
          .collection(USER_BASE)
          .document(user.uid)
          .snapshots()
          .listen((shot) async {
        if (!shot.exists) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
            // return PreLaunch();
          }));
          return;
        }
        userModel = BaseModel(doc: shot);
        //isAdmin = userModel.isMaugost() || userModel.getBoolean(IS_ADMIN);
        // isAdmin = userModel.isMaugost() ||
        //     userModel.getEmail() == "chibuike.nwoke@gmail.com" ||
        //     userModel.getBoolean(IS_ADMIN);
        hasStarted = true;
        if (!hasStarted) {
          // setupPush();
          scrollController.addListener(autoScrollListener);
          Future.delayed(Duration(milliseconds: 15), () {
            scrollController.animateTo(
              1,
              duration: new Duration(milliseconds: 50),
              curve: Curves.linear,
            );
          });
        }
        if (mounted) setState(() {});
      });
      subscriptions.add(sub);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController?.removeListener(autoScrollListener);
    scrollController?.dispose();
    timer?.cancel();
    for (StreamSubscription sub in subscriptions) sub?.cancel();
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

  bool drawerVisible = false;
  autoScrollListener() {
    /*counter = counter < scrollController.position.maxScrollExtent
        ? scrollController.position.pixels + 100
        : scrollController.position.maxScrollExtent;*/
    if (drawerVisible) {
      return;
    }
    setState(() {
      counter = scrollController.position.pixels + 25;
      //counter = counter + 5;
    });

    if (scrollController != null && !scrollController.position.outOfRange) {
      scrollController.animateTo(
        counter,
        duration: new Duration(milliseconds: 3000),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor1,
      key: scaffoldKey,
      drawer: kDrawer(),
      body: pageB(),
    );
  }

  pageB() {
    Text(
      "How do I achieve this message dot on  chat with firebase firestore?",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    return Stack(
      //fit: StackFit.expand,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 5,
          decoration: BoxDecoration(
              color: red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(150, 50),
                bottomRight: Radius.elliptical(150, 50),
              )),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Drawer menu icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState.openDrawer();
                            bool open = scaffoldKey.currentState.isDrawerOpen;
                            if (open) {
                              setState(() {
                                drawerVisible = true;
                              });
                            } else {
                              setState(() {
                                drawerVisible = false;
                              });
                              Future.delayed(Duration(milliseconds: 15), () {
                                print("scrolling enabled");
                                scrollController.animateTo(
                                  counter + 5,
                                  duration: new Duration(milliseconds: 50),
                                  curve: Curves.linear,
                                );
                              });
                            }
                          },
                          child:imageHolder(50, "assets/ava8.png"),
                          ),
                          
                    ),
                    //Add searcb bar here
                    addSpaceWidth(10),

                  ],
                ),

                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        addSpace(30),
                        PostCard(),
                        PostCard(),
                        PostCard(),
                        PostCard(),
                        PostCard(),
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

  kDrawer() {
    return Drawer(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(color: red),
          Column(
            children: <Widget>[drawerTop(), drawerBtm()],
          )
        ],
      ),
    );
  }

  drawerTop() {
    return Container(
      color: white,
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            addSpace(10),
            GestureDetector(
              onTap: () {
                if (userModel.getBoolean(USE_AVATAR)) return;
                showListDialog(
                  context,
                  userModel.getImage().isEmpty
                      ? ["Add Photo"]
                      : [
                          "View Picture",
                          "Update Picture",
                        ],
                  onClicked: (position) async {
                    if (userModel.getImage().isEmpty && position == 0) {
                      addUpdatePicture(context, userModel);
                    }
                    if (userModel.getImage().isEmpty && position == 0 ||
                        userModel.getImage().isNotEmpty && position == 1) {
                      addUpdatePicture(context, userModel);
                      return;
                    }

                    if (userModel.getImage().isNotEmpty && position == 0) {
                      popUpWidget(
                          context,
                          PreviewImage(
                            imageURL: userModel.getImage(),
                          ));
                      return;
                    }
                  },
                  useTint: false,
                  delayInMilli: 10,
                );
              },
              child: imageHolder(
                userModel.getBoolean(USE_AVATAR) ? 70 : 95,
                userModel.getBoolean(USE_AVATAR)
                    ? avatars[userModel.getInt(AVATAR_POSITION)]
                    : userModel.getImage(),
                local: userModel.getBoolean(USE_AVATAR),
              ),
            ),
            addSpace(10),            
            Text(
              "${userModel.getFullName()}",
              style: textStyle(false, 14, white),
            ),
            addSpace(10),
          ],
        ),
      ),
    );
  }

  addUpdatePicture(BuildContext context, BaseModel profileInfo) {
    showListDialog(
      context,
      [
        "Take a  Picture",
        "Select a Picture",
      ],
      onClicked: (position) async {
        showProgress(true, context, msg: "Uploading Photo");

        if (position == 0) {
          File file = await getImagePicker(ImageSource.camera);
          if (file == null) return;
          File cropped = await cropImage(file);
          UploadEngine uploadEngine = UploadEngine(
              uploadPath: profileInfo.getUId(), fileToSave: cropped);
          String imageURL =
              await uploadEngine.uploadPhoto(uid: profileInfo.getUId());
          userModel.put(IMAGE, imageURL);
          userModel.updateItems();
          showProgress(false, context);
          setState(() {});
        }
        if (position == 1) {
          File file = await getImagePicker(ImageSource.gallery);
          if (file == null) return;
          File cropped = await cropImage(file);
          UploadEngine uploadEngine = UploadEngine(
              uploadPath: profileInfo.getUId(), fileToSave: cropped);
          String imageURL =
              await uploadEngine.uploadPhoto(uid: profileInfo.getUId());
          userModel.put(IMAGE, imageURL);
          userModel.updateItems();
          showProgress(false, context);
          setState(() {});
        }
      },
      useTint: false,
      delayInMilli: 10,
    );
  }

  drawerBtm() {
    //print("About KlippIt".length);
    return Flexible(
      child: SingleChildScrollView(
        child: Column(          
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //padding: EdgeInsets.only(left: 10, right: 10),
          children: <Widget>[
            addSpace(10),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                // color: red03,
                child: Column(
                  children: <Widget>[
                    CupertinoButton(
                      onPressed: () {},
                      pressedOpacity: 0.5,
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        onTap: () {
                          // goToWidget(context, AboutKlippit());
                        },
                        title: Text(
                          "My Profile",
                          style: textStyle(true, 18, white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: ("My Profile".length * 12).roundToDouble(),
                          left: 10),
                      child: addLine(4, Colors.white, 0, 0, 0, 0),
                    ),
                    CupertinoButton(
                      onPressed: () {},
                      pressedOpacity: 0.5,
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        onTap: () {
                          goToWidget(context, HowItWorks());
                        },
                        title: Text(
                          "My Activities",
                          style: textStyle(true, 18, white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 100, left: 10),
                      child: addLine(4, white, 0, 0, 0, 0),
                    ),
                    CupertinoButton(
                      onPressed: () {},
                      pressedOpacity: 0.5,
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        onTap: () {
                          goToWidget(context, VerifiedInfluencers());
                        },
                        title: Text(
                          "Drafts",
                          style: textStyle(true, 18, white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: (100), left: 10),
                      child: addLine(4, white, 0, 0, 0, 0),
                    ), 
                    CupertinoButton(
                      onPressed: () {},
                      pressedOpacity: 0.5,
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        onTap: () {
                          goToWidget(context, AddBoard());
                        },
                        title: Text(
                          "Add Board",
                          style: textStyle(true, 18, white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: (100), left: 10),
                      child: addLine(4, white, 0, 0, 0, 0),
                    ),
                    CupertinoButton(
                      onPressed: () {},
                      pressedOpacity: 0.5,
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        onTap: () {
                          goToWidget(context, NeedHelp());
                        },
                        title: Text(
                          "Bookmarks",
                          style: textStyle(true, 18, white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: (100), left: 10),
                      child: addLine(4, white, 0, 0, 0, 0),
                    ),
                    addSpace(40),
                    CupertinoButton(
                      onPressed: () {},
                      pressedOpacity: 0.5,
                      padding: EdgeInsets.all(0),
                      child: ListTile(
                        onTap: () {
                          showMessage(context, Icons.warning, Colors.red,
                              "Logout?", "Are you sure you want to logout?",
                              clickYesText: "Yes",
                              cancellable: true, onClicked: (_) async {
                            showProgress(true, context,
                                cancellable: true, msg: "Logging Out");
                            // userListenerController?.cancel();
                            await FirebaseAuth.instance.signOut();
                            await BaseModule.resetCurrentUser();
                            // clearScreenUntil(context, PreLaunch());
                          });
                        },
                        title: Text(
                          "Logout",
                          style: textStyle(true, 18, white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: ("About KlippIt".length * 12).roundToDouble(),
                          left: 10),
                      child: addLine(4, red04, 0, 0, 0, 0),
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
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

                                        