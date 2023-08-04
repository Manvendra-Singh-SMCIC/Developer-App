// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'package:amacle_studio_app/pages/developer_details.dart';
import 'package:amacle_studio_app/pages/start_project.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/expandable_text.dart';

class ManagerIndividualProject extends StatefulWidget {
  const ManagerIndividualProject({super.key, required this.doc});

  final DocumentSnapshot doc;

  @override
  State<ManagerIndividualProject> createState() =>
      _ManagerIndividualProjectState();
}

class _ManagerIndividualProjectState extends State<ManagerIndividualProject>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _currentIndex = 0;

  bool isLoading = false;

  @override
  void dispose() {
    _tabController.dispose();
    _tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      _currentIndex = _tabController.index;
    });
    // Perform actions or update UI based on the new index
    print("TabBarView index changed: $_currentIndex");
  }

  List<String> githubs = [];

  @override
  Widget build(BuildContext context) {
    // log(widget.doc.data().toString());
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Visibility(
          child: FloatingActionButton.extended(
            onPressed: () {
              print(githubs);
              nextScreen(
                  context,
                  StartProject(
                    githubs: githubs,
                    projectDetails: widget.doc,
                  ));
            },
            backgroundColor: btnColor,
            label: AppText(text: "Start Project"),
          ),
        ),
        body: Container(
          width: width(context),
          child: Column(
            children: [
              Container(
                width: width(context),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: (height(context) * 0.25),
                      width: width(context),
                      child: Image(
                        image: networkImage(
                          widget.doc["image"],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Positioned(
                        right: 20,
                        bottom: 20,
                        child: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.bookmark,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: Positioned(
                        right: 25,
                        bottom: 10,
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Color(0xFFF8F9FF),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                labelColor: themeColor,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.grey.withOpacity(0.7),
                controller: _tabController,
                tabs: [
                  Tab(text: "Project\nDetails"),
                  Tab(text: 'Applicants'),
                  Tab(text: 'Selected\nApplicants'),
                ],
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  //child 1
                  //child 1
                  //child 1
                  //child 1
                  //child 1
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: true,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, left: 20),
                            child: Text(
                              widget.doc["company"],
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF355BC0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  widget.doc["name"],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  "₹${widget.doc["price"]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Description",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: const Color(0xFF212222),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 20, right: 10),
                          child: ExpandableText(
                            text: widget.doc["desc"],
                            textHeight: 250,
                            color: Color(0xFF212222),
                            size: 13,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 20),
                          child: Text(
                            "Tags",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF212222),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(widget.doc["tags"].length,
                                  (index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF212222),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.doc["tags"][index],
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF212222),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: Color(0xFF8A8B8C),
                              ),
                              Text(
                                "Started",
                                style: TextStyle(
                                  color: Color(0xFF8A8B8C),
                                  fontSize: 13,
                                ),
                              ),
                              Spacer(),
                              Visibility(
                                visible: true,
                                child: Icon(
                                  Icons.timer,
                                  color: Color(0xFF8A8B8C),
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    "Due Date",
                                    style: TextStyle(
                                      color: Color(0xFF8A8B8C),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: Row(
                            children: [
                              Text(
                                widget.doc["posted"],
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: const Color(0xFF212222),
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Visibility(
                                visible: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    widget.doc["deadline"],
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: const Color(0xFF212222),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 20, top: 10),
                            child: Text(
                              "Owner",
                              style: TextStyle(
                                color: Color(0xFF8A8B8C),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: Container(
                              width: 210,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: CircleAvatar(
                                          child: Icon(Icons.person)),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Satish Mehta",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.verified_rounded,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Follow",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF355BC0),
                                            fontSize: 13,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //child 2
                  //child 2
                  //child 2
                  //child 2
                  //child 2
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .where("id",
                                    whereIn: widget.doc["applied"].isNotEmpty
                                        ? widget.doc["applied"]
                                        : [-1])
                                .where("role", isEqualTo: "developer")
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(height: 30);
                              }
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;
                                return SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 30),
                                    width: width(context),
                                    child: Column(
                                      children: List.generate(documents.length,
                                          (index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                nextScreen(
                                                  context,
                                                  DeveloperDetail(
                                                    doc: documents[index],
                                                    added: false,
                                                    listOfAdded:
                                                        widget.doc["added"],
                                                    projectId: widget.doc["id"],
                                                  ),
                                                );
                                              },
                                              title: Text(
                                                documents[index]["name"],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              leading: CircleAvatar(
                                                maxRadius:
                                                    width(context) * 0.065,
                                                backgroundColor:
                                                    Color(0xFFB4DBFF),
                                                // backgroundColor: Colors.transparent,
                                                child: Container(
                                                  height: width(context) * 0.3,
                                                  width: width(context) * 0.3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      image: DecorationImage(
                                                          image: networkImage(
                                                              documents[index]
                                                                  ["pic"]),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            addVerticalSpace(15),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 1,
                                  height: 1,
                                  color: Colors.transparent,
                                );
                              }
                            }),
                        addVerticalSpace(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            addHorizontalySpace(18),
                            AppText(
                              text: "See other developers also",
                              color: themeColor,
                              size: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ],
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .where("id",
                                    whereNotIn: widget.doc["applied"].isNotEmpty
                                        ? widget.doc["applied"]
                                        : [-1])
                                .where("role", isEqualTo: "developer")
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return nullWidget();
                              }
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;
                                return SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 30),
                                    width: width(context),
                                    child: Column(
                                      children: List.generate(documents.length,
                                          (index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                nextScreen(
                                                  context,
                                                  DeveloperDetail(
                                                    doc: documents[index],
                                                    added: false,
                                                    listOfAdded:
                                                        widget.doc["added"],
                                                    projectId: widget.doc["id"],
                                                  ),
                                                );
                                              },
                                              title: Text(
                                                documents[index]["name"],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              leading: CircleAvatar(
                                                maxRadius:
                                                    width(context) * 0.065,
                                                backgroundColor:
                                                    Color(0xFFB4DBFF),
                                                // backgroundColor: Colors.transparent,
                                                child: Container(
                                                  height: width(context) * 0.3,
                                                  width: width(context) * 0.3,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      image: DecorationImage(
                                                          image: networkImage(
                                                              documents[index]
                                                                  ["pic"]),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            addVerticalSpace(15),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 1,
                                  height: 1,
                                  color: Colors.transparent,
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                  // Child 3
                  // Child 3
                  // Child 3
                  // Child 3
                  // Child 3
                  SingleChildScrollView(
                    child: Column(children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .where("id",
                                  whereIn: widget.doc["added"].isNotEmpty
                                      ? widget.doc["added"]
                                      : [-1])
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return nullWidget();
                            }
                            if (snapshot.hasData) {
                              githubs = [];
                              List<DocumentSnapshot> documents =
                                  snapshot.data!.docs;
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(top: 30),
                                  width: width(context),
                                  child: Column(
                                    children: List.generate(documents.length,
                                        (index) {
                                      githubs.add(documents[index]["github"]);
                                      return Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              nextScreen(
                                                context,
                                                DeveloperDetail(
                                                  doc: documents[index],
                                                  added: true,
                                                  listOfAdded:
                                                      widget.doc["added"],
                                                  projectId: widget.doc["id"],
                                                ),
                                              );
                                            },
                                            trailing: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  List listOfAdded =
                                                      widget.doc["added"];
                                                  print(listOfAdded.remove(
                                                      documents[index]["id"]));
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "new_projects")
                                                      .doc(widget.doc["id"]
                                                          .toString())
                                                      .update({
                                                    "added": listOfAdded,
                                                  }).then((value) {
                                                    Fluttertoast.showToast(
                                                      msg: "Developer Removed",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                    );
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    print(
                                                        'Data updated successfully');
                                                  }).catchError((error) {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Could not remove developer",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                    );
                                                    print(
                                                        'Failed to update data: $error');
                                                  });
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                child: Container(
                                                  width: 27,
                                                  height: 27,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black26,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      8,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Typicons.minus,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              documents[index]["name"],
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            leading: CircleAvatar(
                                              maxRadius: width(context) * 0.065,
                                              backgroundColor:
                                                  Color(0xFFB4DBFF),
                                              // backgroundColor: Colors.transparent,
                                              child: Container(
                                                height: width(context) * 0.3,
                                                width: width(context) * 0.3,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    image: DecorationImage(
                                                        image: networkImage(
                                                            documents[index]
                                                                ["pic"]),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                          ),
                                          addVerticalSpace(15),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                width: 1,
                                height: 1,
                                color: Colors.transparent,
                              );
                            }
                          }),
                    ]),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
