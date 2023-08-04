// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:amacle_studio_app/main.dart';
import 'package:amacle_studio_app/pages/agreement_check_page.dart';
import 'package:amacle_studio_app/pages/show_request_screen.dart';
import 'package:amacle_studio_app/pages/video_player.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../global/globals.dart';
import '../utils/app_text.dart';
import '../utils/styles.dart';
import 'add_developer.dart';
import 'group_chat_screen.dart';
import 'update_project_status.dart';

class ProjectSettings extends StatefulWidget {
  const ProjectSettings({Key? key, required this.projectDoc}) : super(key: key);

  final DocumentSnapshot projectDoc;

  @override
  _ProjectSettingsState createState() => _ProjectSettingsState();
}

class _ProjectSettingsState extends State<ProjectSettings> {
  bool showDevelopers = false;
  bool changeDelay = false;
  bool changeBonus = false;
  bool changePrice = false;
  TextEditingController delay = TextEditingController();
  TextEditingController bonus = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController rating = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  addDelay(DocumentSnapshot doc) {
    firestore
        .collection("projects")
        .doc(widget.projectDoc["id"].toString())
        .update({"delay": int.parse(delay.text.trim())}).then((value) {
      Fluttertoast.showToast(
        msg: "Delay modified",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      setState(() {});
    }).catchError((e) {
      delay.text = doc["delay"].toString();
      Fluttertoast.showToast(
        msg: "Invalid value for delay",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    });
  }

  addBonus(DocumentSnapshot doc, bool changeSign) {
    firestore
        .collection("projects")
        .doc(widget.projectDoc["id"].toString())
        .update({
      "bonus": int.parse(bonus.text.trim()) * (changeSign ? -1 : 1),
    }).then((value) {
      Fluttertoast.showToast(
        msg: "Worth modified",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }).catchError((e) {
      delay.text = doc["delay"].toString();
      Fluttertoast.showToast(
        msg: "Invalid value for delay",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    });
  }

  addPrice(DocumentSnapshot doc) {
    firestore
        .collection("projects")
        .doc(widget.projectDoc["id"].toString())
        .update({
      "price": int.parse(price.text.trim()),
    }).then((value) {
      Fluttertoast.showToast(
        msg: "Worth modified",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }).catchError((e) {
      delay.text = doc["delay"].toString();
      Fluttertoast.showToast(
        msg: "Invalid value for delay",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    });
  }

  removeDeveloper(DocumentSnapshot doc, List list) {
    firestore
        .collection("projects")
        .doc(widget.projectDoc["id"].toString())
        .update({"developer_id": list}).then((value) {
      Fluttertoast.showToast(
        msg: "Developer Removed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      setState(() {});
    }).catchError((e) {
      delay.text = doc["delay"].toString();
      Fluttertoast.showToast(
        msg: "Could not remove developer",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    });
  }

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

  Future<bool?> ratingDialog(BuildContext context, String msg) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg),
              TextField(
                controller: rating,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter your rating'),
              ),
            ],
          ),
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

  @override
  initState() {
    delay.text = widget.projectDoc["delay"].toString();
    bonus.text = widget.projectDoc["bonus"].toString();
    price.text = widget.projectDoc["price"].toString();
    super.initState();
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("projects")
            .where("id", isEqualTo: widget.projectDoc["id"])
            .snapshots(),
        builder: (context, snaps) {
          if (snaps.hasData) {
            DocumentSnapshot projectDoc = snaps.data!.docs[0];
            List dev = projectDoc["developer_id"];
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            text: "Settings",
                            color: black,
                            size: width(context) * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                          IconButton(
                            onPressed: () {
                              // nextScreen(
                              //     context,
                              //     VideoPlayerScreen(
                              //         videoUrl:
                              //             "https://firebasestorage.googleapis.com/v0/b/amacle-manager-developer-app.appspot.com/o/chatvideos%2F8003d1c0-15b2-11ee-af74-eb260c819955.mp4?alt=media&token=76a44178-2496-4e3a-af2b-2b3d1946a5d6",
                              //         height: height(context)));
                              nextScreen(
                                  context, GroupChatScreen(doc: projectDoc));
                            },
                            icon: Icon(
                              Icons.chat,
                              color: black,
                              size: width(context) * 0.08,
                            ),
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
                              child: Center(
                                child: Image.asset(
                                  "assets/Person.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            title: AppText(
                              text: "Manage Developers",
                              color: black,
                              size: width(context) * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  showDevelopers = !showDevelopers;
                                });
                              },
                              icon: Icon(
                                showDevelopers
                                    ? Icons.keyboard_arrow_right_outlined
                                    : Icons.keyboard_arrow_down_outlined,
                                color: black,
                                size: width(context) * 0.065,
                              ),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .where("id", whereIn: projectDoc["developer_id"])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<DocumentSnapshot> developers =
                                  snapshot.data!.docs;
                              return Visibility(
                                visible: showDevelopers,
                                child: Column(
                                  children: [
                                    addVerticalSpace(10),
                                    Column(
                                      children: List.generate(
                                        developers.length,
                                        (index) {
                                          return Container(
                                            width: width(context) * 0.9,
                                            height: 60,
                                            color: white,
                                            child: ListTile(
                                              leading: GestureDetector(
                                                onTap: () {
                                                  nextScreen(
                                                      context,
                                                      DeveloperDetail(
                                                        projectDoc: projectDoc,
                                                        doc: developers[index],
                                                        selected: true,
                                                      ));
                                                },
                                                child: CircleAvatar(
                                                  maxRadius:
                                                      width(context) * 0.045,
                                                  backgroundColor:
                                                      Color(0xFFB4DBFF),
                                                  // backgroundColor: Colors.transparent,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: SizedBox(
                                                      width:
                                                          width(context) * 0.63,
                                                      height:
                                                          width(context) * 0.63,
                                                      child: imageNetwork(
                                                        developers[index]
                                                            ["pic"],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: AppText(
                                                text: developers[index]["name"],
                                                color: black,
                                                size: width(context) * 0.04,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      bool confirm =
                                                          await ratingDialog(
                                                                  context,
                                                                  'Rate the developer') ??
                                                              false;
                                                      if (confirm == true) {
                                                        log(rating.text);
                                                        print(int.parse(
                                                            rating.text));
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("users")
                                                            .doc(developers[
                                                                    index]["id"]
                                                                .toString())
                                                            .update({
                                                          "badge_score": developers[
                                                                              index]
                                                                          [
                                                                          "badge_score"] +
                                                                      int.parse(
                                                                          rating
                                                                              .text) <=
                                                                  100
                                                              ? developers[
                                                                          index]
                                                                      [
                                                                      "badge_score"] +
                                                                  int.parse(
                                                                      rating
                                                                          .text)
                                                              : 100
                                                        });
                                                        //   setState(() {

                                                        //   });
                                                      }
                                                    },
                                                    icon: Icon(Icons.score),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      DocumentReference
                                                          mydocforProject =
                                                          firestore
                                                              .collection(
                                                                  "projects")
                                                              .doc(widget
                                                                  .projectDoc[
                                                                      "id"]
                                                                  .toString());
                                                      if (projectDoc["blocked"]
                                                          .contains(
                                                              developers[index]
                                                                  ["id"])) {
                                                        mydocforProject.update({
                                                          "blocked": projectDoc[
                                                              "blocked"]
                                                            ..remove(developers[
                                                                index]["id"])
                                                        }).then((value) {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "Developer unblocked from chat",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                        });
                                                      } else {
                                                        mydocforProject.update({
                                                          "blocked": projectDoc[
                                                              "blocked"]
                                                            ..add(developers[
                                                                index]["id"])
                                                        }).then((value) {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "Developer blocked from chat",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.block,
                                                      color: projectDoc[
                                                                  "blocked"]
                                                              .contains(
                                                                  developers[
                                                                          index]
                                                                      ["id"])
                                                          ? black26
                                                          : Colors.black,
                                                      size: width(context) *
                                                          0.065,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () async {
                                                      bool confirm =
                                                          await showConfirmationDialog(
                                                                  context,
                                                                  'Are you sure you want to remove this developer?') ??
                                                              false;
                                                      if (confirm == true) {
                                                        setState(() {
                                                          removeDeveloper(
                                                              projectDoc,
                                                              dev
                                                                ..remove(
                                                                    developers[
                                                                            index]
                                                                        [
                                                                        "id"]));
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .remove_circle_outline,
                                                      color: Colors.red,
                                                      size: width(context) *
                                                          0.065,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return nullWidget();
                            }
                          }),
                      addVerticalSpace(10),
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
                              child: Center(
                                child: Icon(Icons.question_mark_rounded),
                              ),
                            ),
                            title: AppText(
                              text: "Developer Requests",
                              color: black,
                              size: width(context) * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                nextScreen(context,
                                    ShowRequestScreen(id: projectDoc["id"]));
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
                      addVerticalSpace(10),
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
                              child: Center(
                                child: Icon(Icons.edit_document),
                              ),
                            ),
                            title: AppText(
                              text: "Verify Agreements",
                              color: black,
                              size: width(context) * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                nextScreen(context,
                                    AgreementCheckPage(doc: projectDoc));
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
                      addVerticalSpace(10),
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
                              child: Center(
                                child: Image.asset(
                                  "assets/Coming Soon.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            title: AppText(
                              text: "Add delay",
                              color: black,
                              size: width(context) * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      changeDelay = !changeDelay;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: width(context) * 0.17,
                                    decoration: BoxDecoration(
                                      color: grey.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: changeDelay
                                          ? TextField(
                                              controller: delay,
                                              textAlign: TextAlign.center,
                                              onSubmitted: (value) {
                                                setState(() {
                                                  addDelay(projectDoc);
                                                  changeDelay = !changeDelay;
                                                });
                                              },
                                              cursorColor: black,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 15.0),
                                                border: InputBorder.none,
                                                counterText: "",
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 2,
                                              style: TextStyle(
                                                color: black,
                                                fontSize:
                                                    width(context) * 0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : AppText(
                                              text: projectDoc["delay"]
                                                  .toString(),
                                              color: black,
                                              size: width(context) * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      addVerticalSpace(10),
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
                              child: Center(
                                child: Image.asset(
                                  "assets/Add Dollar.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            title: AppText(
                              text: "Bonus",
                              color: black,
                              size: width(context) * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    addBonus(projectDoc, true);
                                  },
                                  icon: Icon(
                                    projectDoc["bonus"] >= 0
                                        ? Icons.add
                                        : Icons.remove,
                                    color: projectDoc["bonus"] >= 0
                                        ? Color.fromARGB(255, 120, 227, 124)
                                        : Colors.red,
                                    size: width(context) * 0.065,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          changeBonus = !changeBonus;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: width(context) * 0.25,
                                        decoration: BoxDecoration(
                                          color: grey.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: changeBonus
                                              ? TextField(
                                                  controller: bonus,
                                                  textAlign: TextAlign.center,
                                                  onSubmitted: (value) {
                                                    setState(() {
                                                      addBonus(
                                                          projectDoc, false);
                                                      changeBonus =
                                                          !changeBonus;
                                                    });
                                                  },
                                                  cursorColor: black,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15.0),
                                                    border: InputBorder.none,
                                                    counterText: "",
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 5,
                                                  style: TextStyle(
                                                    color: black,
                                                    fontSize:
                                                        width(context) * 0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : AppText(
                                                  text: projectDoc["bonus"]
                                                      .toString(),
                                                  color: black,
                                                  size: width(context) * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      addVerticalSpace(10),
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
                              child: Center(
                                // child: Image.asset(
                                //   "assets/Cash.png",
                                //   fit: BoxFit.contain,
                                // ),
                                child: Icon(
                                  FontAwesome5.rupee_sign,
                                  size: 17,
                                  color: Color.fromARGB(255, 16, 148, 20),
                                ),
                              ),
                            ),
                            title: AppText(
                              text: "Worth",
                              color: black,
                              size: width(context) * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          changePrice = !changePrice;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: width(context) * 0.25,
                                        decoration: BoxDecoration(
                                          color: grey.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: changePrice
                                              ? TextField(
                                                  controller: price,
                                                  textAlign: TextAlign.center,
                                                  onSubmitted: (value) {
                                                    setState(() {
                                                      addPrice(projectDoc);
                                                      changePrice =
                                                          !changePrice;
                                                    });
                                                  },
                                                  cursorColor: black,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15.0),
                                                    border: InputBorder.none,
                                                    counterText: "",
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 5,
                                                  style: TextStyle(
                                                    color: black,
                                                    fontSize:
                                                        width(context) * 0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : AppText(
                                                  text: projectDoc["price"]
                                                      .toString(),
                                                  color: black,
                                                  size: width(context) * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      addVerticalSpace(10),
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
                              child: Center(
                                child: Icon(Icons.upload),
                              ),
                            ),
                            title: AppText(
                              text: projectDoc["status"] == "active"
                                  ? "Push to maintainence"
                                  : projectDoc["status"] == "maintain"
                                      ? "Mark as finshed"
                                      : "Mark as finshed",
                              color: black,
                              size: width(context) * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                nextScreen(
                                    context,
                                    UpdateProjectStatus(
                                        projectDoc: projectDoc));
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
                      addVerticalSpace(10),
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
                              child: Center(
                                child: Icon(Icons.add_circle_outline_outlined),
                              ),
                            ),
                            title: AppText(
                              text: "Add a developer",
                              color: black,
                              size: width(context) * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                nextScreen(context,
                                    AddDeveloperScreen(projectDoc: projectDoc));
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
          } else {
            return nullWidget();
          }
        });
  }
}

class DelayProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void incrementCount() {
    _count++;
    notifyListeners();
  }
}
