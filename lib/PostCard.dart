import 'package:flutter/material.dart';
import 'backbone/AppEngine.dart';
import 'assets.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  const PostCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width / 1,
              margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  //Board name
                  Expanded(
                    flex: -1,
                    child: Text(
                      "FUT Minna",
                      // maxLines: 1,
                      style: textStyle(true, 12, black),
                    ),
                  ),

                  //Users name
                  Expanded(
                    flex: -1,
                    child: Text(
                      "Posted by zakariyya raji \t\t\t\t\t\t${timeago.format(DateTime.fromMillisecondsSinceEpoch(1522129071))} ",
                      // maxLines: 2,
                      style: textStyle(false, 10, black),
                    ),
                  ),
                  addSpace(5),

                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Image.asset("assets/ava8.png", width: 50, height: 50,),
                      // imageHolder(50, avatars[7], round: true),
                      
                      //Users image/avatar
                      imageHolder(50, 'assets/ava8.png', round: true),
                      addSpaceWidth(5),

                      //User Biography
                      Expanded(
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: "CEO at ZAK Technologies, \n"
                                    "Hello how are uou doing, am a Journalist of great tribute. "
                                    "i live in lagos but i sleep in london everyday. so you see i am you",
                                style: textStyle(false, 14, Colors.grey)),
                          ]),
                          maxLines: 4,
                        ),
                      )
                    ],
                  ),
                  addSpace(5),

                  // Post content
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text:
                                "Hello how are you doing, am a Journalist of great tribute. i live in lagos but i sleep in london everyday. so you see i am you")
                      ]),
                      maxLines: 3,
                    ),
                  ),
                  Row()
                  // addSpaceWidth(5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
