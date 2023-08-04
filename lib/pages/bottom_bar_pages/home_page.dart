// ignore_for_file: prefer__ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:amacle_studio_app/authentication/auth_controller.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/notification_screen.dart';
import 'package:amacle_studio_app/pages/project_detail_screen.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/styles.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../global/globals.dart';
import '../../utils/constant.dart';
import '../profile.dart';
import '../../comps/widgets.dart';
import '../user_profile.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
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

  List graphData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

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
                          if (docs[index]["delay"] < 14) {
                            nextScreen(
                              context,
                              ProjectDetailScreen(
                                repoOwner: docs[index]["repo_owner"],
                                repoName: docs[index]["repo_name"],
                                token: docs[index]["token"],
                                projectId: docs[index]["id"],
                                docs: docs[index],
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Project delayed more than 2 weeks",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                            );
                          }
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
                                    child: Image.network(
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
                            width: width(context) * 0.52,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                addHorizontalySpace(width(context) * 0.025),
                                GestureDetector(
                                  onTap: () {},
                                  child: AppText(
                                    text: docs[index]["name"],
                                    color: black,
                                    size: width(context) * 0.047,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                addVerticalSpace(height(context) * 0.01),
                                AppText(
                                  text: "${docs[index]["progress"]}%",
                                  size: width(context) * 0.037,
                                  color: percent == 100
                                      ? Colors.blue
                                      : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Visibility(
                              visible: (docs[index]["status"] == "active" ||
                                      docs[index]["status"] == "maintain") &&
                                  docs[index]["delay"] >= 7,
                              child: SizedBox(
                                height: width(context) * 0.17,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        docs[index]["delay"] >= 14
                                            ? Icons.error
                                            : Icons.timer,
                                        color: docs[index]["delay"] >= 14
                                            ? Color.fromARGB(255, 246, 225, 39)
                                            : Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
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
                        if (docs[index]["delay"] < 14) {
                          nextScreen(
                            context,
                            ProjectDetailScreen(
                              repoOwner: docs[index]["repo_owner"],
                              repoName: docs[index]["repo_name"],
                              token: docs[index]["token"],
                              projectId: docs[index]["id"],
                              docs: docs[index],
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Project delayed more than 2 weeks",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
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
                                    child: Image.network(
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
                            width: width(context) * 0.52,
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
                          Center(
                            child: Visibility(
                              visible: (docs[index]["status"] == "active" ||
                                      docs[index]["status"] == "maintain") &&
                                  docs[index]["delay"] >= 7,
                              child: SizedBox(
                                height: width(context) * 0.17,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        docs[index]["delay"] >= 14
                                            ? Icons.error
                                            : Icons.timer,
                                        color: docs[index]["delay"] >= 14
                                            ? Color.fromARGB(255, 246, 225, 39)
                                            : Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
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

  updateGraphData() async {
    DateTime currentDate = DateTime.now();

    QuerySnapshot earnings = await FirebaseFirestore.instance
        .collection("users")
        .doc(Global.mainMap[0]["id"].toString())
        .collection("earnings")
        .where("year", isEqualTo: DateFormat('yyyy').format(currentDate))
        .get();

    // log(earnings.docs.length.toString());

    if (earnings.docs.isNotEmpty) {
      log(earnings.docs.length.toString());
      for (DocumentSnapshot earning in earnings.docs) {
        graphData[int.parse(earning["month"]) - 1] =
            (earning["value"] / 1000).toInt();
      }
      print("Hey" + graphData.toString());

      Future.delayed(Duration(seconds: 4), () {
        Global.graphData = graphData;
        return graphData;
      });
    }

    // Future.delayed(Duration(seconds: 6), () {
    // //     // // print("Hey" + graphData.toString());
    // //     // print("Hey" + Global.graphData.toString());
    // //     // print("Hey" + Global.graphX.toString());
    // //     return graphData;
    // //   });

    // for (int i = 6; i >= 0; i--) {
    //   DateTime currentDateMinusDays = currentDate.subtract(Duration(days: i));
    //   String formattedDate =
    //       DateFormat('ddMMyyyy').format(currentDateMinusDays);
    //   Global.graphX[6 - i] = formattedDate.substring(0, 2);
    //   final userRef = FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(Global.id.toString());
    //   final attendanceRef = userRef.collection('attendence').doc(formattedDate);
    //   attendanceRef.get().then((documentSnapshot) {
    //     if (documentSnapshot.exists) {
    //       Global.graphData[6 - i] = documentSnapshot.get('done');
    //       // Global.graphData[i] = documentSnapshot.get('done');
    //     } else {
    //       Global.graphData[6 - i] = 0;
    //     }
    //   });
    //   Future.delayed(Duration(seconds: 6), () {
    //     // // print("Hey" + graphData.toString());
    //     // print("Hey" + Global.graphData.toString());
    //     // print("Hey" + Global.graphX.toString());
    //     return graphData;
    //   });
    // }
  }

  Widget bell(bool alert) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            nextScreen(context, NotificationScreen());
          },
          child: IconButton(
            onPressed: () {
              nextScreen(context, NotificationScreen());
              // Fluttertoast.showToast(
              //   msg: "Opening",
              //   toastLength: Toast.LENGTH_SHORT,
              //   gravity: ToastGravity.BOTTOM,
              //   timeInSecForIosWeb: 1,
              // );
              // AuthController.instance.logout();
            },
            icon: Icon(
              CupertinoIcons.bell_fill,
              weight: 0.2,
              size: width(context) * 0.075,
              color: white,
            ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(Global.id.toString())
            .collection("attendence")
            .snapshots(),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: updateGraphData(),
              builder: (context, snapgraph) {
                if (snapgraph.hasData) {
                  print("YO" + Global.graphData.toString());
                  print("HI" + snapgraph.data.toString());
                }
                // print("YO" + Global.graphData.toString());
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
                              height: 0.53 * height(context),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            color: themeColor,
                                            width: width(context),
                                            height: height(context) * 0.45,
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
                                                    ;
                                                  },
                                                  child: CircleAvatar(
                                                    maxRadius:
                                                        width(context) * 0.065,
                                                    backgroundColor:
                                                        Color(0xFFB4DBFF),
                                                    // backgroundColor: Colors.transparent,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: SizedBox(
                                                        width: width(context) *
                                                            0.63,
                                                        height: width(context) *
                                                            0.63,
                                                        child: Image.network(
                                                          Global.mainMap[0]
                                                              ["pic"],
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
                                                    //     Profile(edit: false));
                                                  },
                                                  child: AppText(
                                                    text:
                                                        "Hi ${Global.mainMap[0].data()["name"]}",
                                                    size:
                                                        width(context) * 0.045,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 0.06 * width(context),
                                            right: 0.06 * width(context),
                                            child: CircleAvatar(
                                              maxRadius:
                                                  width(context) * 0.0667,
                                              backgroundColor: white,
                                              child: Center(
                                                child: CircleAvatar(
                                                  maxRadius:
                                                      width(context) * 0.065,
                                                  backgroundColor: themeColor,
                                                  child: Center(
                                                    child: StreamBuilder<
                                                            QuerySnapshot>(
                                                        stream:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "users")
                                                                .doc(Global.id
                                                                    .toString())
                                                                .collection(
                                                                    "alerts")
                                                                .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            List<DocumentSnapshot>
                                                                list = snapshot
                                                                    .data!.docs;
                                                            if (list
                                                                .isNotEmpty) {
                                                              return bell(list[
                                                                          0][
                                                                      "seen"] ==
                                                                  "no");
                                                            } else {
                                                              return bell(
                                                                  false);
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
                                        ],
                                      ),
                                      addVerticalSpace(20),
                                    ],
                                  ),
                                  Positioned(
                                    top: height(context) * 0.15,
                                    right: 20,
                                    left: 20,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 6, left: 6),
                                      child: ExpenseGraphDesign(
                                          graphdata: graphData),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
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
                            addVerticalSpace(height(context) * 0.01),
                            TabBar(
                              labelColor: black,
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              unselectedLabelColor:
                                  Colors.grey.withOpacity(0.7),
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
                                          isEqualTo:
                                              Global.mainMap[0].data()["id"])
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
                  ),
                );
              });
        });
  }
}

class ExpenseGraphDesign extends StatefulWidget {
  const ExpenseGraphDesign({Key? key, required this.graphdata})
      : super(key: key);

  final List graphdata;

  @override
  State<ExpenseGraphDesign> createState() => _ExpenseGraphDesignState();
}

class _ExpenseGraphDesignState extends State<ExpenseGraphDesign> {
  Color graphColors = Color.fromARGB(255, 56, 108, 249);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: height(context) * 0.36,
        width: width(context) * 0.95,
        decoration: BoxDecoration(
          color: white,
          // boxShadow: [
          //   BoxShadow(
          //     color: black.withOpacity(0.4),
          //     blurRadius: 3,
          //     spreadRadius: 3,
          //     offset: Offset(1, 2),
          //   ),
          // ],
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 4.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(1),
              AppText(
                text: "This year's earning",
                fontWeight: FontWeight.bold,
                size: width(context) * 0.06,
                color: black,
              ),
              addVerticalSpace(height(context) * 0.035),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: height(context) * 0.26,
                width: width(context) * 0.73,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            final TextStyle textStyle = TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            );
                            return LineTooltipItem(
                              '${touchedSpot.y.toInt()}',
                              textStyle,
                            );
                          }).toList();
                        },
                      ),
                    ),
                    minX: 0,
                    maxX: 12,
                    minY: 0,
                    maxY: 100,
                    borderData: FlBorderData(border: Border.all(width: 0.2)),
                    backgroundColor: Colors.white,
                    baselineY: 0,
                    baselineX: 0,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          12,
                          (index) => FlSpot(
                            index + 1,
                            widget.graphdata[index].toDouble(),
                          ),
                        ),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [themeColor, themeColor],
                        ),
                        barWidth: 0.3,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [themeColor, themeColor],
                          ),
                        ),
                        dotData: FlDotData(show: false),
                      ),
                    ],
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        if (value == 1 || value == 12) {
                          return FlLine(
                            color: Colors.black,
                            strokeWidth: 0.2,
                          );
                        } else {
                          return FlLine(
                            strokeWidth: 0.2,
                            color: Colors.black,
                          );
                        }
                      },
                      getDrawingHorizontalLine: (value) {
                        if (value == 0 || value == 10) {
                          return FlLine(
                            color: Colors.black,
                            strokeWidth: 0.2,
                          );
                        } else {
                          return FlLine(
                            strokeWidth: 0.2,
                            color: Colors.black,
                          );
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              String text = 'ddddm';
                              switch (value.toInt()) {
                                case 20:
                                  text = "20k";
                                  break;
                                case 40:
                                  text = "40k";
                                  break;
                                case 60:
                                  text = "60k";
                                  break;
                                case 80:
                                  text = "80k";
                                  break;
                                case 100:
                                  text = "100k";
                                  break;
                                default:
                                  return Container();
                              }
                              return Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              );
                            }),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Center(
                            child: AppText(
                              text: "Month",
                              color: black,
                              size: 12,
                            ),
                          ),
                        ),
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 20,
                            getTitlesWidget: (value, meta) {
                              String text = 'dm';
                              switch (value.toInt()) {
                                // case 1:
                                //   text = "Jan";
                                //   break;
                                case 2:
                                  text = "Feb";
                                  break;
                                case 3:
                                  text = "Mar";
                                  break;
                                case 4:
                                  text = "Apr";
                                  break;
                                case 5:
                                  text = "May";
                                  break;
                                case 6:
                                  text = "Jun";
                                  break;
                                case 7:
                                  text = "Jul";
                                  break;
                                case 8:
                                  text = "Aug";
                                  break;
                                case 9:
                                  text = "Sep";
                                  break;
                                case 10:
                                  text = "Oct";
                                  break;
                                case 11:
                                  text = "Nov";
                                  break;
                                case 12:
                                  text = "Dec";
                                  break;
                                default:
                                  return Container();
                              }
                              return Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              );
                            }),
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
