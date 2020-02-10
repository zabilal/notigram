import 'package:flutter/material.dart';
import 'package:notigram/AddBoard.dart';
import 'package:notigram/assets.dart';
import 'package:notigram/base_module.dart';
import 'package:notigram/AddPost.dart';


class PostDialog extends StatefulWidget {
  @override
  PostDialogState createState() => PostDialogState();
}

class PostDialogState extends State<PostDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Material(
        color: black.withOpacity(.3),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[                
                addSpace(20),
                RaisedButton(
                    onPressed: () {
                        Navigator.pop(context);
                        goToWidget(context, AddBoard());
                    },
                    padding: EdgeInsets.all(15),
                    color: bgColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Text("Create a Board",
                      style: textStyle(true, 16, white),
                    ))),
                    addSpace(20),
                RaisedButton(
                    onPressed: () {
                        Navigator.pop(context);
                        goToWidget(context, AddPost());
                    },
                    padding: EdgeInsets.all(15),
                    color: bgColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Text("Post Notice",
                      style: textStyle(true, 16, white),
                    ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
