// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../utils/app_text.dart';
import '../utils/constant.dart';
import '../utils/widgets.dart';

class UpdateProjectStatus extends StatefulWidget {
  const UpdateProjectStatus({Key? key, required this.projectDoc})
      : super(key: key);

  final DocumentSnapshot projectDoc;

  @override
  _UpdateProjectStatusState createState() => _UpdateProjectStatusState();
}

class _UpdateProjectStatusState extends State<UpdateProjectStatus> {
  Future<bool?> showConfirmationDialog(BuildContext context, String msg) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true on confirmation
              },
            ),
          ],
        );
      },
    );
  }

  bool check(List<TextEditingController> list) {
    bool result = true;
    for (TextEditingController element in list) {
      result = result && element.text.trim().isNotEmpty;
    }
    return result;
  }

  late List<TextEditingController> controllers;

  @override
  void initState() {
    controllers = List.generate(widget.projectDoc["developer_id"].length,
        (index) => TextEditingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: width(context),
          height: height(context),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AppText(
                  text: "Allot earnings",
                  color: black,
                  size: 22,
                  fontWeight: FontWeight.w600,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      widget.projectDoc["developer_id"].length, (index) {
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("id",
                                isEqualTo: widget.projectDoc["developer_id"]
                                    [index])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            DocumentSnapshot userDoc = snapshot.data!.docs[0];
                            return Column(
                              children: <Widget>[
                                addVerticalSpace(10),
                                ListTile(
                                  leading: CircleAvatar(
                                    maxRadius: width(context) * 0.065,
                                    backgroundColor: Color(0xFFB4DBFF),
                                    // backgroundColor: Colors.transparent,
                                    child: Container(
                                      height: width(context) * 0.3,
                                      width: width(context) * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                          image: networkImage(userDoc["pic"]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: AppText(
                                    text: userDoc["name"],
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: width(context) * 0.2,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: width(context) * 0.75,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: controllers[index],
                                          decoration: InputDecoration(
                                            prefix: Icon(
                                              FontAwesome5.rupee_sign,
                                              size: 17,
                                              color: Color.fromARGB(
                                                  255, 16, 148, 20),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                addVerticalSpace(20),
                              ],
                            );
                          } else {
                            return nullWidget();
                          }
                        });
                  }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 20,
              right: width(context) * 0.05,
              left: width(context) * 0.1,
              child: Center(
                child: Container(
                  width: width(context),
                  child: SizedBox(
                    width: width(context) * 0.4,
                    height: width(context) * 0.15,
                    child: FloatingActionButton.extended(
                      backgroundColor: btnColor,
                      onPressed: () async {
                        print(controllers.length);
                        if (check(controllers)) {
                          bool confirm = await showConfirmationDialog(context,
                                  "Aye you sure you want to ${widget.projectDoc["status"] == "active" ? "push project to maintainance" : "mark the project as finished"}?") ??
                              false;
                          if (confirm) {
                            FirebaseFirestore.instance
                                .collection("projects")
                                .doc(widget.projectDoc["id"].toString())
                                .update({
                              "status": widget.projectDoc["status"] == "active"
                                  ? "maintain"
                                  // ? "active"
                                  : "finished",
                            }).then((value) async {
                              Fluttertoast.showToast(
                                msg: widget.projectDoc["status"] == "active"
                                    ? "Moved to maintainance"
                                    : "Marked as finished",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );

                              int i = 0;
                              for (int id
                                  in widget.projectDoc["developer_id"]) {
                                DocumentSnapshot myDoc = await FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .doc(id.toString())
                                    .get();
                                if (myDoc.exists) {
                                  log("i=" + i.toString());
                                  log("id: " + id.toString());
                                  log((myDoc["earned"] +
                                          int.parse(
                                              controllers[i].text.toString()))
                                      .toString());
                                  log(int.parse(controllers[i].text.toString())
                                      .toString());

                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(id.toString())
                                      .update({
                                    "earned": myDoc["earned"] +
                                        int.parse(
                                            controllers[i].text.toString())
                                  }).then((value) async {
                                    print("Earned");
                                    DocumentSnapshot earning =
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(id.toString())
                                            .collection("earnings")
                                            .doc(DateFormat('MMyyyy')
                                                .format(DateTime.now()))
                                            .get();
                                    int earn = 0;
                                    if (earning.exists) {
                                      earn = earning["value"];
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(id.toString())
                                          .collection("earnings")
                                          .doc(DateFormat('MMyyyy')
                                              .format(DateTime.now()))
                                          .update({
                                        "month": DateFormat('MM')
                                            .format(DateTime.now()),
                                        "year": DateFormat('yyyy')
                                            .format(DateTime.now()),
                                        "value": earning["value"] +
                                            int.parse(
                                                controllers[i].text.toString()),
                                      });
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(id.toString())
                                          .collection("earnings")
                                          .doc(DateFormat('MMyyyy')
                                              .format(DateTime.now()))
                                          .set({
                                        "month": DateFormat('MM')
                                            .format(DateTime.now()),
                                        "year": DateFormat('yyyy')
                                            .format(DateTime.now()),
                                        "value": int.parse(
                                            controllers[i].text.toString()),
                                      });
                                    }
                                  });
                                }

                                i++;
                              }

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (route) => false);
                            }).catchError((onError) {
                              Fluttertoast.showToast(
                                msg: "Some error occured",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            });
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "All text fields are required error occured",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                        }
                      },
                      label: AppText(
                        text: widget.projectDoc["status"] == "active"
                            ? "Push to maintainence"
                            : widget.projectDoc["status"] == "maintain"
                                ? "Mark as finshed"
                                : "Mark as finshed",
                        color: black,
                        size: width(context) * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
