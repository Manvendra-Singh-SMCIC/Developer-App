// ignore_for_file: prefer__ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:amacle_studio_app/authentication/auth_controller.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/notification_screen.dart';
import 'package:amacle_studio_app/pages/contact_info.dart';
import 'package:amacle_studio_app/pages/project_detail_screen.dart';
import 'package:amacle_studio_app/pages/project_details_manager_screen.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/styles.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../global/globals.dart';
import '../../utils/constant.dart';
import '../profile.dart';
import '../../comps/widgets.dart';
import '../user_profile.dart';

class ManagerHomePageScreen extends StatefulWidget {
  ManagerHomePageScreen({Key? key}) : super(key: key);

  @override
  _ManagerHomePageScreenState createState() => _ManagerHomePageScreenState();
}

class _ManagerHomePageScreenState extends State<ManagerHomePageScreen>
    with SingleTickerProviderStateMixin {
  late bool isShowingMainData;

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isShowingMainData = true;
  }

  List graphData = [0, 0, 0, 0, 0, 0, 0];

  Column inProgressAndFinished(List<DocumentSnapshot> docs, bool finished) {
    int percent = 100;

    return Column(
      children: List.generate(
        docs.length,
        (index) {
          return Builder(builder: (context) {
            return Visibility(
              visible: finished
                  ? docs[index]["status"] == "finished"
                  : docs[index]["status"] == "active",
              child: Column(
                children: [
                  addVerticalSpace(height(context) * 0.01),
                  Container(
                    width: 0.9 * width(context),
                    // height: 0.11 * height(context),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 4, 1, 3),
                    child: InkWell(
                      onTap: () {
                        if (!finished) {
                          nextScreen(
                            context,
                            ProjectDetailScreenForManager(
                              repoOwner: docs[index]["repo_owner"],
                              repoName: docs[index]["repo_name"],
                              token: docs[index]["token"],
                              projectId: docs[index]["id"],
                              docs: docs[index],
                            ),
                          );
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width(context) * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                addVerticalSpace(height(context) * 0.01),
                                Container(
                                  height: width(context) * 0.17,
                                  width: width(context) * 0.17,
                                  // maxRadius: width(context) * 0.1,
                                  // backgroundColor: themeColor.withOpacity(0.12),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        width(context) * 0.1),
                                    child: imageNetwork(
                                      docs[index]["image"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            width: 1.5,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              width(context) * 0.02,
                              width(context) * 0.05,
                              width(context) * 0.01,
                              width(context) * 0.02,
                            ),
                            width: width(context) * 0.62,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                addHorizontalySpace(width(context) * 0.025),
                                AppText(
                                  text: docs[index]["name"],
                                  color: black,
                                  size: width(context) * 0.047,
                                  fontWeight: FontWeight.bold,
                                ),
                                addVerticalSpace(height(context) * 0.01),
                                AppText(
                                  text: docs[index]["status"] == "finished"
                                      ? "100%"
                                      : "${docs[index]["progress"]}%",
                                  size: width(context) * 0.037,
                                  color: percent == 100
                                      ? Colors.blue
                                      : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.005),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Column maintainence(List<DocumentSnapshot> docs) {
    int percent = 100;

    return Column(
      children: List.generate(
        docs.length,
        (index) {
          return Builder(builder: (context) {
            return Visibility(
              visible: docs[index]["status"] == "maintain",
              child: Column(
                children: [
                  addVerticalSpace(height(context) * 0.01),
                  Container(
                    width: 0.9 * width(context),
                    // height: 0.11 * height(context),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 4, 1, 3),
                    child: InkWell(
                      onTap: () {
                        nextScreen(
                          context,
                          ProjectDetailScreenForManager(
                            repoOwner: docs[index]["repo_owner"],
                            repoName: docs[index]["repo_name"],
                            token: docs[index]["token"],
                            projectId: docs[index]["id"],
                            docs: docs[index],
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width(context) * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                addVerticalSpace(height(context) * 0.01),
                                Container(
                                  height: width(context) * 0.17,
                                  width: width(context) * 0.17,
                                  // maxRadius: width(context) * 0.1,
                                  // backgroundColor: themeColor.withOpacity(0.12),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        width(context) * 0.1),
                                    child: imageNetwork(
                                      docs[index]["image"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            width: 1.5,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              width(context) * 0.02,
                              width(context) * 0.05,
                              width(context) * 0.01,
                              width(context) * 0.02,
                            ),
                            width: width(context) * 0.62,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                addHorizontalySpace(width(context) * 0.025),
                                AppText(
                                  text: docs[index]["name"],
                                  color: black,
                                  size: width(context) * 0.047,
                                  fontWeight: FontWeight.bold,
                                ),
                                addVerticalSpace(height(context) * 0.01),
                                AppText(
                                  // text: "${docs[index]["progress"]}%",
                                  text: "100%",
                                  size: width(context) * 0.037,
                                  color: percent == 100
                                      ? Colors.blue
                                      : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.005),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  // updateGraphData() async {
  //   DateTime currentDate = DateTime.now();

  //   for (int i = 6; i >= 0; i--) {
  //     DateTime currentDateMinusDays = currentDate.subtract(Duration(days: i));
  //     String formattedDate =
  //         DateFormat('ddMMyyyy').format(currentDateMinusDays);
  //     Global.graphX[6 - i] = formattedDate.substring(0, 2);
  //     final userRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(Global.id.toString());
  //     final attendanceRef = userRef.collection('attendence').doc(formattedDate);
  //     attendanceRef.get().then((documentSnapshot) {
  //       if (documentSnapshot.exists) {
  //         Global.graphData[6 - i] = documentSnapshot.get('done');
  //         // Global.graphData[i] = documentSnapshot.get('done');
  //       } else {
  //         Global.graphData[6 - i] = 0;
  //       }
  //     });
  //     Future.delayed(Duration(seconds: 6), () {
  //       // print("Hey" + graphData.toString());
  //       print("Hey" + Global.graphData.toString());
  //       print("Hey" + Global.graphX.toString());
  //       return graphData;
  //     });
  //   }
  // }

  Widget bell(bool alert) {
    return GestureDetector(
      onTap: () {
        nextScreen(context, NotificationScreen());
      },
      child: Stack(
        children: [
          IconButton(
            onPressed: () {
              nextScreen(context, NotificationScreen());
              // AuthController.instance.logout();
            },
            icon: Icon(
              CupertinoIcons.bell_fill,
              weight: 0.2,
              size: width(context) * 0.075,
              color: white,
            ),
          ),
          Visibility(
            visible: alert,
            child: Positioned(
              top: 8,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool alert = false;
    return StreamBuilder<QuerySnapshot>(
        // stream: FirebaseFirestore.instance
        //     .collection("users")
        //     .doc(Global.id.toString())
        //     .collection("attendence")
        //     .snapshots(),
        builder: (context, snapshot) {
      return FutureBuilder(
          // future: updateGraphData(),
          builder: (context, snapgraph) {
        if (snapgraph.hasData) {
          // print("YO" + Global.graphData.toString());
          // print("HI" + snapgraph.data.toString());
        }
        return Scaffold(
            // drawer: ChatWidgets.drawer(context),
            backgroundColor: Color(0xFFF3F4F7),
            body: Container(
              width: width(context),
              height: height(context),
              child: SingleChildScrollView(
                child: Container(
                  width: width(context),
                  height: height(context),
                  child: Column(
                    children: [
                      Container(
                        height: 0.12 * height(context),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      color: themeColor,
                                      width: width(context),
                                      height: height(context) * 0.120,
                                    ),
                                    Positioned(
                                      top: 0.06 * width(context),
                                      left: 0.06 * width(context),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              nextScreen(
                                                  context, UserProfile());
                                              // nextScreen(
                                              //     context, ContactInfo());
                                              // AuthController.instance
                                              //     .logout();
                                            },
                                            child: CircleAvatar(
                                              maxRadius: width(context) * 0.065,
                                              backgroundColor:
                                                  Color(0xFFB4DBFF),
                                              // backgroundColor: Colors.transparent,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                child: SizedBox(
                                                  width: width(context) * 0.63,
                                                  height: width(context) * 0.63,
                                                  child: imageNetwork(
                                                    Global.mainMap[0]["pic"],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          addHorizontalySpace(10),
                                          GestureDetector(
                                            onTap: () {
                                              // nextScreen(context,
                                              //     NotificationScreen());
                                            },
                                            child: AppText(
                                              text:
                                                  "Hi ${Global.mainMap[0].data()["name"]}",
                                              size: width(context) * 0.045,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0.06 * width(context),
                                      right: 0.06 * width(context),
                                      child: CircleAvatar(
                                        maxRadius: width(context) * 0.0667,
                                        backgroundColor: white,
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              // nextScreen(context,
                                              //     NotificationScreen());
                                            },
                                            child: CircleAvatar(
                                              maxRadius: width(context) * 0.065,
                                              backgroundColor: themeColor,
                                              child: Center(
                                                child: StreamBuilder<
                                                        QuerySnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .doc(Global.id
                                                            .toString())
                                                        .collection("alerts")
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        List<DocumentSnapshot>
                                                            list =
                                                            snapshot.data!.docs;
                                                        if (list.isNotEmpty) {
                                                          return bell(list[0]
                                                                  ["seen"] ==
                                                              "no");
                                                        } else {
                                                          return bell(false);
                                                        }
                                                      } else {
                                                        return bell(false);
                                                      }
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            addHorizontalySpace(width(context) * 0.34),
                            AppText(
                              text: "Projects",
                              color: black,
                              size: width(context) * 0.046,
                              fontWeight: FontWeight.bold,
                            ),
                            addHorizontalySpace(width(context) * 0.29),
                            // Icon(
                            //   Icons.search,
                            //   size: width(context) * 0.08,
                            //   color: themeColor,
                            // ),
                          ],
                        ),
                      ),
                      addVerticalSpace(height(context) * 0.02),
                      TabBar(
                        labelColor: black,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelColor: Colors.grey.withOpacity(0.7),
                        controller: _tabController,
                        tabs: [
                          Tab(text: "Maintainence"),
                          Tab(text: 'In Progress'),
                          Tab(text: 'Finished'),
                        ],
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: (Global.mainMap[0].data()["role"] ==
                                "developer")
                            ? FirebaseFirestore.instance
                                .collection("projects")
                                .where("developer_id",
                                    arrayContains:
                                        Global.mainMap[0].data()["id"])
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection("projects")
                                .where("manager_id",
                                    isEqualTo: Global.mainMap[0].data()["id"])
                                .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot querySnapshot = snapshot.data!;
                            List<DocumentSnapshot> documents =
                                querySnapshot.docs;
                            // log(documents.length.toString());
                            return Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  maintainence(documents),
                                  inProgressAndFinished(documents, false),
                                  inProgressAndFinished(documents, true),
                                ],
                              ),
                            );
                          } else {
                            return loadingState();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ));
      });
    });
  }
}
