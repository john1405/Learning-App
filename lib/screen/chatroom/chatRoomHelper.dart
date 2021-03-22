import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learning/constant/Constantcolors.dart';
import 'package:learning/screen/AltProfile/alt_profile.dart';
import 'package:learning/screen/Messaging/GorupMessage.dart';
import 'package:learning/services/Authentication.dart';
import 'package:learning/services/FIrebaseOperation.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelper with ChangeNotifier {
  String latestMessageTime;
  String get getlatestMessageTime => latestMessageTime;
  String chatRoomAvatarUrl, chatroomId;
  String get getChatroomId => chatroomId;
  String get getChatroomAvatarUrl => chatRoomAvatarUrl;
  ConstantColors constantColors = ConstantColors();
  final TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetail(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.34,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.blueColor),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Members',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid !=
                                    documentSnapshot.data()['useruid']) {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                              userUid: documentSnapshot
                                                  .data()['useruid']),
                                          type:
                                              PageTransitionType.bottomToTop));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()['usernimage']),
                                  radius: 25.0,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  // color: constantColors.redColor,
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.yellowColor),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        backgroundImage:
                            NetworkImage(documentSnapshot.data()['userimage']),
                      ),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            documentSnapshot.data()['username'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Provider.of<Authentication>(context, listen: false)
                                    .getUserUid ==
                                documentSnapshot.data()['useruid']
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: MaterialButton(
                                    color: constantColors.redColor,
                                    child: Text(
                                      'Delete room',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              title: Text(
                                                'Delete chatroom',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),
                                              ),
                                              actions: [
                                                MaterialButton(
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: constantColors
                                                              .whiteColor,
                                                          fontSize: 14.0,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              constantColors
                                                                  .whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                MaterialButton(
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: constantColors
                                                              .whiteColor,
                                                          fontSize: 14.0,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              constantColors
                                                                  .whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    color:
                                                        constantColors.redColor,
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'chatrooms')
                                                          .doc(documentSnapshot
                                                              .id)
                                                          .delete()
                                                          .whenComplete(() {
                                                        Navigator.pop(context);
                                                      });
                                                    })
                                              ],
                                            );
                                          });
                                    }),
                              )
                            : Container(
                                height: 0.0,
                                width: 0.0,
                              )
                      ])
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  showCreateChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4.0,
                    ),
                  ),
                  Text(
                    'Select Chatroom Avtar',
                    style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomIcons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  // print(documentSnapshot.data()['image']);
                                  chatRoomAvatarUrl =
                                      documentSnapshot.data()['image'];
                                  print(chatRoomAvatarUrl);
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: chatRoomAvatarUrl ==
                                                    documentSnapshot
                                                        .data()['image']
                                                ? constantColors.blueColor
                                                : constantColors.transperant)),
                                    height: 10.0,
                                    width: 40.0,
                                    child: Image.network(
                                        documentSnapshot.data()['image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatroomNameController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Chatroom ID',
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                          backgroundColor: constantColors.blueGreyColor,
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: constantColors.yellowColor,
                          ),
                          onPressed: () async {
                            Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .submitChatroomData(
                              chatroomNameController.text,
                              {
                                'roomavatar': getChatroomAvatarUrl,
                                'time': Timestamp.now(),
                                'roomname': chatroomNameController.text,
                                'username': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getInitUserName,
                                'useremail': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getInitUserEmail,
                                'userimage': Provider.of<FirebaseOperation>(
                                        context,
                                        listen: false)
                                    .getInitUserImage,
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                              },
                            ).whenComplete(() {
                              Navigator.pop(context);
                            });
                          })
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
            ),
          );
        });
  }

  showChatRooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset('assets/animations/loading.json'),
              ),
            );
          } else {
            return new ListView(
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: GroupMessage(
                                documentSnapshot: documentSnapshot),
                            type: PageTransitionType.leftToRight));
                  },
                  onLongPress: () {
                    showChatroomDetail(context, documentSnapshot);
                  },

                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      width: 100.0,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(documentSnapshot.id)
                            .collection('messages')
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          showlastMessageTime(
                              snapshot.data.docs.first.data()['time']);
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Text(
                              getlatestMessageTime,
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  // showing chatroom name
                  title: Text(
                    documentSnapshot.data()['roomname'],
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Showing the last messages in the fornt of the chat
                  subtitle: StreamBuilder<QuerySnapshot>(
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
                      } else if (snapshot.data.docs.first.data()['username'] !=
                              null &&
                          snapshot.data.docs.first.data()['message'] != null) {
                        return Text(
                          '${snapshot.data.docs.first.data()['username']} : ${snapshot.data.docs.first.data()['message']}',
                          style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.data.docs.first.data()['username'] !=
                              null &&
                          snapshot.data.docs.first.data()['sticker'] != null) {
                        return Text(
                          '${snapshot.data.docs.first.data()['username']} : Sticker',
                          style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      }
                    },
                  ),
                  leading: CircleAvatar(
                    backgroundColor: constantColors.transperant,
                    backgroundImage:
                        NetworkImage(documentSnapshot.data()['roomavatar']),
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  showlastMessageTime(dynamic timedata) {
    Timestamp t = timedata;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    notifyListeners();
  }
}
