import 'dart:developer';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../global/globals.dart';
import '../../utils/app_text.dart';
import '../../utils/constant.dart';
import '../../utils/expandable_text.dart';
import '../../utils/widgets.dart';
import '../each_chat.dart';

class ChatProfileDetails extends StatefulWidget {
  ChatProfileDetails({
    Key? key,
    required this.doc,
    required this.view,
    required this.chattingWithUser,
    this.share = true,
  }) : super(key: key);

  final DocumentSnapshot doc;
  final bool view;
  bool share;
  DocumentSnapshot? chattingWithUser;

  @override
  _ChatProfileDetailsState createState() => _ChatProfileDetailsState();
}

class _ChatProfileDetailsState extends State<ChatProfileDetails> {
  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Fluttertoast.showToast(
        msg: "Could not make a call",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  String chatRoomId(int userId1, int userId2) {
    if (userId1 > userId2) {
      return "${userId1}chat${userId2}";
    } else {
      return "${userId2}chat${userId1}";
    }
  }

  bool isLoading = false;

  String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = math.Random();
  final results = StringBuffer();

  generate() {
    for (int i = 0; i < 15; i++) {
      results.write(chars[random.nextInt(chars.length)]);
    }
  }

  updateMyUserList(
    String type,
    String message,
    FieldValue time,
    String fileName,
  ) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    String result = results.toString();
    print(result);
    results.clear();
    generate();

    await Future.delayed(Duration(milliseconds: 400), () async {
      CollectionReference myUsersForSender = FirebaseFirestore.instance
          .collection('users')
          .doc(Global.id.toString())
          .collection("my_chats");

      DocumentReference userDocumentRef =
          myUsersForSender.doc((widget.chattingWithUser!["id"]).toString());

      Map<String, dynamic> userMap = {
        "search_id": widget.chattingWithUser!["id"],
        "last_time": time,
        "date": formattedDate,
        "time": formattedTime,
        "type": type,
        "doc_id": result.toString(),
        "id": widget.doc["id"],
        "fileName": fileName,
        "seen_by_other": "no",
        "message": message,
        "sender_id": Global.id,
        "sendby": Global.mainMap[0]["name"],
        "to_id": widget.chattingWithUser!["id"],
        "status": "sent",
        "seen": "yes",
      };

      batch.set(
          userDocumentRef.collection("chats").doc(result.toString()), userMap);

      DocumentSnapshot userdocSnapshot =
          await myUsersForSender.doc(widget.doc["id"].toString()).get();

      if (!userdocSnapshot.exists) {
        myUsersForSender
            .doc(widget.doc["id"].toString())
            .set({"dummy": "dummy"});
      } else {
        print("exists1");
      }

      CollectionReference myUsersForReceiver = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.chattingWithUser!["id"].toString())
          .collection("my_chats");

      DocumentReference receiverDocumentRef =
          myUsersForReceiver.doc((Global.id).toString());

      Map<String, dynamic> receiverMap = {
        "search_id": Global.id,
        "last_time": time,
        "date": formattedDate,
        "time": formattedTime,
        "type": type,
        "fileName": fileName,
        "seen_by_other": "no",
        "id": widget.doc["id"],
        "doc_id": result.toString(),
        "message": message,
        "sender_id": Global.id,
        "sendby": Global.mainMap[0]["name"],
        "to_id": widget.chattingWithUser!["id"],
        "status": "recieved",
        "seen": "no",
      };

      batch.set(receiverDocumentRef.collection("chats").doc(result.toString()),
          receiverMap);

      DocumentSnapshot otherdocSnapshot = await myUsersForReceiver
          .doc(Global.mainMap[0]["id"].toString())
          .get();

      if (!otherdocSnapshot.exists) {
        myUsersForReceiver
            .doc(Global.mainMap[0]["id"].toString())
            .set({"dummy": "dummy"});
      } else {
        print("exists2");
      }

      return batch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.doc.data().toString());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addVerticalSpace(25),
                SizedBox(
                  // height: width(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            maxRadius: width(context) * 0.065,
                            backgroundColor: Color(0xFFB4DBFF),
                            // backgroundColor: Colors.transparent,
                            child: Container(
                              height: width(context) * 0.3,
                              width: width(context) * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      image: networkImage(widget.doc["pic"]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          addHorizontalySpace(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppText(
                                text: widget.doc["name"],
                                color: black,
                                size: width(context) * 0.05,
                                fontWeight: FontWeight.w800,
                              ),
                              AppText(
                                text: widget.doc["phno"],
                                color: Colors.black38,
                                size: width(context) * 0.035,
                              ),
                            ],
                          )
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: width(context) * 0.28,
                          height: height(context) * 0.065,
                          child: TextButton(
                            onPressed: () {
                              _launchPhone(widget.doc["phno"]);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(btnColor)),
                            child: Center(
                                child: Row(
                              children: [
                                addHorizontalySpace(10),
                                Icon(
                                  Icons.call,
                                  color: white,
                                ),
                                addHorizontalySpace(5),
                                AppText(
                                  text: "Call",
                                  size: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                addHorizontalySpace(10),
                              ],
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                addVerticalSpace(15),
                Visibility(
                  visible: !widget.view && widget.share,
                  child: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      updateMyUserList("contact", "",
                          FieldValue.serverTimestamp(), widget.doc["name"]);
                    },
                  ),
                ),
                Visibility(
                  visible: widget.doc["role"] == 'developer',
                  child: Row(
                    children: [
                      Visibility(
                        visible: widget.doc["role"] == 'developer',
                        child: SizedBox(
                          width: 40,
                          height: 50,
                          child: Image.asset(
                            widget.doc["badge_score"] <= 50
                                ? "assets/badge_bronze.png"
                                : widget.doc["badge_score"] <= 70
                                    ? "assets/badge_silver.png"
                                    : "assets/badge_gold.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      addHorizontalySpace(20),
                      AppText(
                        text: "Level: ${widget.doc["level"]}",
                        color: black,
                        size: 17,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                ),
                AppText(
                  text: "Bio",
                  color: Colors.black45,
                  size: 17,
                  fontWeight: FontWeight.w700,
                ),
                ExpandableText(
                  text: widget.doc["bio"],
                  textHeight: 300,
                  color: Colors.black54,
                  size: 16,
                ),
                addVerticalSpace(20),
                Row(
                  children: [
                    AppText(
                      text: "Links",
                      color: Colors.black87,
                      size: 19,
                    ),
                    addHorizontalySpace(6),
                    Icon(
                      Icons.link,
                      size: 26,
                    ),
                  ],
                ),
                addVerticalSpace(20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(
                        Typicons.github,
                        size: 28,
                      ),
                      addHorizontalySpace(5),
                      InkWell(
                        onLongPress: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.doc["github"]),
                          );
                          Fluttertoast.showToast(
                            msg: "Message Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                        },
                        child: AppText(
                          text: widget.doc["github"],
                          color: themeColor,
                          size: 14.5,
                        ),
                      ),
                      addHorizontalySpace(6),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(
                        Typicons.mail,
                        size: 26,
                      ),
                      addHorizontalySpace(5),
                      InkWell(
                        onLongPress: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.doc["email"]),
                          );
                          Fluttertoast.showToast(
                            msg: "Email Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                        },
                        child: AppText(
                          text: widget.doc["email"],
                          color: themeColor,
                          size: 14.5,
                        ),
                      ),
                      addHorizontalySpace(6),
                    ],
                  ),
                ),
                addVerticalSpace(20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(
                        Typicons.linkedin,
                        size: 26,
                      ),
                      addHorizontalySpace(5),
                      InkWell(
                        onLongPress: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.doc["linkedin"]),
                          );
                          Fluttertoast.showToast(
                            msg: "Link Copied",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                        },
                        child: AppText(
                          text: widget.doc["linkedin"],
                          color: themeColor,
                          size: 14.5,
                        ),
                      ),
                      addHorizontalySpace(6),
                    ],
                  ),
                ),
                addVerticalSpace(height(context) * 0.2),
                Visibility(
                  visible: !widget.view,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                          width: width(context) * 0.9,
                          height: width(context) * 0.2,
                          child: TextButton(
                              onPressed: () {
                                String roomId =
                                    chatRoomId(Global.id, widget.doc["id"]);
                                print(roomId);
                                nextScreen(
                                    context,
                                    ChatPage(
                                      chatRoomId: roomId,
                                      doc: widget.doc,
                                    ));
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(btnColor)),
                              child: AppText(
                                text: "Start Chat",
                                fontWeight: FontWeight.bold,
                                size: 18,
                              ))),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
