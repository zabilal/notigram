import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notigram/assets.dart';
import 'package:notigram/backbone/AppEngine.dart';
import 'package:notigram/backbone/baseEngine.dart';

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool reverseScroll = false;
  var scrollController = ScrollController();
  Timer timer;
  bool enableInfinity = true;
  int realPage = 10000;
  double counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(autoScrollListener);

    Future.delayed(Duration(milliseconds: 15), () {
      scrollController.animateTo(
        1,
        duration: new Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    });
  }

  autoScrollListener() {
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

  randUsersItem(int index) {
    final int p = _getRealIndex(index /*+ widget.initialPage*/, realPage, 20);

    BaseModel model = BaseModel();
    //BaseModel model = randUsers[index];
    bool isCenter = (p).isEven;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (isCenter) addSpace(1),
        IgnorePointer(
          child: imageHolder(60, "../assets/ava8.png", round: false),
        ),
        addSpace(2),
        Text(
          "zakariyya",
          style: textStyle(false, 12, Colors.black.withOpacity(.6)),
        ),
      ],
    );
  }

  int _getRealIndex(int position, int base, int length) {
    final int offset = position - base;
    return _remainder(offset, length);
  }

  int _remainder(int input, int source) {
    final int result = input % source;
    return result < 0 ? source + result : result;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
              color: red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(150, 90),
                bottomRight: Radius.elliptical(0, 0),
              )),
        ),
        SafeArea(
          // bottom: false,
          child:
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              //Search field
              Container(
                // padding: const EdgeInsets.all(15.0),
                height: 45,
                child: TextField(
                  onChanged: (value) {
                    // filterSearchResults(value);
                  },
                  // controller: searchController,
                  decoration: InputDecoration(
                      // labelText: "Search",
                      fillColor: white,
                      filled: true,
                      hintText: "Search Boards",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                ),
              ),

              addSpace(10),
              //Subscribed boards list
                Expanded(
                                  child: Container(
                    color: white,
                    child: Column(
                      children: <Widget>[
                        addSpace(10),
                        // Container(
                        //   padding: EdgeInsets.all(10),
                        //   color: white,
                        //   child:
                           Center(
                            child: Text(
                              "Direct Messages",
                              style: textStyle(
                                true,
                                15,
                                bgColor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        // ),
                        // addSpace(10),
                        // Container(
                        //   height: 450,
                        //   // margin: EdgeInsets.only(top: 0, bottom: 0),
                        //   child: 
                        Flexible(
                                                  child: SingleChildScrollView(
                            child: 
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: 20,
                                itemBuilder: (context, position) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              imageHolder(
                                                50,
                                                notigram,
                                              ),
                                              addSpaceWidth(10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Message Subject",
                                                    // maxLines: 1,
                                                    softWrap: true,
                                                    style: textStyle(true, 17, black),
                                                  ),
                                                  addSpace(5),
                                                  Text(
                                                    "Sender's Name",
                                                    style:
                                                        textStyle(false, 15, black),
                                                  ),
                                                  addSpace(5),
                                                ],
                                              ),
                                              addSpaceWidth(10),
                                              Text(" ${readTimestamp(1522129071)}",
                                              style: textStyle(false, 10, black),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),),
                        )
                        // )
                        //
                      ],
                    ),
                  ),
                ),
              
            ],
          ),
        ),
        ),
      ],
    );
  }
}
