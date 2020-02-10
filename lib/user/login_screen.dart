import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:notigram/assets.dart';
import 'custom_route.dart';
import '../MainHome.dart';
import 'users.dart';
import 'package:notigram/base_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';



class LoginScreen extends StatefulWidget {
  
  static const routeName = '/auth';

  @override
  LoginScreenState createState ()=> LoginScreenState();
    
}
    
class LoginScreenState extends State<LoginScreen> {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  // static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> _signUpUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      // if (!mockUsers.containsKey(data.name)) {
      //   return 'Username not exists';
      // }
      // if (mockUsers[data.name] != data.password) {
      //   return 'Password does not match';
      // }
      // return null;

      if (data.name.isEmpty) {
        toast(scaffoldKey, "Please enter your email address");
        return;
      }
      // showProgress(true, context, msg: "Signing Up...");

      try {

        //Verify if email exist or not
        Firestore.instance
            .collection(USER_BASE)
            .where(EMAIL, isEqualTo: data.name.toLowerCase())
            .limit(1)
            //.orderBy(TIME, descending: true)
            .getDocuments(/*source: Source.server*/)
            .then((shots) {
          print(shots.documents.length);
          if (shots.documents.length > 0) {
            showProgress(false,context,);
            
            showMessage(
                context,
                Icons.warning,
                Colors.red,
                "Email Error!",
                "You have entered an email address that exist."
                    " Only unique emails are allowed.",
                //clickYesText: "Try Again",
                cancellable: true,
                //onClicked: (_) async {},
                delayInMilli: 900);
            return;
          }

          var user = FirebaseAuth.instance.createUserWithEmailAndPassword(email: data.name, password: data.password);
          print("Created User data ::: $user");

          // if no error go to next page
          // Navigator.of(context).pushReplacement(FadePageRoute(
          //   builder: (context) => MainHome(),
          // ));
          // ================================

      //     FirebaseAuth.instance.currentUser().then((user) {
      //       if (user != null) {
      //         AuthCredential emailCredential = EmailAuthProvider.getCredential(
      //             email: data.name, password: data.password);
      //         user.linkWithCredential(emailCredential);

      //         Firestore.instance
      //             .collection(USER_BASE)
      //             .document(user.uid)
      //             .get()
      //             .then((doc) {
      //           BaseModel model = BaseModel(doc: doc);
      //           model.put(EMAIL, data.name);
      //           model.put(PASSWORD, data.password);
      //           // model.put(FULL_NAME, nameController.text);
      //           model.updateItems();
      //           // pageController.nextPage(
      //           //     duration: Duration(milliseconds: 500), curve: Curves.ease);
      //           showProgress(
      //             false,
      //             context,
      //           );
      //         });
      //       }
      //     });
        });
      } on PlatformException catch (e) {
        showProgress(false, context);
        showMessage(context, Icons.warning, Colors.red, "Email Error!", e.message,
            clickYesText: "Try Again",
            delayInMilli: 900,
            onClicked: (_) async {});
      }

      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      // title: Constants.appName,
      title: "",
            
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        // return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _signUpUser(loginData);
      },
      // onSubmitAnimationCompleted: () {
      //   Navigator.of(context).pushReplacement(FadePageRoute(
      //     builder: (context) => MainHome(),
      //     // builder: (context) => DashboardScreen(),
      //   ));
      // },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      // showDebugButtons: true,
    );
  }

  checkEmail(String email, String password) async {
    // String email = emailController.text.trim();
    
  }

}