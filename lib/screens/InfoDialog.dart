import 'package:flutter/material.dart';
import 'package:notigram/assets.dart';
import 'package:notigram/base_module.dart';

class InfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
onTap: (){
  Navigator.pop(context);
},
      child: Material(
        color: black.withOpacity(.3),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)
              )
            ),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                addSpace(10),
                Image.asset(
                  bank,
                  height: 50,
                  width: 100,
                ),
                addSpace(10),
                Text("This is your Available balance.",
                    style: textStyle(true, 15, black)),
                addSpace(10),
                Text("This is the amount that is available for you to "
                    "transfer. You must have at least \$25 to transfer "
                    "your earnings to you.",
                    style: textStyle(false, 15, black.withOpacity(.7))),
                addSpace(30),
                RaisedButton(onPressed: (){ Navigator.pop(context);},
                    padding: EdgeInsets.all(15),
                    color: bgColor,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text("Ok got it!", style: textStyle(true, 16, white),)))
              ],

            ),
          ),
        ),
      ),
    );
  }
}
