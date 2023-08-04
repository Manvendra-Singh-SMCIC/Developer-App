// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/app_text.dart';
import '../utils/constant.dart';

class ShowRequestScreen extends StatefulWidget {
  const ShowRequestScreen({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _ShowRequestScreenState createState() => _ShowRequestScreenState();
}

class _ShowRequestScreenState extends State<ShowRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          width: width(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              addVerticalSpace(60),
              Container(
                child: AppText(
                  text: "Requests",
                  color: black,
                  fontWeight: FontWeight.bold,
                  size: 22,
                ),
              ),
              addVerticalSpace(20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("projects")
                      .doc(widget.id.toString())
                      .collection("requests")
                      .orderBy("last_time", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      print(documents.length);
                      return Column(
                        children: List.generate(documents.length, (index) {
                          return Column(
                            children: [
                              InkWell(
                                child: ListTile(
                                  title: Text(
                                    documents[index]["msg"]!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        documents[index]["date"],
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w800,
                                          color: black,
                                        ),
                                      ),
                                      Text(
                                        documents[index]["time"],
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w800,
                                          color: black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  leading: CircleAvatar(
                                    maxRadius: width(context) * 0.065,
                                    backgroundColor: Color(0xFFB4DBFF),
                                    // backgroundColor: Colors.transparent,
                                    child: Center(
                                      child: Icon(
                                        Icons.question_mark_outlined,
                                        size: width(context) * 0.11,
                                        color: Color(0xFFEAF2FF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: index != documents.length - 1,
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Divider(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
