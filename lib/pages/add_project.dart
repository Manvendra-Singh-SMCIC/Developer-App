// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:amacle_studio_app/global/globals.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../utils/app_text.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  TextEditingController companycontroller = TextEditingController();
  TextEditingController clientcontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desccontroller = TextEditingController();
  TextEditingController datecontroller = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? image;

  bool loading = false;

  List<String> tags = [
    "Figma",
    "Firebase",
    "Flutter",
    "App",
    "Web",
    "Java",
    "Kotlin",
    "Android",
    "Front-end",
    "Back-end",
    "Gaming",
    "Android Studio",
    "API(s)",
    "Node.js",
    "React.js",
    "PHP",
    "Laravel",
    "HTML/CSS"
  ];

  List<int> selIndex = [];
  List<String> selTags = [];

  DateTime? selectedDate;
  bool dateSelected = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dateSelected = true;
      selectedDate = pickedDate;
      datecontroller.text = DateFormat('dd MMM yyyy').format(selectedDate!);
      print(datecontroller.text);
      setState(() {});
    }
  }

  bool done = false;

  @override
  Widget build(BuildContext context) {
    done = false;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: loading,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addVerticalSpace(20),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 23),
                  child: Text(
                    "Enter project details",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                addVerticalSpace(20),
                Center(
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.18,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: companycontroller,
                      decoration: InputDecoration(
                        labelText: 'Company Name',
                        hintText: "Company Name",
                        floatingLabelBehavior: companycontroller.text.isEmpty
                            ? FloatingLabelBehavior.never
                            : FloatingLabelBehavior.always,
                        // suffixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(20),
                Center(
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.18,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: clientcontroller,
                      decoration: InputDecoration(
                        labelText: 'Client ID',
                        hintText: "Client ID",
                        floatingLabelBehavior: clientcontroller.text.isEmpty
                            ? FloatingLabelBehavior.never
                            : FloatingLabelBehavior.always,
                        // suffixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(20),
                Center(
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.18,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: pricecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: "Amount",
                        floatingLabelBehavior: pricecontroller.text.isEmpty
                            ? FloatingLabelBehavior.never
                            : FloatingLabelBehavior.always,
                        // suffixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(20),
                Center(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20),
                    dashPattern: [5, 5],
                    color: Colors.grey,
                    strokeWidth: 2,
                    child: Container(
                      height: height(context) * 0.20,
                      width: width(context) * 0.88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
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
                            },
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset(
                                "assets/upload2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          addVerticalSpace(5),
                          InkWell(
                            onTap: () async {
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
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                addHorizontalySpace(40),
                                Text(
                                  "Click to upload",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                addHorizontalySpace(5),
                                IconButton(
                                  onPressed: () {
                                    if (image != null) {
                                      nextScreen(context,
                                          ImageOpener(imageFile: image));
                                    }
                                  },
                                  icon: Icon(Icons.remove_red_eye),
                                  color: image != null
                                      ? themeColor
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                          addVerticalSpace(height(context) * 0.01),
                          AppText(
                            text: "Maximum File Size 50 MB",
                            color: Colors.black38,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(30),
                Center(
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.18,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: titlecontroller,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: "Title",
                        floatingLabelBehavior: titlecontroller.text.isEmpty
                            ? FloatingLabelBehavior.never
                            : FloatingLabelBehavior.always,
                        // suffixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(10),
                Center(
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.48,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: desccontroller,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: "Description",
                        floatingLabelBehavior: desccontroller.text.isEmpty
                            ? FloatingLabelBehavior.never
                            : FloatingLabelBehavior.always,
                        // suffixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Tags",
                        size: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.w800,
                      )
                    ],
                  ),
                ),
                addVerticalSpace(10),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(tags.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (!selIndex.contains(index)) {
                                selIndex.add(index);
                                selTags.add(tags[index]);
                              } else {
                                selIndex.remove(index);
                                selTags.remove(tags[index]);
                              }
                              setState(() {
                                print(selTags);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selIndex.contains(index)
                                      ? themeColor
                                      : Color(0xFF212222).withOpacity(0.6),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    tags[index],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: selIndex.contains(index)
                                          ? themeColor
                                          : Color(0xFF212222),
                                    ),
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
                addVerticalSpace(15),
                Center(
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.18,
                    child: TextField(
                      onTap: () {
                        _selectDate(context);
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: datecontroller,
                      keyboardType: TextInputType.multiline,
                      enabled: true,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Select Deadline',
                        hintText: "Select Deadline",
                        floatingLabelBehavior: datecontroller.text.isEmpty
                            ? FloatingLabelBehavior.never
                            : FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.14,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(btnColor)),
                        onPressed: () async {
                          // print(DateFormat('dd MMM yyyy').format(DateTime.now()));
                          if (companycontroller.text.isNotEmpty &&
                              clientcontroller.text.isNotEmpty &&
                              pricecontroller.text.isNotEmpty &&
                              image != null &&
                              titlecontroller.text.isNotEmpty &&
                              desccontroller.text.isNotEmpty &&
                              selTags.isNotEmpty &&
                              datecontroller.text.isNotEmpty) {
                            CollectionReference newProject = FirebaseFirestore
                                .instance
                                .collection('new_projects');

                            setState(() {
                              loading = true;
                            });

                            String folderPath = 'images/';
                            String fileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString() +
                                '_' +
                                image!.path.split('/').last;

                            List<int>? compressedImage =
                                await FlutterImageCompress.compressWithFile(
                              image!.path,
                              quality: 30, // Adjust the quality as needed
                            );
                            if (compressedImage != null) {
                              Uint8List compressedData =
                                  Uint8List.fromList(compressedImage);
                              FirebaseStorage storage =
                                  FirebaseStorage.instance;
                              Reference ref =
                                  storage.ref().child(folderPath + fileName);
                              UploadTask uploadTask =
                                  ref.putData(compressedData);

                              TaskSnapshot storageTaskSnapshot =
                                  await uploadTask.whenComplete(() => null);

                              String downloadUrl = await storageTaskSnapshot.ref
                                  .getDownloadURL();

                              log(downloadUrl);

                              int count = 0;

                              QuerySnapshot snaps = await newProject
                                  .orderBy('id', descending: true)
                                  .get();

                              if (snaps.docs.isNotEmpty) {
                                DocumentSnapshot document = snaps.docs.first;
                                print('Document ID: ${document.id}');
                                count = int.parse(document.id);
                              } else {
                                count = 0;
                                print('No documents found in the collection.');
                              }

                              DocumentReference documentRef =
                                  newProject.doc((count + 1).toString());
                              done = true;

                              documentRef.set({
                                "id": count + 1,
                                'added': [],
                                'applied': [],
                                'client_id':
                                    int.parse(clientcontroller.text.trim()),
                                "company": companycontroller.text.trim(),
                                'deadline': datecontroller.text.trim(),
                                'desc': desccontroller.text.trim(),
                                'image': downloadUrl,
                                'manager_id': Global.mainMap[0]["id"],
                                'name': titlecontroller.text.trim(),
                                'posted': DateFormat('dd MMM yyyy')
                                    .format(DateTime.now())
                                    .toString(),
                                'price': int.parse(pricecontroller.text.trim()),
                                'tags': selTags,
                              }).then((value) {
                                print('Data added successfully!');
                                Fluttertoast.showToast(
                                  msg: "Project Added",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                );
                                setState(() {
                                  loading = false;
                                });
                                goBack(context);
                              }).catchError((error) {
                                print('Failed to add data: $error');
                              });
                              setState(() {
                                loading = false;
                              });
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "All fields are required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                            );
                          }
                        },
                        child: AppText(text: "Publish"),
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
