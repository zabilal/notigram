import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:notigram/base_module.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notigram/assets.dart';
import 'package:share/share.dart';

import 'package:notigram/screens/Terms.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var controller = ScrollController();
  double padding = 50;

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
            // BackButton(),
            addSpace(50),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Text(
                "Post a Notice!",
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

              addSpace(30),

              TextField(
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "Type your Notice or Image Description",
                  // prefixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                ),
              addSpace(30),
              RaisedButton(
                onPressed: () async {
                  showMessage(
                      context,
                      Icons.warning,
                      Colors.red,
                      "Post Notice",
                      "Do you want to post this ?",
                      clickYesText: "Yes",
                      cancellable: false,
                      clickNoText: "No", onClicked: (_) async {
                        if (_) {
                          
                          setState(() {});
                        }
                  }, delayInMilli: 900);
                },
                color: red,//bgColor,
                elevation: 12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.all(15),
                child: Center(
                    child: Text(
                  "Post",
                  style: textStyle(true, 16, white),
                )),
              ),
              addSpace(15),
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
