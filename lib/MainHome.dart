import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:notigram/AddBoard.dart';
import 'package:notigram/AddPost.dart';
import 'package:notigram/BoardTab.dart';
import 'package:notigram/HomeTab.dart';
import 'package:notigram/Messages.dart';
import 'package:notigram/ViewUsers.dart';
import 'package:notigram/backbone/basemodel.dart';
import 'package:notigram/base_module.dart';
import 'package:flutter/material.dart';
import 'package:notigram/assets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:notigram/screens/PostDialog.dart';
// import 'package:notigram/screens/CashoutDialog.dart';
import './bottombar/fab_with_icons.dart';
import './bottombar/fab_bottom_app_bar.dart';
import './bottombar/layout.dart';
// import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
// import 'package:popup_menu/popup_menu.dart';
import 'package:super_tooltip/super_tooltip.dart';

var _firebaseMessaging = FirebaseMessaging();

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {

  bool reverseScroll = false;
  var scrollController = ScrollController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Timer timer;
  bool enableInfinity = true;
  int realPage = 10000;
  double counter = 0;

  int _currentIndex = 0;
  PageController _pageController;
  DecorationImage img;

  String _lastSelected = 'TAB: 0';

  void _selectedTab(int index) {
    print('Tab selected : $index');
    setState(() {
      _lastSelected = 'TAB: $index';
      _currentIndex = index;
    });
  }

  void _selectedFab(int index) {
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createBasicListeners();
    setupPush();
    scrollController.addListener(autoScrollListener);
    Future.delayed(Duration(milliseconds: 15), () {
      scrollController.animateTo(
        1,
        duration: new Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    });
    _pageController = PageController();
    
    
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
          setupPush();
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
    _pageController.dispose();
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
      
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
                    
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text('Boards'),
              activeColor: Colors.purpleAccent),
          BottomNavyBarItem(
              icon: Icon(Icons.edit),
              title: Text('Post'),
              activeColor: Colors.pink),
          BottomNavyBarItem(
              icon: Icon(Icons.message),
              title: Text('Message'),
              activeColor: Colors.blue),
          BottomNavyBarItem(
              icon: Icon(Icons.alarm),
              title: Text('Notice'),
              activeColor: Colors.blue),
        ],
      ),
          
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            // Container(color: Colors.blueGrey,),
            HomeTab(),
            BoardTab(),
            AddPost(),
            Messages(),
            Container(color: Colors.redAccent,
            child: Center(
              child: Text("Hold on, we are here!"),
            ),)
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

  inputItemTv(String title, String text, icon, onTap, String hint) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: textStyle(true, 12, black.withOpacity(.4)),
        ),
        //addSpace(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 25,
              color: black.withOpacity(.4),
            ),
            addSpaceWidth(10),
            Flexible(
              child: InkWell(
                onTap: onTap,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          text.isEmpty ? hint : text,
                          style: textStyle(false, 17,
                              black.withOpacity(text.isEmpty ? (.2) : 1)),
                        ),
                      ),
                      addSpaceWidth(10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        //addSpace(10),
        addLine(1, black.withOpacity(.1), 0, 0, 0, 20)
      ],
    );
  }

}
