/*
// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'package:amacle_studio_app/pages/bottom_bar_pages/chat.dart';
import 'package:amacle_studio_app/pages/each_chat.dart';
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

class _BottomBarCharPageState extends State<BottomBarCharPage> {
  String chatRoomId(int userId1, int userId2) {
    if (userId1 > userId2) {
      return "${userId1}chat${userId2}";
    } else {
      return "${userId2}chat${userId1}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(Global.id.toString())
                            .collection("my_chats")
                            .orderBy("last_time", descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> documents =
                                snapshot.data!.docs;

                            findUsersToShow(documents);

                            return FutureBuilder(
                                future: findUsersToShow(documents),
                                builder: (context, snapfinal) {
                                  if (snapfinal.hasData) {
                                    log(snapfinal.data.toString());

                                    return ListView.builder(
                                        itemCount: documents.length,
                                        itemBuilder: (context, index) {
                                          print(snapfinal.data);

                                          return StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('users')
                                                  .where("id",
                                                      isEqualTo: snapfinal
                                                          .data![index])
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot snaps) {
                                                if (snaps.hasData) {
                                                  List<DocumentSnapshot> docs =
                                                      snaps.data!.docs;
                                                  return Visibility(
                                                    // visible: visibleUsers.contains(),
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          title: Text(
                                                            docs[0]["name"]!,
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
                                                                visible: documents[
                                                                            index]
                                                                        [
                                                                        "sender_id"] ==
                                                                    Global.id,
                                                                child: Icon(
                                                                  documents[index]
                                                                              [
                                                                              "seen_by_other"] ==
                                                                          "yes"
                                                                      ? Icons
                                                                          .done_all
                                                                      : Icons
                                                                          .done,
                                                                  color: black,
                                                                  size: 17,
                                                                ),
                                                              ),
                                                              addHorizontalySpace(
                                                                  4),
                                                              Text(
                                                                documents[index]
                                                                            [
                                                                            "type"] ==
                                                                        "text"
                                                                    ? documents[
                                                                            index]
                                                                        [
                                                                        "message"]
                                                                    : documents[
                                                                            index]
                                                                        [
                                                                        "type"],
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
                                                                documents[index]
                                                                            [
                                                                            "last_time"] ==
                                                                        null
                                                                    ? ""
                                                                    : DateFormat('d MMMM y').format(DateTime.parse(documents[index]
                                                                            [
                                                                            "last_time"]
                                                                        .toDate()
                                                                        .toString()
                                                                        .split(
                                                                            ' ')[0])),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 8.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: black,
                                                                ),
                                                              ),
                                                              Text(
                                                                documents[index]
                                                                            [
                                                                            "last_time"] ==
                                                                        null
                                                                    ? ""
                                                                    : DateFormat(
                                                                            'h:mm a')
                                                                        .format(
                                                                            documents[index]["last_time"].toDate()),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 8.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: black,
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: documents[
                                                                            index]
                                                                        [
                                                                        "seen"] ==
                                                                    "no",
                                                                child:
                                                                    Container(
                                                                  width: 10,
                                                                  height: 10,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color:
                                                                          btnColor),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          leading: CircleAvatar(
                                                            maxRadius:
                                                                width(context) *
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
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                child: Image
                                                                    .network(
                                                                  docs[0]
                                                                      ["pic"],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            String roomId =
                                                                chatRoomId(
                                                                    Global.id,
                                                                    docs[0]
                                                                        ["id"]);
                                                            print(roomId);
                                                            nextScreen(
                                                                context,
                                                                ChatPage(
                                                                  chatRoomId:
                                                                      roomId,
                                                                  doc: docs[0],
                                                                ));
                                                          },
                                                        ),
                                                        Visibility(
                                                          visible: index !=
                                                              documents.length -
                                                                  1,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Divider(
                                                              color: Colors
                                                                  .black26,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                      width: 0.01,
                                                      height: 0.01);
                                                }
                                              });
                                        });
                                  } else {
                                    return nullWidget();
                                  }
                                });
                          } else {
                            return Container();
                          }
                        },
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> findUsersToShow(
      List<DocumentSnapshot> documents) async {
    List<dynamic> visibleUsers = [];

    for (DocumentSnapshot<Object?> document in documents) {
      int searchId = document['search_id'] as int;
      visibleUsers.add(searchId);
    }

    return visibleUsers;
  }
}

 */

/*
// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:math' as math;
import 'dart:developer';
import 'package:amacle_studio_app/pages/chat_profile_list.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:uuid/uuid.dart';
import '../comps/styles.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../comps/widgets.dart';
import '../global/globals.dart';
import '../utils/constant.dart';
import '../utils/storage/check_permissions.dart';
import '../utils/storage/directory_path.dart';
import 'audio_controller.dart';
import 'bottom_bar_pages/chat_profile_details.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    super.key,
    required this.doc,
    required this.chatRoomId,
  });

  final DocumentSnapshot doc;
  final String chatRoomId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  GlobalKey _popupMenuKey = GlobalKey();

  Future getImage(bool gallery) async {
    ImagePicker _picker = ImagePicker();

    await _picker
        .pickImage(source: gallery ? ImageSource.gallery : ImageSource.camera)
        .then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  final firestore = FirebaseFirestore.instance;

  AudioController audioController = Get.put(AudioController());

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    FieldValue time = FieldValue.serverTimestamp();

    var ref = FirebaseStorage.instance
        .ref()
        .child('chatimages')
        .child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      print(imageUrl);
      updateMyUserList("img", imageUrl, time, fileName);
    }
  }

  AudioPlayer audioPlayer = AudioPlayer();

  String audioURL = "";

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    setState(() {
      recording = true;
      print("doing");
    });
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {
          recording = true;
        });
      });
    } else {}
    setState(() {
      print("what");
    });
  }

  bool recording = false;

  late String recordFilePath;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath =
        "${storageDirectory.path}/record${DateTime.now().microsecondsSinceEpoch}.acc";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  int i = 0;

  void stopRecord() async {
    setState(() {
      recording = false;
      print("sdjkdjkdj");
    });
    bool stop = RecordMp3.instance.stop();
    audioController.end.value = DateTime.now();
    audioController.calcDuration();
    var ap = AudioPlayer();
    // await ap.play(AssetSource("Notification.mp3"));
    // ap.onPlayerComplete.listen((a) {});

    if (stop) {
      audioController.isRecording.value = false;
      audioController.isSending.value = true;
      await uploadAudio(File(recordFilePath));
    }
  }

  uploadAudio(File audioFile) async {
    String fileName = Uuid().v1();
    int status = 1;

    FieldValue time = FieldValue.serverTimestamp();

    var ref = FirebaseStorage.instance
        .ref()
        .child('chataudios')
        .child("$fileName.wav");

    var uploadTask = await ref.putFile(audioFile).catchError((error) async {
      status = 0;
    });

    if (status == 1) {
      String audioUrl = await uploadTask.ref.getDownloadURL();

      updateMyUserList("audio", audioUrl, time, fileName);
    }
  }

  void onSendMessage() async {
    FieldValue time = FieldValue.serverTimestamp();

    if (_message.text.isNotEmpty) {
      updateMyUserList("text", _message.text, time, _message.text);
      _message.clear();
    } else {
      print("Enter Some Text");
    }
  }

  File? imageFile;

  getDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx'
      ], // Add more file extensions as needed
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      uploadDocument(file);
    } else {
      Fluttertoast.showToast(
        msg: "Document not selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  // final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  //  @override
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
  // void didPop() {
  //   // Handle the refresh logic when exiting the current page
  //   refreshPreviousPage();
  // }

  // void refreshPreviousPage() {
  //   final previousRoute = routeObserver.previousRoute?.settings.name;
  //   if (previousRoute == '/') {
  //     // Refresh the previous page
  //     routeObserver.navigator?.currentState?.pop(true);
  //   }
  // }

  Future uploadDocument(PlatformFile documentFile) async {
    String fileName = Uuid().v1();
    int status = 1;

    FieldValue time = FieldValue.serverTimestamp();

    var ref = FirebaseStorage.instance
        .ref()
        .child('chatdocuments')
        .child("$fileName.${documentFile.extension}");

    var uploadTask =
        await ref.putFile(File(documentFile.path!)).catchError((error) async {
      status = 0;
    });

    if (status == 1) {
      String documentUrl = await uploadTask.ref.getDownloadURL();

      updateMyUserList("document", documentUrl, time, fileName);
    }
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

  bool isPermission = false;
  var checkAllPermissions = CheckPermission();

  checkPermissionforStorage() async {
    bool permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  checkFileExist() async {
    var storePath = await getPathFile.getPath();
    filePath = "$filePath/$fileName";
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  startDownload(String fileUrl) async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(fileUrl, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = math.Random();
  final results = StringBuffer();

  generate() {
    for (int i = 0; i < 15; i++) {
      results.write(chars[random.nextInt(chars.length)]);
    }
  }

  updateMyUserList(
    String type,
    String message,
    FieldValue time,
    String fileName,
  ) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    String result = results.toString();
    print(result);
    results.clear();
    generate();

    await Future.delayed(Duration(milliseconds: 400), () async {
      log(result.toString());
      CollectionReference myUsersForSender = FirebaseFirestore.instance
          .collection('users')
          .doc(Global.id.toString())
          .collection("my_chats");

      DocumentReference userDocumentRef =
          myUsersForSender.doc((widget.doc["id"]).toString());

      Map<String, dynamic> userMap = {
        "search_id": widget.doc["id"],
        "last_time": time,
        "date": formattedDate,
        "time": formattedTime,
        "type": type,
        "doc_id": result.toString(),
        "fileName": fileName,
        "seen_by_other": "no",
        "message": message,
        "sender_id": Global.id,
        "sendby": Global.mainMap[0]["name"],
        "to_id": widget.doc["id"],
        "status": "sent",
        "seen": "yes",
      };

      batch.set(
          userDocumentRef.collection("chats").doc(result.toString()), userMap);

      DocumentSnapshot userdocSnapshot =
          await myUsersForSender.doc(widget.doc["id"].toString()).get();

      if (!userdocSnapshot.exists) {
        myUsersForSender
            .doc(widget.doc["id"].toString())
            .set({"dummy": "dummy"});
      } else {
        print("exists1");
      }
      // batch.set(userDocumentRef, userMap);

      CollectionReference myUsersForReceiver = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.doc["id"].toString())
          .collection("my_chats");

      DocumentReference receiverDocumentRef =
          myUsersForReceiver.doc((Global.id).toString());

      Map<String, dynamic> receiverMap = {
        "search_id": Global.id,
        "last_time": time,
        "date": formattedDate,
        "time": formattedTime,
        "type": type,
        "fileName": fileName,
        "seen_by_other": "yes",
        "message": message,
        "doc_id": result.toString(),
        "sender_id": Global.id,
        "sendby": Global.mainMap[0]["name"],
        "to_id": widget.doc["id"],
        "status": "received",
        "seen": "no",
      };

      batch.set(receiverDocumentRef.collection("chats").doc(result.toString()),
          receiverMap);
      // batch.set(receiverDocumentRef, receiverMap);

      DocumentSnapshot otherdocSnapshot = await myUsersForReceiver
          .doc(Global.mainMap[0]["id"].toString())
          .get();

      if (!otherdocSnapshot.exists) {
        myUsersForReceiver
            .doc(Global.mainMap[0]["id"].toString())
            .set({"dummy": "dummy"});
      } else {
        print("exists2");
      }

      // Commit the batch operation
      return batch.commit();
    });
  }

  /*updateMyUserList(
      String type, String message, FieldValue time, String fileName) {
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    String result = results.toString();
    print(result);
    results.clear();
    generate();
    Future.delayed(Duration(milliseconds: 400), () {
      log(result.toString());
      CollectionReference myUsersForSender = firestore
          .collection('users')
          .doc(Global.id.toString())
          .collection("my_chats");

      DocumentReference userDocumentRef =
          myUsersForSender.doc((widget.doc["id"]).toString());

      Map<String, dynamic> userMap = {
        "search_id": widget.doc["id"],
        "last_time": time,
        "date": formattedDate,
        "time": formattedTime,
        "type": type,
        "doc_id": result.toString(),
        "fileName": fileName,
        "seen_by_other": "no",
        "message": message,
        "sender_id": Global.id,
        "sendby": Global.mainMap[0]["name"],
        "to_id": widget.doc["id"],
        "status": "sent",
        "seen": "yes",
      };

      userDocumentRef.collection("chats").doc(result.toString()).set(userMap);

      userDocumentRef.set(userMap);

      CollectionReference myUsersForReviever = firestore
          .collection('users')
          .doc(widget.doc["id"].toString())
          .collection("my_chats");

      DocumentReference receiverDocumentRef =
          myUsersForReviever.doc((Global.id).toString());

      Map<String, dynamic> receiverMap = {
        "search_id": Global.id,
        "last_time": time,
        "date": formattedDate,
        "time": formattedTime,
        "type": type,
        "fileName": fileName,
        "seen_by_other": "yes",
        "message": message,
        "doc_id": result.toString(),
        "sender_id": Global.id,
        "sendby": Global.mainMap[0]["name"],
        "to_id": widget.doc["id"],
        "status": "recieved",
        "seen": "no",
      };

      receiverDocumentRef
          .collection("chats")
          .doc(result.toString())
          .set(receiverMap);

      receiverDocumentRef.set(receiverMap);
    });
  }*/

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  @override
  void initState() {
    generate();
    markAsRead();
    scrollDown();
    scrollController.addListener(scrollListener);
    super.initState();
    checkPermissionforStorage();
  }

  int messageCount = 30;

  @override
  void dispose() {
    scrollController.dispose();
    markAsRead();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.position.pixels == 0) {
      setState(() {
        messageCount += 5;
      });
    }
  }

  ScrollController scrollController = ScrollController();

  scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  markAsRead() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // User side
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(Global.id.toString())
        .collection("my_chats")
        .doc(widget.doc["id"].toString())
        .collection("chats")
        .where("seen", isEqualTo: "no")
        .get();
    log("A" + userSnapshot.docs.length.toString());

    if (userSnapshot.docs.isEmpty) {
      print('No documents to update.');
    } else {
      userSnapshot.docs.forEach((doc) {
        batch.update(doc.reference, {'seen': 'yes'});
      });
    }

    // Update the "seen" field in the userDoc
    // DocumentReference userDoc = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(Global.id.toString())
    //     .collection("my_chats")
    //     .doc(widget.doc["id"].toString());

    // DocumentSnapshot userDocSnapshot = await userDoc.get();

    // if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
    //   Map<String, dynamic> data =
    //       userDocSnapshot.data() as Map<String, dynamic>;
    //   if (data['seen'] == 'no') {
    //     batch.update(userDoc, {'seen': 'yes'});
    //     print('Update completed successfully. 1');
    //   } else {
    //     print('Field "seen" is not "no", no update performed.');
    //   }
    // } else {
    //   print('Document does not exist or has no data.');
    // }

    // Other side
    QuerySnapshot otherSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doc["id"].toString())
        .collection("my_chats")
        .doc(Global.id.toString())
        .collection("chats")
        .where("seen_by_other", isEqualTo: "no")
        .get();

    log("B" + otherSnapshot.docs.length.toString());
    if (otherSnapshot.docs.isEmpty) {
      print('No documents to update.');
    } else {
      otherSnapshot.docs.forEach((doc) {
        batch.update(doc.reference, {"seen_by_other": "yes"});
      });
    }

    // Update the "seen_by_other" field in the otherDoc
    // DocumentReference otherDoc = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.doc["id"].toString())
    //     .collection("my_chats")
    //     .doc(Global.id.toString());

    // DocumentSnapshot otherDocSnapshot = await otherDoc.get();

    // if (otherDocSnapshot.exists && otherDocSnapshot.data() != null) {
    //   Map<String, dynamic> data =
    //       otherDocSnapshot.data() as Map<String, dynamic>;
    //   if (data['seen_by_other'] == 'no') {
    //     batch.update(otherDoc, {'seen_by_other': 'yes'});
    //     print('Update completed successfully. 2');
    //   } else {
    //     print('Field "seen by other" is not "no", no update performed.');
    //   }
    // } else {
    //   print('Document does not exist or has no data.');
    // }

    // Commit the batch
    batch.commit();
  }

  openfile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }

  bool downloading = false;
  bool fileExists = false;
  double progress = 0;
  late String filePath;
  bool dowloading = false;
  String fileName = "";
  late CancelToken cancelToken;
  DirectoryPath getPathFile = DirectoryPath();

  bool scrolledDown = false;

  @override
  final TextEditingController _message = TextEditingController();

  // final FirebaseFirestore _firestore = firestore;

  Widget build(BuildContext context) {
    // AuthController.instance.logout();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 242, 242),
      appBar: AppBar(
        actions: [
          Container(
            padding: EdgeInsets.only(right: 7),
            child: CircleAvatar(
              maxRadius: width(context) * 0.055,
              backgroundColor: Color(0xFFB4DBFF),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  width: width(context) * 0.11,
                  height: width(context) * 0.11,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.doc["pic"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
        backgroundColor: btnColor,
        title: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.doc['name'] + ""),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            addVerticalSpace(10),
            Container(
              padding: EdgeInsets.only(left: 2),
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('users')
                    .doc(Global.id.toString())
                    .collection('my_chats')
                    .doc(widget.doc["id"].toString())
                    .collection("chats")
                    .orderBy("last_time", descending: false)
                    .limit(messageCount)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    // markAsRead();
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    log(documents.length.toString());
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        try {
                          if (index == snapshot.data!.docs.length - 1) {
                            scrolledDown = true;
                          }
                          return messages(
                              size,
                              map,
                              context,
                              index,
                              snapshot.data!.docs[index].id,
                              documents,
                              index == documents.length - 1);
                        } on Exception catch (e) {
                          // Handling the specific exception type
                          print('Caught exception: $e');
                        } catch (e) {
                          // Handling any other exception type
                          print('Caught unknown exception: $e');
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 11,
              width: size.width,
              alignment: Alignment.centerLeft,
              child: Container(
                height: size.height / 10,
                width: size.width / 1.0,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addHorizontalySpace(width(context) * 0.03),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        addVerticalSpace(height(context) * 0.014),
                        GestureDetector(
                          onTap: () {
                            final RenderBox popupMenuButtonRenderBox =
                                _popupMenuKey.currentContext!.findRenderObject()
                                    as RenderBox;
                            final popupMenuButtonSize =
                                popupMenuButtonRenderBox.size;
                            final popupMenuButtonPosition =
                                popupMenuButtonRenderBox
                                    .localToGlobal(Offset.zero);
                            final overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;
                            final overlaySize = overlay.size;
                            final overlayPosition =
                                overlay.localToGlobal(Offset.zero);

                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                popupMenuButtonPosition.dx,
                                popupMenuButtonPosition.dy -
                                    overlayPosition.dy +
                                    popupMenuButtonSize.height,
                                overlaySize.width -
                                    popupMenuButtonPosition.dx -
                                    popupMenuButtonSize.width,
                                overlaySize.height -
                                    (popupMenuButtonPosition.dy -
                                        overlayPosition.dy),
                              ),
                              items: [
                                PopupMenuItem<IconData>(
                                  value: Typicons.doc,
                                  onTap: () {
                                    getDocument();
                                  },
                                  child: Icon(
                                    Typicons.doc,
                                    color: btnColor,
                                  ),
                                ),
                                PopupMenuItem<IconData>(
                                  value: CupertinoIcons.person_solid,
                                  onTap: () {
                                    print("jmdd");
                                    // goBack(context);
                                    Future.delayed(Duration(seconds: 1), () {
                                      Get.to(() => ChatProfileList(
                                          currentlyChattingWith: widget.doc));
                                    });
                                  },
                                  child: Icon(
                                    CupertinoIcons.person_solid,
                                    color: btnColor,
                                  ),
                                ),
                                PopupMenuItem<IconData>(
                                  value: Icons.camera,
                                  child: Icon(
                                    Icons.camera,
                                    color: btnColor,
                                  ),
                                ),
                              ],
                              elevation: 8,
                            ).then((selectedValue) {
                              if (selectedValue == Icons.camera) {
                                // Handle icon selection
                                getImage(false);
                              }
                            });
                          },
                          key: _popupMenuKey,
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                    addHorizontalySpace(width(context) * 0.02),
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.58,
                      child: TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.left,
                        controller: _message,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => getImage(true),
                              icon: Icon(
                                Icons.photo,
                                color: btnColor,
                              ),
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                      onPressed: () => recording ? stopRecord() : startRecord(),
                      icon: Icon(
                        Icons.mic,
                        color: !recording ? btnColor : Colors.red,
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 19,
                        ),
                        onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context,
      int index, String docId, List<DocumentSnapshot> documents, bool last) {
    if (!scrolledDown) {
      scrollDown();
    }
    return GestureDetector(
        onLongPress: () {
          if (true) {
            final RenderBox popupMenuButtonRenderBox =
                _popupMenuKey.currentContext!.findRenderObject() as RenderBox;
            final popupMenuButtonSize = popupMenuButtonRenderBox.size;
            final popupMenuButtonPosition =
                popupMenuButtonRenderBox.localToGlobal(Offset.zero);
            final overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final overlaySize = overlay.size;
            final overlayPosition = overlay.localToGlobal(Offset.zero);

            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                popupMenuButtonPosition.dx,
                popupMenuButtonPosition.dy -
                    overlayPosition.dy +
                    popupMenuButtonSize.height,
                overlaySize.width -
                    popupMenuButtonPosition.dx -
                    popupMenuButtonSize.width,
                overlaySize.height -
                    (popupMenuButtonPosition.dy - overlayPosition.dy),
              ),
              items: [
                PopupMenuItem(
                  value: Icons.delete,
                  child: InkWell(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.delete,
                        color: btnColor,
                      ),
                      title: Text("Delete"),
                    ),
                  ),
                ),
                if (map["sender_id"] == Global.id)
                  PopupMenuItem(
                    value: Icons.delete_sweep,
                    child: InkWell(
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_sweep,
                          color: btnColor,
                        ),
                        title: Text("Delete for everyone"),
                      ),
                    ),
                  ),
              ],
              elevation: 8,
            ).then((selectedValue) async {
              if (selectedValue == Icons.delete) {
                deleteForMe(size, map, context, index, docId, documents, last);
              } else if (selectedValue == Icons.delete_sweep) {
                deleteForMe(size, map, context, index, docId, documents, last);
                deleteForEveryOne(
                    size, map, context, index, docId, documents, last);
              }
            });
          }
        },
        child: Container(
            child: messagesNext(size, map, context, index, documents, last)));
  }

  Widget bottomBar(String formattedTime, Map<String, dynamic> map) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formattedTime,
          style: TextStyle(
            fontSize: 8.5,
            fontWeight: FontWeight.w800,
            color: (map["sender_id"] == Global.id) ? white : black,
          ),
        ),
        addHorizontalySpace(width(context) * 0.03),
        Visibility(
          visible: map["sender_id"] == Global.id,
          child: Icon(
            map["seen_by_other"] == "yes" ? Icons.done_all : Icons.done,
            color: (map["sender_id"] == Global.id) ? white : black,
            size: 17,
          ),
        )
      ],
    );
  }

  Widget topBar(Map<String, dynamic> map) {
    return Text(
      DateFormat('d MMMM y').format(
          DateTime.parse(map["last_time"].toDate().toString().split(' ')[0])),
      style: TextStyle(
        fontSize: 8.5,
        fontWeight: FontWeight.w800,
        color: (map["sender_id"] == Global.id) ? white : black,
      ),
    );
  }

  Widget messagesNext(Size size, Map<String, dynamic> map, BuildContext context,
      int index, List<DocumentSnapshot> documents, bool last) {
    Timestamp firestoreTimestamp = map["last_time"];
    DateTime dateTime = firestoreTimestamp.toDate();
    String formattedTime = DateFormat('h:mm a').format(dateTime);

    if (map['type'] == "text") {
      return Container(
        width: size.width,
        alignment: (map["sender_id"] == Global.id)
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: (map["sender_id"] == Global.id) ? btnColor : white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topBar(map),
              Text(
                map['message'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color:
                      !((map["sender_id"] == Global.id)) ? black : Colors.white,
                ),
              ),
              bottomBar(formattedTime, map),
            ],
          ),
        ),
      );
    } else {
      if (map['type'] == "img" || map['type'] == "task_img") {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: size.height / 2.21,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: (map["sender_id"] == Global.id)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: (map["sender_id"] == Global.id) ? btnColor : white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topBar(map),
                    addVerticalSpace(height(context) * 0.004),
                    Container(
                      height: size.height / 2.67,
                      // width: size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: map['message'] != "" ? null : Alignment.center,
                      child: map['message'] != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                map['message'],
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircularProgressIndicator(),
                    ),
                    addVerticalSpace(height(context) * 0.004),
                    if (map['type'] == "task_img")
                      Text(
                        map["category"],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color:
                              (map["sender_id"] == Global.id) ? white : black,
                        ),
                      ),
                    addVerticalSpace(height(context) * 0.004),
                    bottomBar(formattedTime, map),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (map['type'] == "document") {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: (map["sender_id"] == Global.id)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: (map["sender_id"] == Global.id) ? btnColor : white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: GestureDetector(
                onTap: () async {
                  // if (map["message"] != "x") {
                  //   if (await canLaunchUrl(Uri.parse(map["message"]))) {
                  //     await launchUrl(Uri.parse(map["message"]),
                  //         mode: LaunchMode.externalApplication);
                  //   }
                  // }
                  openFile(map["message"], "File");
                  // nextScreen(context, ShowDoc(url: map["message"]));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topBar(map),
                    addVerticalSpace(height(context) * 0.004),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: map['message'] != "" ? null : Alignment.center,
                      child: map['message'] != ""
                          ? Image.asset("assets/document.png",
                              fit: BoxFit.cover)
                          : CircularProgressIndicator(),
                    ),
                    addVerticalSpace(height(context) * 0.004),
                    bottomBar(formattedTime, map),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (map['type'] == "contact") {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: size.width * 0.6,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: (map["sender_id"] == Global.id)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("users")
                    .where("id", isEqualTo: map["id"])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    return Container(
                      width: width(context) * 0.6,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color:
                            (map["sender_id"] == Global.id) ? btnColor : white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          log(documents[0].data().toString());

                          nextScreen(
                              context,
                              ChatProfileDetails(
                                doc: documents[0],
                                view: false,
                                share: false,
                                chattingWithUser: null,
                              ));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            topBar(map),
                            addVerticalSpace(height(context) * 0.004),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: map['message'] != ""
                                  ? null
                                  : Alignment.center,
                              child: map['id'] > 0
                                  ? Container(
                                      width: width(context) * 0.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            maxRadius: width(context) * 0.065,
                                            backgroundColor: Color(0xFFB4DBFF),
                                            // backgroundColor: Colors.transparent,
                                            child: Center(
                                              child: Icon(
                                                Icons.person,
                                                size: width(context) * 0.11,
                                                color: Color(0xFFEAF2FF),
                                              ),
                                            ),
                                          ),
                                          addHorizontalySpace(8),
                                          Text(
                                            documents[0]["name"]!,
                                            style: TextStyle(
                                                color: map['sendby'] ==
                                                        Global.mainMap[0]
                                                            ["name"]
                                                    ? white
                                                    : black,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    )
                                  : CircularProgressIndicator(),
                            ),
                            addVerticalSpace(height(context) * 0.004),
                            bottomBar(formattedTime, map),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: 20,
                      height: 20,
                      color: Colors.transparent,
                    );
                  }
                }),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: size.height / 2.21,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: (map["sender_id"] == Global.id)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: (map["sender_id"] == Global.id) ? btnColor : white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topBar(map),
                  addVerticalSpace(height(context) * 0.004),
                  Container(
                    // height: size.height / 2.67,
                    // width: size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(),
                      //   boxShadow: [
                      //     BoxShadow(
                      //       blurRadius: 2,
                      //       color: Colors.black38,
                      //       offset: Offset(1, 2),
                      //     ),
                      //   ],
                    ),
                    alignment: map['message'] != "" ? null : Alignment.center,
                    child: map['message'] != ""
                        ? _audio(
                            message: map["message"],
                            index: index,
                            isCurrentUser: (map["sender_id"] == Global.id))
                        : CircularProgressIndicator(),
                  ),
                  addVerticalSpace(height(context) * 0.004),
                  bottomBar(formattedTime, map),
                ],
              ),
            ),
          ),
        );
      }
    }
  }

  Widget _audio({
    required String message,
    required bool isCurrentUser,
    required int index,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentUser ? btnColor : btnColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              audioController.onPressedPlayButton(index, message);
              // changeProg(duration: duration);
            },
            onSecondaryTap: () {
              audioPlayer.stop();
              //   audioController.completedPercentage.value = 0.0;
            },
            child: Obx(
              () => (audioController.isRecordPlaying &&
                      audioController.currentId == index)
                  ? Icon(
                      Icons.cancel,
                      color: isCurrentUser ? Colors.white : btnColor,
                    )
                  : Icon(
                      Icons.play_arrow,
                      color: isCurrentUser ? Colors.white : btnColor,
                    ),
            ),
          ),
          Obx(
            () => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Text(audioController.completedPercentage.value.toString(),style: TextStyle(color: Colors.white),),
                    LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCurrentUser ? Colors.white : btnColor,
                      ),
                      value: (audioController.isRecordPlaying &&
                              audioController.currentId == index)
                          ? audioController.completedPercentage.value
                          : audioController.totalDuration.value.toDouble(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  deleteForMe(
      Size size,
      Map<String, dynamic> map,
      BuildContext context,
      int index,
      String docId,
      List<DocumentSnapshot> documents,
      bool last) async {
    Map<String, dynamic> myMap = {};
    if (documents.length > 1) {
      myMap = documents[documents.length - 2].data() as Map<String, dynamic>;
    }
    await firestore
        .collection('users')
        .doc(Global.id.toString())
        .collection('my_chats')
        .doc(widget.doc["id"].toString())
        .collection("chats")
        .doc(docId)
        .delete()
        .then((value) {
      print("Message deleted for me");
      CollectionReference myUsersForSender = firestore
          .collection('users')
          .doc(Global.id.toString())
          .collection("my_chats");

      DocumentReference userDocumentRef =
          myUsersForSender.doc((widget.doc["id"]).toString());

      if (last) {
        if (documents.length > 1) {
          userDocumentRef.set(myMap);
        } else {
          myUsersForSender.doc((widget.doc["id"]).toString()).delete();
        }
      }
    }).catchError((err) {
      Fluttertoast.showToast(
        msg: "Message already deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    });
  }

  deleteForEveryOne(
      Size size,
      Map<String, dynamic> map,
      BuildContext context,
      int index,
      String docId,
      List<DocumentSnapshot> documents,
      bool last) async {
    await deleteForMe(size, map, context, index, docId, documents, last);

    firestore
        .collection("users")
        .doc(widget.doc["id"].toString())
        .collection("my_chats")
        .doc(Global.id.toString())
        .collection("chats")
        .orderBy("last_time", descending: true)
        .limitToLast(2)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> list = [];
        for (QueryDocumentSnapshot document in snapshot.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          list.add(data);
          // print(otherLast.toString() + "  " + data.toString());
        }
        bool otherLast = list[0]["doc_id"] == docId;
        print(otherLast);
        if (list.length != 0) {
          firestore
              .collection('users')
              .doc(widget.doc["id"].toString())
              .collection("my_chats")
              .doc(Global.id.toString())
              .collection("chats")
              .doc(docId)
              .delete()
              .then((value) {
            print("Message deleted for everyone");
            CollectionReference myUsersForSender = firestore
                .collection('users')
                .doc(widget.doc["id"].toString())
                .collection("my_chats");

            DocumentReference userDocumentRef =
                myUsersForSender.doc(Global.id.toString());

            if (otherLast) {
              if (list.length > 1) {
                userDocumentRef.set(list[1]);
              } else {
                myUsersForSender.doc(Global.id.toString()).delete();
              }
            }
          }).catchError((err) {
            Fluttertoast.showToast(
              msg: "Message already deleted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
            );
          });
        }
      } else {
        print("No matching documents.");
      }
    });
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}

class ShowDoc extends StatelessWidget {
  final String url;

  const ShowDoc({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    late WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      body: Center(
        child: WebViewWidget(
          controller: webViewController,
        ),
      ),
    );
  }
}

 */