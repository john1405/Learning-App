import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learning/constant/Constantcolors.dart';
import 'package:learning/screen/HomePage/HomePage.dart';
import 'package:learning/services/Authentication.dart';
import 'package:learning/services/FIrebaseOperation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessagingHelper with ChangeNotifier {
  String lastMessageTime;
  String get getLastMessageTime => lastMessageTime;
  bool hasMemberJoined = false;
  bool get gethasMemberJoined => hasMemberJoined;
  ConstantColors constantColors = ConstantColors();

  leavetheRoom(
    BuildContext context,
    String chatRoomName,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Leave $chatRoomName',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: constantColors.redColor,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(chatRoomName)
                        .collection('members')
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .delete()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: Homepage(),
                              type: PageTransitionType.leftToRight));
                    });
                  })
            ],
          );
        });
  }

  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(documentSnapshot.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
                reverse: true,
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                  showLastMessageTime(documentSnapshot.data()['time']);
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: documentSnapshot.data()['message'] != null
                          ? MediaQuery.of(context).size.height * 0.17
                          : MediaQuery.of(context).size.height * 0.27,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 60.0, top: 20.0, bottom: 10.0),
                            child: Row(
                              children: [
                                Container(
                                  ///color: constantColors.redColor,
                                  constraints: BoxConstraints(
                                    maxHeight: documentSnapshot
                                                .data()['message'] !=
                                            null
                                        ? MediaQuery.of(context).size.height *
                                            0.18
                                        : MediaQuery.of(context).size.height *
                                            0.28,
                                    maxWidth: documentSnapshot
                                                .data()['message'] !=
                                            null
                                        ? MediaQuery.of(context).size.width *
                                            0.35
                                        : MediaQuery.of(context).size.width *
                                            0.46,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 120,
                                          child: Row(
                                            children: [
                                              Text(
                                                documentSnapshot
                                                    .data()['username'],
                                                style: TextStyle(
                                                  color:
                                                      constantColors.greenColor,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Provider.of<Authentication>(
                                                              context,
                                                              listen: false)
                                                          .getUserUid ==
                                                      adminUserUid
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .chessKing,
                                                        color: constantColors
                                                            .yellowColor,
                                                        size: 14.0,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 0.0,
                                                      height: 0.0,
                                                    )
                                            ],
                                          ),
                                        ),

                                        // Checking if message is a sticker then Change the Container height
                                        documentSnapshot.data()['message'] !=
                                                null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  documentSnapshot
                                                      .data()['message'],
                                                  style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Container(
                                                  height: 100.0,
                                                  width: 100.0,
                                                  child: Image.network(
                                                      documentSnapshot
                                                          .data()['sticker']),
                                                ),
                                              ),

                                        // showing the time of Message in the box
                                        Container(
                                          width: 80.0,
                                          child: Text(
                                            getLastMessageTime,
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 10.0,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Provider.of<Authentication>(
                                                      context,
                                                      listen: false)
                                                  .getUserUid ==
                                              documentSnapshot.data()['useruid']
                                          ? constantColors.blueGreyColor
                                              .withOpacity(0.8)
                                          : constantColors.blueGreyColor),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              top: 15.0,
                              child: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot.data()['useruid']
                                  ? Container(
                                      child: Column(
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: constantColors.blueColor,
                                                size: 18.0,
                                              ),
                                              onPressed: () {}),
                                          IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.trashAlt,
                                                color: constantColors.redColor,
                                                size: 18.0,
                                              ),
                                              onPressed: () {})
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: 0.0,
                                      width: 0.0,
                                    )),
                          Positioned(
                              left: 40,
                              child: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot.data()['useruid']
                                  ? Container(width: 0.0, height: 0.0)
                                  : CircleAvatar(
                                      radius: 18.0,
                                      backgroundColor: constantColors.darkColor,
                                      backgroundImage: NetworkImage(
                                          documentSnapshot.data()['userimage']),
                                    ))
                        ],
                      ),
                    ),
                  );
                }).toList());
          }
        });
  }

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController editter) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': editter.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserImage,
    });
  }

  Future checkIfhoined(
      BuildContext context, String chatroomname, String chatroomUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomname)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('initial states : $hasMemberJoined');
      if (value.data()['joined'] != null) {
        hasMemberJoined = value.data()['joined'];
        print('Final states : $hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatroomUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomname) {
    return showDialog(
      context: context,
      builder: (context) {
        return new AlertDialog(
          backgroundColor: constantColors.darkColor,
          title: Text(
            'Join $roomname',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            MaterialButton(
                child: Text('No',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      decoration: TextDecoration.underline,
                      decorationColor: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Homepage(),
                          type: PageTransitionType.bottomToTop));
                }),
            MaterialButton(
                color: constantColors.blueColor,
                child: Text('Yes',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(roomname)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .set({
                    'joined': true,
                    'username':
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .getInitUserName,
                    'usernimage':
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .getInitUserImage,
                    'useruid':
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid,
                    'time': Timestamp.now(),
                  }).whenComplete(() {
                    Navigator.pop(context);
                  });
                })
          ],
        );
      },
    );
  }

  showSticker(BuildContext context, String chatRoomId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 105.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: constantColors.blueColor)),
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset('assets/icons/sunflower.png'),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stickers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new GridView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  sendStickers(
                                      context,
                                      documentSnapshot.data()['image'],
                                      chatRoomId);
                                },
                                child: Container(
                                  height: 40.0,
                                  width: 40.0,
                                  child: Image.network(
                                      documentSnapshot.data()['image']),
                                ),
                              );
                            }).toList(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ));
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
                color: constantColors.darkColor),
          );
        });
  }

  sendStickers(
      BuildContext context, String stickerImageUrl, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'sticker': stickerImageUrl,
      'username': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserImage,
      'time': Timestamp.now(),
    });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
    notifyListeners();
  }
}
