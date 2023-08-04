// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'package:amacle_studio_app/pages/bottom_bar_pages/chat.dart';
import 'package:amacle_studio_app/pages/each_chat.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../global/globals.dart';

class BottomBarCharPage extends StatefulWidget {
  const BottomBarCharPage({super.key});

  @override
  State<BottomBarCharPage> createState() => _BottomBarCharPageState();
}

class ChatData {
  final int id;
  final DateTime timestamp;
  final DocumentSnapshot lastChatData;

  ChatData(this.id, this.timestamp, this.lastChatData);
}

class _BottomBarCharPageState extends State<BottomBarCharPage> with RouteAware {
  String chatRoomId(int userId1, int userId2) {
    if (userId1 > userId2) {
      return "${userId1}chat${userId2}";
    } else {
      return "${userId2}chat${userId1}";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // final RouteObserver<ModalRoute<void>> routeObserver =
  //     RouteObserver<ModalRoute<void>>();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(this, ModalRoute.of(context)!);
  // }

  // @override
  // void dispose() {
  //   routeObserver.unsubscribe(this);
  //   super.dispose();
  // }

  // @override
  // void didPopNext() {
  //   // Handle the refresh when returning from the current page
  //   refreshPage();
  // }

  // void refreshPage() {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // List<ChatData> sortedChatData = [];
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(Global.mainMap[0].id.toString())
    //     .collection("my_chats")
    //     .get()
    //     .then((querySnapshotss) {
    //   log("len " + querySnapshotss.docs.length.toString());
    //   querySnapshotss.docs.forEach((doc) async {
    //     await FirebaseFirestore.instance
    //         .collection("users")
    //         .doc(Global.mainMap[0].id.toString())
    //         .collection("my_chats")
    //         .doc(doc.id)
    //         .collection("chats")
    //         .orderBy("last_time", descending: true)
    //         .limit(1)
    //         .get()
    //         .then((snaps) {
    //       if (snaps.docs.isNotEmpty) {
    //         var mostRecentDocument = snaps.docs.first;
    //         var lastTime = mostRecentDocument["last_time"];
    //         int parsedDocId = int.tryParse(doc.id)!;
    //         sortedChatData.add(
    //             ChatData(parsedDocId, lastTime.toDate(), mostRecentDocument));
    //         sortedChatData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    //         // sortedTimestamps.add(lastTime.toDate());
    //         // Process the most recent timestamp value
    //         print(
    //             "Most recent timestamp for: ${doc.id} is: ${snaps.docs.first["last_time"].toString()}");
    //       } else {
    //         // Handle the case when no documents are found in the subcollection
    //         print("No documents found in the subcollection");
    //       }
    //     });

    //     print(doc.id);
    //   });
    // });

    // log(sortedChatData.length.toString());

    // Future.delayed(Duration(seconds: 3), () {
    //   sortedChatData.forEach((chatData) {
    //     print("ID: ${chatData.id}, Timestamp: ${chatData.timestamp}");
    //   });
    // });
    return WillPopScope(
      onWillPop: () async {
        setState(() {});
        return true;
      },
      child: SafeArea(
          child: Scaffold(
              body: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              "Chats",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: width(context) * 0.055,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: TextField(
            enabled: true,
            readOnly: true,
            onTap: () {
              nextScreen(context, ChatsPage());
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
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
            child: StreamBuilder<QuerySnapshot>(
                stream: null,
                builder: (context, snapshot) {
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(Global.id.toString())
                              .collection("my_chats")
                              .orderBy("last_time", descending: true)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.hasData) {
                              List<DocumentSnapshot> documents =
                                  snapshot.data!.docs;

                              if (true) {
                                return FutureBuilder<List<ChatData>>(
                                    future: toreturn(documents),
                                    builder: (context, snapfinal) {
                                      if (snapfinal.hasData) {
                                        log(snapfinal.data!.length.toString());
                                        if (snapfinal.data!.length != 0) {
                                          return ListView.builder(
                                              itemCount: snapfinal.data!.length,
                                              // itemCount: 0,
                                              itemBuilder: (context, index) {
                                                // print(snapfinal.data);

                                                int userId =
                                                    snapfinal.data![index].id;
                                                // log(userId.toString());

                                                return StreamBuilder<
                                                        QuerySnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .where("id",
                                                            isEqualTo: userId)
                                                        .snapshots(),
                                                    builder: (context,
                                                        AsyncSnapshot snaps) {
                                                      if (snaps.hasData) {
                                                        List<DocumentSnapshot>
                                                            docs =
                                                            snaps.data!.docs;
                                                        print(docs[0]["name"]);
                                                        return Visibility(
                                                            // visible: visibleUsers.contains(),
                                                            // child: Container(
                                                            //   color: green,
                                                            //   height: 30,
                                                            //   width: 30,
                                                            //   margin:
                                                            //       EdgeInsets.symmetric(
                                                            //     vertical: 10,
                                                            //   ),
                                                            // ),
                                                            child: Column(
                                                          children: [
                                                            ListTile(
                                                              title: Text(
                                                                docs[0]
                                                                    ["name"]!,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              subtitle: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Visibility(
                                                                    visible: snapfinal
                                                                            .data![index]
                                                                            .lastChatData["sender_id"] ==
                                                                        Global.id,
                                                                    child: Icon(
                                                                      snapfinal.data![index].lastChatData["seen_by_other"] ==
                                                                              "yes"
                                                                          ? Icons
                                                                              .done_all
                                                                          : Icons
                                                                              .done,
                                                                      color:
                                                                          black,
                                                                      size: 17,
                                                                    ),
                                                                  ),
                                                                  addHorizontalySpace(
                                                                      4),
                                                                  Text(
                                                                    snapfinal.data![index].lastChatData["type"] ==
                                                                            "text"
                                                                        ? snapfinal.data![index].lastChatData[
                                                                            "message"]
                                                                        : snapfinal
                                                                            .data![index]
                                                                            .lastChatData["type"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              trailing: Column(
                                                                children: [
                                                                  Text(
                                                                    snapfinal.data![index].lastChatData["last_time"] ==
                                                                            null
                                                                        ? ""
                                                                        : DateFormat('d MMMM y').format(DateTime.parse(snapfinal
                                                                            .data![index]
                                                                            .lastChatData["last_time"]
                                                                            .toDate()
                                                                            .toString()
                                                                            .split(' ')[0])),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          8.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color:
                                                                          black,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    snapfinal.data![index].lastChatData["last_time"] ==
                                                                            null
                                                                        ? ""
                                                                        : DateFormat('h:mm a').format(snapfinal
                                                                            .data![index]
                                                                            .lastChatData["last_time"]
                                                                            .toDate()),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          8.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color:
                                                                          black,
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: snapfinal
                                                                            .data![index]
                                                                            .lastChatData["seen"] ==
                                                                        "no",
                                                                    child:
                                                                        Container(
                                                                      width: 10,
                                                                      height:
                                                                          10,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          color:
                                                                              btnColor),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              leading:
                                                                  CircleAvatar(
                                                                maxRadius: width(
                                                                        context) *
                                                                    0.065,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFFB4DBFF),
                                                                child: SizedBox(
                                                                  width: width(
                                                                          context) *
                                                                      0.3,
                                                                  height: width(
                                                                          context) *
                                                                      0.3,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    child:
                                                                        imageNetwork(
                                                                      docs[0][
                                                                          "pic"],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                String roomId =
                                                                    chatRoomId(
                                                                        Global
                                                                            .id,
                                                                        docs[0][
                                                                            "id"]);
                                                                print(roomId);
                                                                nextScreen(
                                                                    context,
                                                                    ChatPage(
                                                                      chatRoomId:
                                                                          roomId,
                                                                      doc: docs[
                                                                          0],
                                                                    ));
                                                                //   navigateToCurrentPage(
                                                                //       roomId,
                                                                //       docs[0]);
                                                              },
                                                            ),
                                                            Visibility(
                                                                visible: index !=
                                                                    snapfinal
                                                                            .data!
                                                                            .length -
                                                                        1,
                                                                child:
                                                                    Container(
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                8,
                                                                            right:
                                                                                8),
                                                                        child:
                                                                            Divider(
                                                                          color:
                                                                              Colors.black26,
                                                                        )))
                                                          ],
                                                        ));
                                                      } else {
                                                        return SizedBox(
                                                            width: 0.01,
                                                            height: 0.01);
                                                      }
                                                    });
                                              });
                                        } else {
                                          return Center(
                                            child: AppText(
                                              text: "Oops! No chats yet.",
                                              color: black,
                                              size: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          );
                                        }
                                      } else {
                                        return nullWidget(); // put loading screen here
                                      }
                                    });
                              } else {
                                return Center(
                                  child: AppText(
                                    text: "Oops! No chats yet.",
                                    color: black,
                                    size: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                );
                              }
                            } else {
                              return Container();
                            }
                          }));
                }))
      ]))),
    );
  }

//   Future<List<dynamic>> findUsersToShow(
//       List<DocumentSnapshot> documents) async {
//     List<dynamic> visibleUsers = [];

//     for (DocumentSnapshot<Object?> document in documents) {
//       int searchId = document['search_id'] as int;
//       visibleUsers.add(searchId);
//     }

//     return visibleUsers;
//   }

//   Future<List<dynamic>> bluffFunction() async {
//     await Future.delayed(Duration(seconds: 3));
//     return [];
//   }
// }

//   Future<List<ChatData>> toreturn(
//       List<DocumentSnapshot> querySnapshotss) async {
//     final sortedChatData = <ChatData>[];
//     if (querySnapshotss.length == 0) {
//       return [];
//     }

//     log(querySnapshotss.length.toString());

//     for (final doc in querySnapshotss) {
//       final snaps = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(Global.mainMap[0].id.toString())
//           .collection("my_chats")
//           .doc(doc.id)
//           .collection("chats")
//           .orderBy("last_time", descending: true)
//           .limit(1)
//           .get();

//       if (snaps.docs.isNotEmpty) {
//         final mostRecentDocument = snaps.docs.first;
//         final lastTime = mostRecentDocument["last_time"];
//         final parsedDocId = int.tryParse(doc.id)!;
//         sortedChatData.add(
//           ChatData(parsedDocId, lastTime.toDate(), mostRecentDocument),
//         );
//         sortedChatData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
//         print(
//             "Most recent timestamp for ${doc.id} is: ${snaps.docs.first["last_time"].toString()}");
//       } else {
//         print("No documents found in the subcollection");
//       }

//       print(doc.id);
//     }

//     return sortedChatData;
//   }
// }

  Future<List<ChatData>> toreturn(List<DocumentSnapshot> documents) async {
    final sortedChatData = <ChatData>[];

    final querySnapshotss = await FirebaseFirestore.instance
        .collection("users")
        .doc(Global.mainMap[0].id.toString())
        .collection("my_chats")
        .get();

    log("myy" + querySnapshotss.docs.length.toString());

    final taskResults = await Future.wait(querySnapshotss.docs.map((doc) async {
      final snaps = await FirebaseFirestore.instance
          .collection("users")
          .doc(Global.mainMap[0].id.toString())
          .collection("my_chats")
          .doc(doc.id)
          .collection("chats")
          .orderBy("last_time", descending: true)
          .limit(1)
          .get();

      if (snaps.docs.isNotEmpty) {
        final mostRecentDocument = snaps.docs.first;
        final lastTime = mostRecentDocument["last_time"];
        final parsedDocId = int.tryParse(doc.id)!;
        sortedChatData
            .add(ChatData(parsedDocId, lastTime.toDate(), mostRecentDocument));
        sortedChatData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        print(
            "Most recent timestamp for ${doc.id} is: ${snaps.docs.first["last_time"].toString()}");
      } else {
        print("No documents found in the subcollection");
      }
    }));

    print("All tasks completed");

    return sortedChatData;
  }
}
