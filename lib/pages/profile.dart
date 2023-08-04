// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';

import 'package:amacle_studio_app/authentication/auth_controller.dart';
import 'package:amacle_studio_app/global/globals.dart';
import 'package:amacle_studio_app/global/profile_data.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/home_page.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';
import '../utils/constant.dart';
import '../utils/styles.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.edit});

  final bool edit;
  @override
  State<Profile> createState() => _ProfileState();
}

bool loading = false;

class _ProfileState extends State<Profile> {
  File? image;

  ImagePicker picker = ImagePicker();

  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<String> availibilityStatus = ["Full Time", "Part-time", "Freelance"];
  int selectedStatus = -1;

  List<String> preferedRole = [
    "Front-end\nDeveloper",
    "Back-end\nDeveloper",
    "Full-stack\nDeveloper"
  ];
  int selectedRole = -1;

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

  File? icon;

  Future<File> assetToFile(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  doit() async {
    icon = await assetToFile("assets/Avatar.png");
  }

  bool checkBox = false;

  DateTime? selectedDate;
  bool isAbove18 = false;
  bool dateSelected = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dateSelected = true;
      selectedDate = pickedDate;
      controllers[3].text = DateFormat('dd MMM yyyy').format(selectedDate!);
      print(controllers[3].text);
      isAbove18 = calculateAge(selectedDate!) >= 18;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  gotoNext(BuildContext context) {
    if (done) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    }
  }

  bool check() {
    bool result = true;
    for (TextEditingController controller in controllers) {
      result = result && controller.text.trim().isNotEmpty;
    }
    return result && (image != null);
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  bool done = false;
  @override
  Widget build(BuildContext context) {
    done = false;
    // checkBox = false;
    // loading = false;
    // AuthController.instance.logout();

    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 46, left: 23),
                    child: Text(
                      "Enter your details",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: Text(
                      "Technical Details",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.03),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: controllers[0],
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'Experience',
                          hintText: "Years of Experience",
                          floatingLabelBehavior: controllers[0].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.work_history),
                          border: OutlineInputBorder(
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
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: controllers[1],
                        decoration: InputDecoration(
                          labelText: 'Education',
                          hintText: "Education (Degree)",
                          floatingLabelBehavior: controllers[1].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(
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
                      height: width(context) * 0.38,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        maxLines: 5,
                        controller: controllers[9],
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          hintText: "Bio",
                          floatingLabelBehavior: controllers[9].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.info),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.01),
                  addVerticalSpace(width(context) * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(left: 23),
                    child: Text(
                      "Your Best Project",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.021),
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
                          labelText: 'Project Name',
                          hintText: "Project Name",
                          floatingLabelBehavior: controllers[2].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.assignment_outlined),
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
                  addVerticalSpace(width(context) * 0.04),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: controllers[3],
                        decoration: InputDecoration(
                          labelText: 'Role/Position',
                          hintText: "Role/Position",
                          floatingLabelBehavior: controllers[3].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.contacts_rounded),
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
                  addVerticalSpace(width(context) * 0.04),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: controllers[4],
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: "Description",
                          floatingLabelBehavior: controllers[4].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.more_horiz),
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
                  addVerticalSpace(width(context) * 0.04),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: controllers[5],
                        decoration: InputDecoration(
                          labelText: 'Technologies Used',
                          hintText: "Technologies Used",
                          floatingLabelBehavior: controllers[5].text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(CupertinoIcons.device_laptop),
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
                ],
              ),
              addVerticalSpace(height(context) * 0.01),
              addVerticalSpace(width(context) * 0.02),
              Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Text(
                  "Links",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              addVerticalSpace(width(context) * 0.04),
              Center(
                child: SizedBox(
                  width: width(context) * 0.87,
                  height: width(context) * 0.18,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: controllers[6],
                    decoration: InputDecoration(
                      labelText: 'Github',
                      hintText: "Github",
                      floatingLabelBehavior: controllers[6].text.isEmpty
                          ? FloatingLabelBehavior.never
                          : FloatingLabelBehavior.always,
                      suffixIcon: Icon(Typicons.github),
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
              addVerticalSpace(width(context) * 0.04),
              Center(
                child: SizedBox(
                  width: width(context) * 0.87,
                  height: width(context) * 0.18,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: controllers[7],
                    decoration: InputDecoration(
                      labelText: 'Portfolio URL',
                      hintText: "Portfolio URL",
                      floatingLabelBehavior: controllers[7].text.isEmpty
                          ? FloatingLabelBehavior.never
                          : FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.work),
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
              addVerticalSpace(width(context) * 0.04),
              Center(
                child: Container(
                  width: width(context) * 0.87,
                  height: width(context) * 0.558,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: image == null ? Colors.black26 : Colors.blue,
                      width: 1.8,
                    ),
                  ),
                  child: Center(
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
                              )),
                        ),
                        addVerticalSpace(10),
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
                          child: Text(
                            image == null
                                ? "Upload Your Resume"
                                : "Resume Uploaded",
                            style: TextStyle(
                              color:
                                  image == null ? Colors.black26 : themeColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              addVerticalSpace(height(context) * 0.01),
              addVerticalSpace(width(context) * 0.02),
              Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Text(
                  "Availibility Status",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              addVerticalSpace(width(context) * 0.04),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(availibilityStatus.length, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedStatus = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            width(context) * 0.01, 0, width(context) * 0.01, 0),
                        height: width(context) * 0.15,
                        width: width(context) * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedStatus == index
                              ? btnColor
                              : Colors.black26,
                        ),
                        child: Center(
                          child: AppText(
                            text: availibilityStatus[index],
                            size: 14,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              addVerticalSpace(height(context) * 0.03),
              Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Text(
                  "Preferred Role",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              addVerticalSpace(width(context) * 0.04),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(preferedRole.length, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedRole = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            width(context) * 0.01, 0, width(context) * 0.01, 0),
                        height: width(context) * 0.15,
                        width: width(context) * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              selectedRole == index ? btnColor : Colors.black26,
                        ),
                        child: Center(
                          child: AppText(
                            text: preferedRole[index],
                            size: 14,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              addVerticalSpace(height(context) * 0.03),
              Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Text(
                  "Additional Skills",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              addVerticalSpace(height(context) * 0.03),
              Center(
                child: SizedBox(
                  width: width(context) * 0.87,
                  height: width(context) * 0.18,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: controllers[8],
                    decoration: InputDecoration(
                      labelText: 'Additional Skills',
                      hintText: "Non-technical skills (hobbies)",
                      floatingLabelBehavior: controllers[8].text.isEmpty
                          ? FloatingLabelBehavior.never
                          : FloatingLabelBehavior.always,
                      // suffixIcon: Icon(CupertinoIcons.device_laptop),
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
              addVerticalSpace(height(context) * 0.03),
              Visibility(
                visible: !widget.edit,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          checkBox = !checkBox;
                        });
                      },
                      child: Icon(
                        Icons.check_box_outlined,
                        color: checkBox ? btnColor : Colors.black26,
                      ),
                    ),
                    addHorizontalySpace(20),
                    AppText(
                      text:
                          "I solemnly confirm that all the provided \ndetails are authentic and verifiable.",
                      color: Colors.black54,
                      size: width(context) * 0.038,
                    )
                  ],
                )),
              ),
              addVerticalSpace(height(context) * 0.03),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height(context) * 0.009),
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextButton(
                        onPressed: () async {
                          if (check() &&
                              (selectedRole != -1) &&
                              (selectedStatus != -1)) {
                            if (checkBox) {
                              setState(() {
                                loading = true;
                              });

                              File? profilePic =
                                  ProfileData.pic ?? ProfileData.icon;

                              String folderPath = 'images/';
                              String fileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString() +
                                  '_' +
                                  image!.path.split('/').last;
                              String fileNamepic = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString() +
                                  '_' +
                                  profilePic!.path.split('/').last;

                              FirebaseStorage storage =
                                  FirebaseStorage.instance;
                              Reference ref =
                                  storage.ref().child(folderPath + fileName);
                              UploadTask uploadTask = ref.putFile(image!);
                              Reference refpic =
                                  storage.ref().child(folderPath + fileNamepic);
                              UploadTask uploadTaskpic =
                                  refpic.putFile(profilePic);

                              TaskSnapshot storageTaskSnapshot =
                                  await uploadTask.whenComplete(() => null);

                              TaskSnapshot storageTaskSnapshotpic =
                                  await uploadTaskpic.whenComplete(() => null);

                              String downloadUrl = await storageTaskSnapshot.ref
                                  .getDownloadURL();

                              String downloadUrlpic =
                                  await storageTaskSnapshotpic.ref
                                      .getDownloadURL();

                              log(downloadUrl);
                              log(downloadUrlpic);

                              int count = 0;

                              QuerySnapshot snaps = await users
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
                                  users.doc((count + 1).toString());
                              done = true;

                              await documentRef.set({
                                "id": count + 1,
                                "bio":
                                    "As a Figma designer, I bring ideas to life by crafting visually stunning and interactive designs. I possess a keen eye for aesthetics, typography, and color theory, ensuring that every design element aligns with the brand's identity and user preferences. By utilizing Figma's powerful design tools and collaborative features, I create pixel-perfect mockups, wireframes, and prototypes that effectively communicate design concepts. I am adept at creating intuitive user interfaces, designing captivating illustrations, and optimizing designs for various devices and screen sizes, delivering exceptional user experiences.",
                                'name': ProfileData.name,
                                'role': "developer",
                                'phno': "+91${ProfileData.phno.trim()}",
                                'email': Global.email.trim(),
                                "active": "yes",
                                'linkedin': ProfileData.linkedin,
                                // 'linkedin': "in/manvendra-singh-08a233222",
                                'city': ProfileData.city,
                                'state': ProfileData.state,
                                'experience': controllers[0].text.trim(),
                                'education': controllers[1].text.trim(),
                                'project_name': controllers[2].text.trim(),
                                'position': controllers[3].text.trim(),
                                'desc': controllers[4].text.trim(),
                                "earned": 0,
                                "badge": "bronze",
                                "level_score": 0,
                                "badge_score": 0,
                                "level": 10,
                                "projects_completed": [],
                                "pic": downloadUrlpic,
                                'tech_used': controllers[5].text.trim(),
                                'github': controllers[6].text.trim(),
                                // 'github': "https://github.com/SujaanArora09",
                                'portfolio': controllers[7].text.trim(),
                                'hobbies': controllers[8].text.trim(),
                                "resume": downloadUrl,
                                "availibility":
                                    availibilityStatus[selectedStatus],
                                "pref_role": availibilityStatus[selectedRole],
                              }).then((value) {
                                print('Data added successfully!');
                              }).catchError((error) {
                                print('Failed to add data: $error');
                              });
                              nextScreen(context, HomePage());

                              gotoNext(context);

                              setState(() {
                                loading = false;
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Please confirm to the authenticity of the information",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                        ),
                        child: const Center(
                          child: Text(
                            "Submit Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              addVerticalSpace(height(context) * 0.03),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height(context) * 0.009),
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextButton(
                        onPressed: () async {
                          AuthController.instance.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                        ),
                        child: const Center(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ),
                        ),
                        ),
                        ),
                        ),
              addVerticalSpace(25),
            ],
          ),
        ),
      ),
    );
  }
}
