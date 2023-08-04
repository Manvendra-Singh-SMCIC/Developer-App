// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../global/globals.dart';
import '../utils/expandable_text.dart';

class IndividualProject extends StatefulWidget {
  const IndividualProject({super.key, required this.doc});

  final DocumentSnapshot doc;

  @override
  State<IndividualProject> createState() => _IndividualProjectState();
}

class _IndividualProjectState extends State<IndividualProject> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    List applied = widget.doc["applied"];
    log(applied.toString());
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              image: NetworkImage(
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                      padding:
                          const EdgeInsets.only(top: 5, left: 10, right: 10),
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
                          children:
                              List.generate(widget.doc["tags"].length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
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
                                          color: const Color(0xFF212222)),
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
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Owner",
                        style: TextStyle(
                          color: Color(0xFF8A8B8C),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Padding(
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
                                child: CircleAvatar(child: Icon(Icons.person)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                    addVerticalSpace(height(context) * 0.18),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Container(
                      width: height(context) * 0.8,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: applied.contains(Global.mainMap[0]["id"])
                            ? Colors.grey.withOpacity(0.5)
                            : Color(0xFF355BC0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (!applied.contains(Global.mainMap[0]["id"])) {
                            setState(() {
                              isLoading = true;
                            });
                            applied.add(Global.mainMap[0]["id"]);
                            FirebaseFirestore.instance
                                .collection("new_projects")
                                .doc(widget.doc["id"].toString())
                                .update({
                              "applied": applied,
                            }).then((value) {
                              Fluttertoast.showToast(
                                msg: "Applied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                              print('Data updated successfully');
                            }).catchError((error) {
                              Fluttertoast.showToast(
                                msg: "Could not Apply",
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
                        child: Center(
                          child: Text(
                            applied.contains(Global.mainMap[0]["id"])
                                ? "Already Applied"
                                : "Apply for Project",
                            style: GoogleFonts.poppins(
                                color: Color(0xFFFDFDFD), fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
