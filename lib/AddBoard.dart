import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:notigram/base_module.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notigram/assets.dart';
import 'package:share/share.dart';

import 'package:notigram/screens/Terms.dart';

class AddBoard extends StatefulWidget {
  @override
  _AddBoardState createState() => _AddBoardState();
}

class _AddBoardState extends State<AddBoard> {
  var controller = ScrollController();
  double padding = 50;

  List<String> details = [
    "notigram rewards you for inviting friends to join notigram. Earn unlimited rewards!",
    "Everyone who signs up for Klippit gets an invite reward code to share. Yours is",
    "Share your code with friends by coping it or using the button below. "
        "They'll be invited to download and join Klippit.",
    "When a friend that is new to Klippit signs up using your link or code, you receive \$1.",
    "You can invite as many friends as you want. Keep sharing and keep earning!"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      if (controller != null && controller.position.pixels == 0) {
        setState(() {
          padding = 50;
        });
      } else {
        setState(() {
          padding = 20;
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return Sliver
    return Scaffold(
      //backgroundColor: white,
      backgroundColor: bgColor,
      //appBar: appBar(),
      //body: page2(),
      body: page(),
    );
  }

  appBar() {
    return Container(
      color: white,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackButton(),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                "Apply to Create Board",
                style: textStyle(true, 25, black),
              ),
            ),
            Row(
              children: <Widget>[
                Flexible(
                    flex: 2,
                    child: addLine(4, red, 5, 10, 0, 10)),
                // Flexible(child: addLine(4, Colors.yellow, 0, 10, 5, 10)),
              ],
            )
          ],
        ),
      ),
    );
  }

  page() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        appBar(),
        pageTop(),
      ],
    );
  }

  pageTop() {
    return Flexible(
      child: Container(
        padding: EdgeInsets.all(15),
        color: white,
        child: LayoutBuilder(builder: (context, box) {
          return ListView(
            padding: EdgeInsets.all(0),
            children: [

              addImage(),

              TextField(
                  // controller: searchController,
                  decoration: InputDecoration(
                      // labelText: "Search",
                      // fillColor: white,
                      // filled: true,
                      hintText: "Proposed Name",
                      prefixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                ),

                addSpace(30),
              TextField(
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "Enter a Short Description",
                  // prefixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                ),
              addSpace(30),
              RaisedButton(
                onPressed: () async {
                  await Share.share(
                    "Hey when you sign up for Klippit we both earn \$1."
                    "Register on Klippit with referal code ${userModel.getString(REWARD_CODE)}",
                  );
                },
                color: red,//bgColor,
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.all(15),
                child: Center(
                    child: Text(
                  "Apply",
                  style: textStyle(true, 16, white),
                )),
              ),
              addSpace(15),
              // GestureDetector(
              //   onTap: () {
              //     goToWidget(context, TermsAndConditions());
              //   },
              //   child: Text.rich(
              //     TextSpan(children: [
              //       TextSpan(
              //           text: "See",
              //           style: textStyle(true, 14, black.withOpacity(.4))),
              //       TextSpan(
              //           text: " Terms & Conditions ",
              //           style: textStyle(true, 14, bgColor)),
              //       TextSpan(
              //           text: "for more details",
              //           style: textStyle(true, 14, black.withOpacity(.4)))
              //     ]),
              //     textAlign: TextAlign.center,
              //     style: textStyle(true, 16, black),
              //   ),
              // )
            ],
          );
        }),
      ),
    );
  }

  addImage() {
    return Container(
      color: white,
      // padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // addSpace(10),
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


}
