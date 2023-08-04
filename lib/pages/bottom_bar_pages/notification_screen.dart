import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/globals.dart';
import '../../utils/app_text.dart';
import '../../utils/constant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(Global.id.toString())
        .collection("alerts")
        .doc("alert")
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.data()!["seen"] == "no") {
          FirebaseFirestore.instance
              .collection("users")
              .doc(Global.id.toString())
              .collection("alerts")
              .doc("alert")
              .update({"seen": "yes"});
        } else {
          print("seen it is");
        }
      }
    });
  }

  @override
  void dispose() {
    // Perform batch update only when the screen is disposed
    commitBatchUpdate();

    super.dispose();
  }

  void commitBatchUpdate() {
    CollectionReference notificationsRef = FirebaseFirestore.instance
        .collection("users")
        .doc(Global.id.toString())
        .collection("notifications");

    notificationsRef
        .where("seen", isEqualTo: "no")
        .get()
        .then((QuerySnapshot snapshot) {
      WriteBatch? batch; // Update variable type to WriteBatch?
      log(snapshot.docs.length.toString());

      snapshot.docs.forEach((DocumentSnapshot document) {
        batch ??=
            FirebaseFirestore.instance.batch(); // Initialize batch if null
        batch!.update(document.reference, {"seen": "yes"});
        // Add more update operations as needed
      });

      if (batch != null) {
        // Check if batch is not null before committing
        batch!.commit().then((_) {
          print("Batch update successful");
        }).catchError((error) {
          print("Error performing batch update: $error");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          width: width(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              addVerticalSpace(60),
              Container(
                child: AppText(
                  text: "Notifications",
                  color: black,
                  fontWeight: FontWeight.bold,
                  size: 22,
                ),
              ),
              addVerticalSpace(20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(Global.id.toString())
                      .collection("notifications")
                      .orderBy("timeStamp", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      return Column(
                        children: List.generate(documents.length, (index) {
                          return Column(
                            children: [
                              InkWell(
                                onLongPress: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                        text: documents[index]["msg"]),
                                  );
                                  Fluttertoast.showToast(
                                    msg: "Message Copied",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                },
                                child: ListTile(
                                  title: Text(
                                    documents[index]["name"]!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    documents[index]["msg"]!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        documents[index]["date"],
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w800,
                                          color: black,
                                        ),
                                      ),
                                      Text(
                                        documents[index]["time"],
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w800,
                                          color: black,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            documents[index]["seen"] == "no",
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: btnColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    maxRadius: width(context) * 0.065,
                                    backgroundColor: Color(0xFFB4DBFF),
                                    // backgroundColor: Colors.transparent,
                                    child: Center(
                                      child: Icon(
                                        Icons.notification_important,
                                        size: width(context) * 0.11,
                                        color: Color(0xFFEAF2FF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: index != documents.length - 1,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Divider(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
