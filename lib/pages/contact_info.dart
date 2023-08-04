// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:amacle_studio_app/global/profile_data.dart';
import 'package:amacle_studio_app/pages/profile.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo({super.key});

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController linkedincontroller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();
  TextEditingController namecontrolleler = TextEditingController();

  Future<File> assetToFile(String path) async {
    final byteData = await rootBundle.load(path);

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  doit() async {
    ProfileData.icon = await assetToFile("assets/Avatar.png");
  }

  @override
  void initState() {
    doit();
    super.initState();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    doit();
    return Scaffold(
      body: Container(
        width: width(context),
        height: height(context),
        child: SingleChildScrollView(
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
                      "Personel Info",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.black),
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.03),
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: ProfileData.pic == null
                                ? const Image(
                                    image: AssetImage("assets/Avatar.png"),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    ProfileData.pic!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Stack(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  ImagePicker picker = ImagePicker();

                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 80,
                                  );

                                  if (pickedFile != null) {
                                    ProfileData.pic = File(pickedFile.path);
                                    setState(() {});
                                  } else {
                                    setState(() {});
                                    print("No image selected");
                                  }
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17.5),
                                    color: white,
                                  ),
                                  child: const Icon(
                                      LineAwesomeIcons.alternate_pencil),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  addVerticalSpace(height(context) * 0.03),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            ProfileData.name = namecontrolleler.text.trim();
                          });
                        },
                        controller: namecontrolleler,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: "Name",
                          floatingLabelBehavior: namecontrolleler.text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.person),
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
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            ProfileData.phno = phonecontroller.text.trim();
                          });
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: phonecontroller,
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: 'Phone Number',
                          hintText: "Phone Number",
                          floatingLabelBehavior: phonecontroller.text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.call),
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
                          setState(() {
                            ProfileData.linkedin =
                                linkedincontroller.text.trim();
                          });
                        },
                        controller: linkedincontroller,
                        decoration: InputDecoration(
                          labelText: 'Linkedin',
                          hintText: "Linkedin",
                          floatingLabelBehavior: linkedincontroller.text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          suffixIcon: Icon(Typicons.linkedin),
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
                      "Location Info",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.black),
                    ),
                  ),
                  addVerticalSpace(width(context) * 0.021),
                  Center(
                    child: SizedBox(
                      width: width(context) * 0.87,
                      height: width(context) * 0.18,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            ProfileData.state = statecontroller.text.trim();
                          });
                        },
                        controller: statecontroller,
                        decoration: InputDecoration(
                          labelText: 'State',
                          hintText: "State",
                          floatingLabelBehavior: statecontroller.text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          // suffixIcon: Icon(Icons.lock),
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
                          setState(() {
                            ProfileData.city = citycontroller.text.trim();
                          });
                        },
                        controller: citycontroller,
                        decoration: InputDecoration(
                          labelText: 'City/Region',
                          hintText: "City/Region",
                          floatingLabelBehavior: citycontroller.text.isEmpty
                              ? FloatingLabelBehavior.never
                              : FloatingLabelBehavior.always,
                          // suffixIcon: Icon(Icons.lock),
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
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: height(context) * 0.09),
                  child: SizedBox(
                    width: width(context) * 0.87,
                    height: width(context) * 0.16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextButton(
                        onPressed: () {
                          if (phonecontroller.text.isNotEmpty &&
                              linkedincontroller.text.isNotEmpty &&
                              statecontroller.text.isNotEmpty &&
                              statecontroller.text.isNotEmpty) {
                            nextScreen(context, Profile(edit: false));
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
                            "Next",
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
              addVerticalSpace(5),
            ],
          ),
        ),
      ),
    );
  }
}
