// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../utils/app_text.dart';
import '../utils/constant.dart';
import '../utils/expandable_text.dart';
import '../utils/styles.dart';
import '../utils/widgets.dart';

class AddDeveloperScreen extends StatefulWidget {
  const AddDeveloperScreen({Key? key, required this.projectDoc})
      : super(key: key);
  final DocumentSnapshot projectDoc;

  @override
  _AddDeveloperScreenState createState() => _AddDeveloperScreenState();
}

class _AddDeveloperScreenState extends State<AddDeveloperScreen> {
  TextEditingController searchController = TextEditingController();

  get color => null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("projects")
                .where("id", isEqualTo: widget.projectDoc["id"])
                .snapshots(),
            builder: (context, snaps) {
              if (snaps.hasData) {
                DocumentSnapshot projectDoc = snaps.data!.docs[0];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          "Add a developer",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: width(context) * 0.055,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: "   Search",
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .where("role", isEqualTo: "developer")
                                .where("id",
                                    whereNotIn: projectDoc["developer_id"])
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                List<DocumentSnapshot> documents =
                                    snapshot.data!.docs;
                                if (documents.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        return Visibility(
                                          visible: documents[index]["name"]
                                              .toString()
                                              .toLowerCase()
                                              .contains(searchController.text
                                                  .trim()
                                                  .toLowerCase()),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  documents[index]["name"]!,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // subtitle: Text(
                                                //   display_list[index].last_chat!,
                                                //   style: const TextStyle(
                                                //       color: Colors.black),
                                                // ),
                                                leading: CircleAvatar(
                                                  maxRadius:
                                                      width(context) * 0.065,
                                                  backgroundColor:
                                                      Color(0xFFB4DBFF),
                                                  // backgroundColor: Colors.transparent,
                                                  child: Container(
                                                    height:
                                                        width(context) * 0.3,
                                                    width: width(context) * 0.3,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        image: DecorationImage(
                                                            image: networkImage(
                                                                documents[index]
                                                                    ["pic"]),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ),
                                                onTap: () {
                                                  nextScreen(
                                                    context,
                                                    DeveloperDetail(
                                                      projectDoc: projectDoc,
                                                      doc: documents[index],
                                                      selected: false,
                                                    ),
                                                  );
                                                },
                                              ),
                                              Visibility(
                                                visible: index !=
                                                    documents.length - 1,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  child: Divider(
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  return Center(
                                    child: AppText(
                                      text:
                                          "No developers available currently.",
                                      color: black,
                                    ),
                                  );
                                }
                              } else {
                                return nullWidget();
                              }
                            }),
                      ),
                    ),
                  ],
                );
              } else {
                return nullWidget();
              }
            }),
      ),
    );
  }
}

class DeveloperDetail extends StatefulWidget {
  const DeveloperDetail({
    super.key,
    required this.doc,
    required this.projectDoc,
    required this.selected,
  });

  final DocumentSnapshot doc;
  final DocumentSnapshot projectDoc;
  final bool selected;

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

  @override
  void initState() {
    level = tempLevel = widget.doc["level"].toString();
    super.initState();
  }

  String level = "10";
  String tempLevel = "10";

  TextEditingController levelController = TextEditingController();

  Future<bool?> showConfirmationDialog(BuildContext context, String msg) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(msg),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: levelController,
                  onChanged: (value) {
                    int? lvl = int.tryParse(levelController.text.trim());
                    if (lvl != null && lvl >= 1 && lvl <= 10) {
                      tempLevel = levelController.text.trim();
                      print(tempLevel);
                    } else {
                      levelController.clear();
                      Fluttertoast.showToast(
                        msg: "Level must be numberr between 1 and 10",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                      );
                    }
                    setState(() {});
                  },
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
                  Navigator.of(context)
                      .pop(true); // Return true on confirmation
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.doc.data().toString());
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      text: "Level: $level",
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
                    backgroundColor: btnColor,
                    onPressed: () async {
                      if (widget.selected) {
                        bool confirm = await showConfirmationDialog(
                                context, 'Enter the value of level') ??
                            false;
                        if (confirm) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.doc["id"].toString())
                              .update({"level": int.tryParse(tempLevel)}).then(
                                  (value) {
                            level = tempLevel;
                            setState(() {
                              Fluttertoast.showToast(
                                msg: "Level Changed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            });
                          }).onError((error, stackTrace) {
                            Fluttertoast.showToast(
                              msg: "Some error occured please try again",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                            );
                          });
                        }
                      } else {
                        FirebaseFirestore.instance
                            .collection("projects")
                            .doc(widget.projectDoc["id"].toString())
                            .update({
                          "developer_id": widget.projectDoc["developer_id"]
                            ..add(widget.doc["id"]),
                        }).then((value) {
                          Fluttertoast.showToast(
                            msg: "Developer Added",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                          goBack(context);
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
                      }
                    },
                    label: AppText(
                      text: widget.selected ? "Modify Level" : "Add Developer",
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
