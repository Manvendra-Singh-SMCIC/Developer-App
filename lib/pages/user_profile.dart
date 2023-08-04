// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:amacle_studio_app/authentication/auth_controller.dart';
import 'package:amacle_studio_app/global/globals.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';

import '../utils/widgets.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<TextEditingController> controllers =
      List.generate(5, (index) => TextEditingController());
  bool wantToEdit = false;

  ImagePicker picker = ImagePicker();
  File? image;

  Future<File> convertImageUrlToFile(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    var filePath =
        await _localPath(); // Function to get the local directory path
    var fileName = imageUrl.split('/').last;

    File file = File('$filePath/$fileName');
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  Future<String> _localPath() async {
    // Function to get the local directory path
    var directory = await getTemporaryDirectory();
    return directory.path;
  }

  save() async {
    image ??= await convertImageUrlToFile(Global.mainMap[0]["pic"]);
    if (controllers[0].text.trim().isNotEmpty &&
        controllers[1].text.trim().isNotEmpty &&
        controllers[2].text.trim().isNotEmpty &&
        controllers[3].text.trim().isNotEmpty) {
      String folderPath = 'images/';
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          image!.path.split('/').last;

      List<int>? compressedImage = await FlutterImageCompress.compressWithFile(
        image!.path,
        quality: 30,
      );

      if (compressedImage != null) {
        log("compressed");
        Uint8List compressedData = Uint8List.fromList(compressedImage);
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child(folderPath + fileName);
        UploadTask uploadTask = ref.putData(compressedData);

        TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});

        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

        log(downloadUrl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(Global.id.toString())
            .update({
          "name": controllers[0].text.trim(),
          "phno": "+91${controllers[1].text.trim()}",
          "city": controllers[2].text.trim(),
          "state": controllers[3].text.trim(),
          "pic": downloadUrl,
        }).then((value) {
          print("Updated");
          Get.back();
        }).catchError((onError) {
          Fluttertoast.showToast(
            msg: "Some error occured. Try again later.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
        });
      } else {
        Fluttertoast.showToast(
          msg: "All fields are required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    }
  }

  @override
  void initState() {
    controllers[0].text = Global.mainMap[0]["name"];
    controllers[1].text = Global.mainMap[0]["phno"].toString().substring(3);
    controllers[2].text = Global.mainMap[0]["city"];
    controllers[3].text = Global.mainMap[0]["state"];
    doit();
    super.initState();
  }

  doit() async {
    await convertImageUrlToFile(Global.mainMap[0]["pic"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: width(context),
                      height: height(context) * 0.25,
                      color: Color(0xff355BC0),
                    ),
                    Container(
                      width: width(context),
                      height: height(context) * 0.75,
                      child: Column(
                        children: <Widget>[
                          addVerticalSpace(height(context) * 0.09),
                          Center(
                            child: SizedBox(
                              width: width(context) * 0.87,
                              height: width(context) * 0.18,
                              child: TextFormField(
                                onChanged: (value) {},
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                enabled: wantToEdit,
                                controller: controllers[1],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelStyle: TextStyle(
                                    color: wantToEdit ? Colors.blue : null,
                                  ),
                                  counterText: "",
                                  labelText: 'Phone Number',
                                  hintText: "Phone Number",
                                  floatingLabelBehavior:
                                      controllers[1].text.isEmpty
                                          ? FloatingLabelBehavior.never
                                          : FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          addVerticalSpace(height(context) * 0.03),
                          Center(
                            child: SizedBox(
                              width: width(context) * 0.87,
                              height: width(context) * 0.18,
                              child: TextField(
                                onChanged: (value) {},
                                enabled: wantToEdit,
                                controller: controllers[2],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelStyle: TextStyle(
                                    color: wantToEdit ? Colors.blue : null,
                                  ),
                                  labelText: 'City',
                                  hintText: "City",
                                  floatingLabelBehavior:
                                      controllers[2].text.isEmpty
                                          ? FloatingLabelBehavior.never
                                          : FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          addVerticalSpace(height(context) * 0.03),
                          Center(
                            child: SizedBox(
                              width: width(context) * 0.87,
                              height: width(context) * 0.18,
                              child: TextField(
                                onChanged: (value) {},
                                enabled: wantToEdit,
                                controller: controllers[3],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelStyle: TextStyle(
                                    color: wantToEdit ? Colors.blue : null,
                                  ),
                                  labelText: 'State',
                                  hintText: "State",
                                  floatingLabelBehavior:
                                      controllers[3].text.isEmpty
                                          ? FloatingLabelBehavior.never
                                          : FloatingLabelBehavior.always,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          addVerticalSpace(height(context) * 0.02),
                          SizedBox(
                            width: width(context) * 0.87,
                            child: Row(
                              children: [
                                AppText(
                                  text: "ID: ${Global.mainMap[0]["id"]}",
                                  color: black,
                                  fontWeight: FontWeight.w800,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                          Global.mainMap[0]["role"] == 'developer'
                              ? Visibility(
                                  visible:
                                      Global.mainMap[0]["role"] == 'developer',
                                  child: Row(
                                    children: [
                                      addHorizontalySpace(10),
                                      Visibility(
                                        visible: Global.mainMap[0]["role"] ==
                                            'developer',
                                        child: SizedBox(
                                          width: 40,
                                          height: 50,
                                          child: Image.asset(
                                            Global.mainMap[0]["badge_score"] <=
                                                    50
                                                ? "assets/badge_bronze.png"
                                                : Global.mainMap[0]
                                                            ["badge_score"] <=
                                                        70
                                                    ? "assets/badge_silver.png"
                                                    : "assets/badge_gold.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      addHorizontalySpace(20),
                                      AppText(
                                        text:
                                            "Level: ${Global.mainMap[0]["level"]}",
                                        color: black,
                                        size: 17,
                                        fontWeight: FontWeight.w700,
                                      )
                                    ],
                                  ),
                                )
                              : Container(width: 0, height: 0),
                          addVerticalSpace(height(context) * 0.08),
                          wantToEdit
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: width(context) * 0.87,
                                    height: height(context) * 0.075,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(btnColor),
                                      ),
                                      onPressed: () {
                                        convertImageUrlToFile(
                                            Global.mainMap[0]["pic"]);
                                        save();
                                      },
                                      child: Center(
                                        child: AppText(
                                          text: "Save",
                                          color: white,
                                          fontWeight: FontWeight.w600,
                                          size: width(context) * 0.05,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    AuthController.instance.logout();
                                  },
                                  child: Container(
                                    width: width(context) * 0.87,
                                    height: height(context) * 0.075,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red,
                                      ),
                                    ),
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.logout_rounded,
                                          color: Colors.red,
                                        ),
                                        addHorizontalySpace(
                                            width(context) * 0.02),
                                        AppText(
                                          text: "Logout",
                                          color: Colors.red,
                                          size: 17,
                                          fontWeight: FontWeight.w400,
                                        )
                                      ],
                                    )),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: height(context) * 0.16,
                  left: width(context) * 0.05,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        maxRadius: width(context) * 0.15,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(width(context) * 0.2),
                          child: SizedBox(
                            width: width(context) * 0.3,
                            height: width(context) * 0.3,
                            child: InkWell(
                              onTap: () async {
                                if (wantToEdit) {
                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 80,
                                  );

                                  if (pickedFile != null) {
                                    image = File(pickedFile.path);
                                    setState(() {});
                                  } else {
                                    setState(() {});
                                    print("No image selected");
                                  }
                                }
                              },
                              child: image == null
                                  ? imageNetwork(
                                      Global.mainMap[0]["pic"],
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      image!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !wantToEdit,
                        child: Positioned(
                          left: width(context) * 0.2,
                          bottom: height(context) * 0.001,
                          child: CircleAvatar(
                            backgroundColor: white,
                            maxRadius: width(context) * 0.05,
                            child: CircleAvatar(
                              backgroundColor: btnColor,
                              maxRadius: width(context) * 0.043,
                              child: IconButton(
                                icon: Icon(
                                  Typicons.pencil,
                                  color: white,
                                  size: 12,
                                ),
                                onPressed: () {
                                  setState(() {
                                    wantToEdit = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                !wantToEdit
                    ? Positioned(
                        top: height(context) * 0.19,
                        left: width(context) * 0.40,
                        child: SizedBox(
                          width: width(context),
                          height: height(context) * 0.05,
                          child: AppText(
                            text: Global.mainMap[0]["name"],
                            color: white,
                            size: width(context) * 0.06,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    : Positioned(
                        top: height(context) * 0.175,
                        right: width(context) * 0.05,
                        child: SizedBox(
                          width: width(context) * 0.55,
                          height: height(context) * 0.05,
                          child: TextField(
                            controller: controllers[0],
                            style: TextStyle(
                                color: white, fontWeight: FontWeight.w700),
                            cursorColor: white,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
