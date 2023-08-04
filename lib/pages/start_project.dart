import 'dart:convert';
import 'dart:developer';

import 'package:amacle_studio_app/global/globals.dart';
import 'package:amacle_studio_app/main.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/manager_project_screen.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class StartProject extends StatefulWidget {
  const StartProject(
      {super.key, required this.githubs, required this.projectDetails});

  final List<String> githubs;
  final DocumentSnapshot projectDetails;

  @override
  State<StartProject> createState() => _StartProjectState();
}

class _StartProjectState extends State<StartProject> {
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  // final String personalAccessToken = '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';
  // final String username = 'Manvendra-Singh-SMCIC';
  final String apiUrl = 'https://api.github.com';
  bool loading = false;

  createRepository(String repoOwner, String repoName, String authToken) async {
    int finalPrice = 0;
    String apiUrl = "https://api.github.com/user/repos";
    String authHeaderValue = "token $authToken";

    Map<String, dynamic> requestBody = {
      'name': repoName,
      'private': false,
    };

    try {
      setState(() {
        loading = true;
      });
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        print(response.body);
        Fluttertoast.showToast(
          msg: "Repository Created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        print('Succeeded to create repository');
        Future.delayed(Duration(milliseconds: 2000), () async {
          for (String github in widget.githubs) {
            String devUserName = github.split('/')[3].toString().trim();
            await addCollaborator(repoOwner, repoName, devUserName, authToken);
          }
        });

        Future.delayed(Duration(milliseconds: 5000), () async {
          DocumentSnapshot snapshot = await FirebaseFirestore.instance
              .collection("users")
              .doc(widget.projectDetails["client_id"].toString())
              .get();

          if (snapshot.exists) {
            String referralEntered = snapshot["referral_entered"];
            finalPrice = snapshot["wallet"];
            if (referralEntered != "") {
              DocumentSnapshot snaps = await FirebaseFirestore.instance
                  .collection("referrals")
                  .doc(referralEntered)
                  .get();
              int parentClient = snaps["owner"];
              try {
                DocumentSnapshot snapshotss = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(parentClient.toString())
                    .get();

                if (snapshotss.exists) {
                  int currentWallet = snapshot["wallet"] ?? 0;
                  int amt = widget.projectDetails["price"];
                  int updatedWallet =
                      currentWallet + (amt * 0.05).round().toInt();

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(parentClient.toString())
                      .update({"wallet": updatedWallet});

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.projectDetails["client_id"].toString())
                      .update({"wallet": 0});

                  print("Wallet updated successfully");
                } else {
                  print("Document does not exist");
                }
              } catch (e) {
                print("Error updating wallet: $e");
              }
            }
          } else {
            print("Not referred");
          }
        });

        Future.delayed(Duration(milliseconds: 7000), () async {
          CollectionReference projects =
              FirebaseFirestore.instance.collection('projects');
          int count = 0;
          QuerySnapshot snaps =
              await projects.orderBy('id', descending: true).get();

          if (snaps.docs.isNotEmpty) {
            DocumentSnapshot document = snaps.docs.first;
            print('Document ID: ${document.id}');
            count = int.parse(document.id);
          } else {
            count = 0;
            print('No documents found in the collection.');
          }

          DocumentReference documentRef = projects.doc((count + 1).toString());

          await documentRef.set({
            "client_id": widget.projectDetails["client_id"],
            "company": widget.projectDetails["company"],
            "delay": 0,
            "desc": widget.projectDetails["desc"],
            "developer_id": widget.projectDetails["added"],
            "end": widget.projectDetails["deadline"],
            "id": count + 1,
            "image": widget.projectDetails["image"],
            "manager_id": Global.mainMap[0]["id"],
            "name": widget.projectDetails["name"],
            "price": widget.projectDetails["price"] - finalPrice,
            "progress": 0,
            "blocked": [],
            "repo_name": repoName,
            "repo_owner": repoOwner,
            "bonus": 0,
            "start":
                DateFormat('dd MMM yyyy').format(DateTime.now()).toString(),
            "status": "active",
            "tags": widget.projectDetails["tags"],
            "token": authToken,
          }).then((value) {
            print('Data added successfully!');
            Fluttertoast.showToast(
              msg: "Project created",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
            );
            FirebaseFirestore.instance
                .collection("new_projects")
                .doc(widget.projectDetails["id"].toString())
                .delete()
                .then((value) {
              setState(() {
                loading = true;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                  (route) => false);
              // Fluttertoast.showToast(
              //   msg: "Removed from here",
              //   toastLength: Toast.LENGTH_SHORT,
              //   gravity: ToastGravity.BOTTOM,
              //   timeInSecForIosWeb: 1,
              // );
              print('Document deleted successfully');
            }).catchError((error) {
              print('Failed to delete document: $error');
            });
          }).catchError((error) {
            print('Failed to add data: $error');
          });
        });
      }
      if (response.statusCode != 201) {
        Fluttertoast.showToast(
          msg: "Could not create Repository. Try using another name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        print('Failed to create repository');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Could not create Repository",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      print('Failed to connect to the server');
    }
  }

  addCollaborator(String repoOwner, String repoName, String username,
      String authToken) async {
    String apiUrl =
        "https://api.github.com/repos/$repoOwner/$repoName/collaborators/$username";
    String authHeaderValue = "token $authToken";

    try {
      http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': authHeaderValue,
        },
      );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "$username added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        print('Collaborator added successfully');
      } else {
        Fluttertoast.showToast(
          msg: "$username could not be added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        print('Failed to add collaborator');
        print(response.body);
      }
    } catch (e) {
      print('Failed to connect to the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    loading = false;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addVerticalSpace(15),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      "Create a project on Github",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Text(
                      "Enter your Github username personel access token",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  addVerticalSpace(20),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.5,
                      height: width(context) * 0.5,
                      child: Image.asset("assets/github.png"),
                    ),
                  ),
                  addVerticalSpace(20),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: controllers[0],
                        decoration: InputDecoration(
                          labelText: 'Username Name',
                          hintText: "Username Name",
                          floatingLabelBehavior: controllers[0].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  addVerticalSpace(20),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: controllers[1],
                        decoration: InputDecoration(
                          labelText: 'Personal Access Token',
                          hintText: "Personal Access Token",
                          floatingLabelBehavior: controllers[1].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  addVerticalSpace(20),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: controllers[2],
                        decoration: InputDecoration(
                          labelText: 'Repository Name',
                          hintText: "Repository Name",
                          floatingLabelBehavior: controllers[2].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.13),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: width(context) * 0.92,
                        height: height(context) * 0.08,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(btnColor),
                          ),
                          onPressed: () {
                            if (!controllers[0]
                                .text
                                .trim()
                                .startsWith("https:")) {
                              if (controllers[0].text.trim().isNotEmpty &&
                                  controllers[1].text.trim().isNotEmpty &&
                                  controllers[2].text.trim().isNotEmpty) {
                                // createRepository("Manvendra-Singh-SMCIC", "Trial3",
                                //     "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");
                                createRepository(
                                    "Manvendra-Singh-SMCIC",
                                    "Trial3",
                                    "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");
                                createRepository(
                                    controllers[0].text.trim(),
                                    controllers[2].text.trim(),
                                    controllers[1].text.trim());
                              } else {
                                Fluttertoast.showToast(
                                  msg: "All fields are required",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Invalid user name. User name cannot be a link.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          },
                          child: AppText(
                            text: "Create Repository",
                            size: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
