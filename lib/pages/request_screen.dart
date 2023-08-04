// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../global/globals.dart';
import '../utils/app_text.dart';
import '../utils/constant.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key, required this.doc}) : super(key: key);
  final DocumentSnapshot doc;

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = math.Random();
  final results = StringBuffer();

  generate() {
    for (int i = 0; i < 15; i++) {
      results.write(chars[random.nextInt(chars.length)]);
    }
  }

  request(String msg) async {
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    String result = results.toString();
    print(result);
    results.clear();
    generate();
    await Future.delayed(Duration(milliseconds: 400), () async {
      FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.doc["id"].toString())
          .collection("requests")
          .doc(result.toString())
          .set({
        "by_id": Global.mainMap[0]["id"],
        "last_time": FieldValue.serverTimestamp(),
        "date": formattedDate,
        "time": formattedTime,
        "doc_id": result.toString(),
        "msg": " Developer ${Global.mainMap[0]["name"]} has $msg",
      }).then((value) {
        Fluttertoast.showToast(
          msg: "Request Sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        color: Color.fromARGB(255, 243, 242, 240),
        width: width(context),
        height: height(context),
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              addVerticalSpace(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      goBack(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: black,
                      size: width(context) * 0.065,
                    ),
                  ),
                  AppText(
                    text: "  Request Management System",
                    color: black,
                    size: width(context) * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              addVerticalSpace(20),
              Center(
                child: Container(
                  width: width(context) * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    tileColor: white,
                    leading: SizedBox(
                      height: 40,
                      width: width(context) * 0.1,
                      child: Icon(
                        Icons.block,
                        color: black,
                      ),
                    ),
                    title: AppText(
                      text: "Request to unblock",
                      color: black,
                      size: width(context) * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        request("requested to unblock from chat.");
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: black,
                        size: width(context) * 0.065,
                      ),
                    ),
                  ),
                ),
              ),
              addVerticalSpace(20),
              Center(
                child: Container(
                  width: width(context) * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    tileColor: white,
                    leading: SizedBox(
                      height: 40,
                      width: width(context) * 0.1,
                      child: Icon(
                        Icons.call,
                        color: black,
                      ),
                    ),
                    title: AppText(
                      text: "Request a call",
                      color: black,
                      size: width(context) * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        request("requested for a call.");
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: black,
                        size: width(context) * 0.065,
                      ),
                    ),
                  ),
                ),
              ),
              addVerticalSpace(20),
              Center(
                child: Container(
                  width: width(context) * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    tileColor: white,
                    leading: SizedBox(
                      height: 40,
                      width: width(context) * 0.1,
                      child: Icon(
                        Icons.videocam,
                        color: black,
                      ),
                    ),
                    title: AppText(
                      text: "Request a meet",
                      color: black,
                      size: width(context) * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        request("requested for a google meet.");
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: black,
                        size: width(context) * 0.065,
                      ),
                    ),
                  ),
                ),
              ),
              addVerticalSpace(20),
              Center(
                child: Container(
                  width: width(context) * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    tileColor: white,
                    leading: SizedBox(
                      height: 40,
                      width: width(context) * 0.1,
                      child: Icon(
                        Icons.add,
                        color: black,
                      ),
                    ),
                    title: AppText(
                      text: "Request to add",
                      color: black,
                      size: width(context) * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        request("requested to add delay to the project.");
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: black,
                        size: width(context) * 0.065,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
