// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../global/globals.dart';
import '../utils/app_text.dart';
import '../utils/constant.dart';
import '../utils/widgets.dart';

class AgreementCheckPage extends StatefulWidget {
  const AgreementCheckPage({Key? key, required this.doc}) : super(key: key);

  final DocumentSnapshot doc;

  @override
  _AgreementCheckPageState createState() => _AgreementCheckPageState();
}

class _AgreementCheckPageState extends State<AgreementCheckPage> {
  Future approve(String id, bool approved) async {
    print(approved.toString());
    FirebaseFirestore.instance
        .collection("projects")
        .doc(widget.doc["id"].toString())
        .collection("agreements")
        .doc(id)
        .update({
      "approved": approved ? "no" : "yes",
    }).then((value) {
      Fluttertoast.showToast(
        msg: "Approval Updated",
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }

  openFile(String url, String? fileName) async {
    File file = await downloadFile(url, fileName!);

    if (file == null) return;

    print("Path: ${file.path}");

    OpenFile.open(file.path);
  }

  downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: Duration(seconds: 3),
          ));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                addVerticalSpace(height(context) * 0.02),
                Text(
                  "Agreements",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                addVerticalSpace(height(context) * 0.03),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("projects")
                        .doc(widget.doc["id"].toString())
                        .collection("agreements")
                        .orderBy("time", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return Column(
                          children: List.generate(documents.length, (index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                          msg: "Opening Document",
                                          timeInSecForIosWeb: 1,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        openFile(documents[index]["url"],
                                            documents[index]["name"]);
                                      },
                                      child: Container(
                                        height: width(context) * 0.2,
                                        width: width(context) * 0.16,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: btnColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              width(context) * 0.03),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            AppText(
                                              text: "  PDF",
                                              color: btnColor,
                                              size: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    addHorizontalySpace(width(context) * 0.03),
                                    Container(
                                      width: width(context) * 0.7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: width(context) * 0.6,
                                                child: AppText(
                                                  text: "Payment Agreement.pdf",
                                                  color: black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  approve(
                                                      documents[index].id,
                                                      documents[index]
                                                              ["approved"] ==
                                                          "yes");
                                                },
                                                child: SizedBox(
                                                  width: width(context) * 0.1,
                                                  child: Icon(
                                                    documents[index]
                                                                ["approved"] ==
                                                            "no"
                                                        ? Icons.close
                                                        : Icons.check,
                                                    color: documents[index]
                                                                ["approved"] ==
                                                            "no"
                                                        ? Colors.red
                                                        : green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          addVerticalSpace(
                                              height(context) * 0.01),
                                          Container(
                                            height: 7,
                                            width: width(context) * 0.7,
                                            decoration: BoxDecoration(
                                              color: documents[index]
                                                          ["approved"] ==
                                                      "no"
                                                  ? Colors.red
                                                  : green,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                addVerticalSpace(height(context) * 0.03),
                              ],
                            );
                          }),
                        );
                      } else {
                        return nullWidget();
                      }
                    }),
                addVerticalSpace(height(context) * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
