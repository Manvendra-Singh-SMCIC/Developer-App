// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:developer';

import 'package:amacle_studio_app/pages/GithubPage.dart';
import 'package:amacle_studio_app/pages/individual_project.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/widgets.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<String> _sortingOptions = [
    'None',
    'Low to High',
    'High to Low',
  ];

  List<String> _filterOptions = [
    "All",
    'Figma',
    'App',
    'Web',
    "Firebase",
    "Flutter",
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

  late String _selectedOption;
  late String _selectedOptionFilter;

  @override
  void initState() {
    super.initState();
    _selectedOption = _sortingOptions[0];
    _selectedOptionFilter = _filterOptions[0];
  }

  TextEditingController searchBarController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.05),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 17, right: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addVerticalSpace(height(context) * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     nextScreen(context, Search());
                  //   },
                  //   icon: Icon(
                  //     Icons.search,
                  //     color: grey,
                  //   ),
                  // ),
                ],
              ),
              addVerticalSpace(height(context) * 0.018),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width(context) * 0.43,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1,
                          )),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            label: Text("Sort"),
                            prefix: Icon(Icons.sort),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedOption,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOption = newValue!;
                                print('Selected option: $_selectedOption');
                              });
                            },
                            items: _sortingOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Visibility(
                                  visible: true,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  addHorizontalySpace(10),
                  Container(
                    width: width(context) * 0.45,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1,
                          )),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonHideUnderline(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            label: Text("Filter"),
                            prefix: Icon(Icons.filter_list),
                          ),
                          child: DropdownButton<String>(
                            hint: Text("Filter"),
                            value: _selectedOptionFilter,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            dropdownColor: Colors.white,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOptionFilter = newValue!;
                                print(
                                    'Selected option: $_selectedOptionFilter');
                              });
                            },
                            items: _filterOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Visibility(
                                  visible: value != "Filter",
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(height(context) * 0.018),
              StreamBuilder<QuerySnapshot>(
                stream: _selectedOptionFilter == "All"
                    ? (_selectedOption == "None"
                        ? FirebaseFirestore.instance
                            .collection("new_projects")
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection("new_projects")
                            .orderBy("price",
                                descending: _selectedOption != "Low to High")
                            .snapshots())
                    : (_selectedOption == "None"
                        ? FirebaseFirestore.instance
                            .collection("new_projects")
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection("new_projects")
                            .where("tags", arrayContains: _selectedOptionFilter)
                            .orderBy("price",
                                descending: _selectedOption != "Low to High")
                            .snapshots()),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: AppText(
                        text: "No projects as of now.",
                        color: Colors.black26,
                        size: 22,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    return GridView.count(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: (0.4 / 0.47),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      children: List.generate(
                        documents.length,
                        (index) {
                          print(_selectedOptionFilter);
                          print(documents[index]["tags"]
                              .contains(_selectedOptionFilter));
                          return Visibility(
                            visible: _selectedOptionFilter != "All"
                                ? (documents[index]["tags"])
                                    .contains(_selectedOptionFilter)
                                : true,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: white,
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              IndividualProject(
                                                  doc: documents[index]),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: height(context) * 0.161,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: networkImage(
                                            documents[index]["image"],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        color: white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: documents[index]["name"],
                                              size: width(context) * 0.05,
                                              color: black,
                                            ),
                                            addVerticalSpace(
                                                height(context) * 0.001),
                                            AppText(
                                              text:
                                                  "₹${documents[index]["price"]}",
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: AppText(
                        text: "Some error occured",
                        color: Colors.black26,
                        size: 22,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
