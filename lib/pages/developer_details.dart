// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:amacle_studio_app/pages/profile.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/expandable_text.dart';
import 'package:amacle_studio_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/globals.dart';
import '../utils/widgets.dart';

class DeveloperDetail extends StatefulWidget {
  const DeveloperDetail({
    super.key,
    required this.doc,
    required this.added,
    required this.listOfAdded,
    required this.projectId,
  });

  final DocumentSnapshot doc;
  final bool added;
  final List listOfAdded;
  final int projectId;

  @override
  State<DeveloperDetail> createState() => _DeveloperDetailState();
}

class _DeveloperDetailState extends State<DeveloperDetail> {
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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    print(widget.doc.data().toString());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
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
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 20,
              right: width(context) * 0.05,
              left: width(context) * 0.1,
              child: Container(
                width: width(context),
                child: SizedBox(
                  width: width(context) * 0.4,
                  height: width(context) * 0.15,
                  child: FloatingActionButton.extended(
                    backgroundColor:
                        widget.listOfAdded.contains(widget.doc["id"])
                            ? grey
                            : btnColor,
                    onPressed: () {
                      // if(widget.doc["added"])
                      if (!widget.listOfAdded.contains(widget.doc["id"])) {
                        widget.listOfAdded.add(widget.doc["id"]);
                        setState(() {
                          isLoading = true;
                        });
                        FirebaseFirestore.instance
                            .collection("new_projects")
                            .doc(widget.projectId.toString())
                            .update({
                          "added": widget.listOfAdded,
                        }).then((value) {
                          Fluttertoast.showToast(
                            msg: "Developer Added",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          print('Data updated successfully');
                          goBack(context);
                        }).catchError((error) {
                          Fluttertoast.showToast(
                            msg: "Could not add developer",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                          print('Failed to update data: $error');
                        });
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    label: AppText(
                      text: widget.listOfAdded.contains(widget.doc["id"])
                          ? "Developer added"
                          : "Add Developer",
                      fontWeight: FontWeight.w600,
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
