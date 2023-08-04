// ignore_for_file: unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types, library_private_types_in_public_api

import 'package:amacle_studio_app/global/globals.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/bottom_bar_chat_page.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/manager_home_screen.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/manager_project_screen.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/home_page.dart';
import 'package:amacle_studio_app/pages/bottom_bar_pages/project_screen.dart';
import 'package:amacle_studio_app/pages/splash_screen.dart';
import 'package:amacle_studio_app/utils/app_text.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:amacle_studio_app/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'authentication/auth_controller.dart';
import 'firebase_options.dart';
import 'utils/icons.dart';

// SHA1: FC:A4:F9:D0:64:3F:0A:05:45:FA:85:F0:E8:D3:07:C1:A9:C9:81:E3
// SHA-256: 95:AA:4C:95:DC:96:A7:D5:BC:37:66:AB:67:86:0E:7D:CC:F1:1C:0A:6D:34:33:29:6E:ED:0F:82:64:93:BF:80

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> doit() async {
    await Global().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    doit();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  List pages = [
    decideHomePage(),
    BottomBarCharPage(),
    dontKnowPage(),
  ];

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "Press again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    BarIcons icons = BarIcons();
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("email", isEqualTo: Global.email)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return WillPopScope(
                onWillPop: _onWillPop,
                child: loadingState(),
              );
            }
            if (snapshot.hasData) {
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              Global.mainMap = documents;
              Global.role = Global.mainMap[0]["role"];
              Global.id = Global.mainMap[0]["id"];
              return WillPopScope(
                onWillPop: _onWillPop,
                child: pages[currentIndex],
              );
            } else {
              return WillPopScope(
                onWillPop: _onWillPop,
                child: Center(
                  child: AppText(
                    text: "An error ocured",
                    color: black,
                  ),
                ),
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(
              color: Color(0xFF1F2024),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 2),
          selectedItemColor: Color(0xFF1F2024),
          unselectedLabelStyle: TextStyle(
            color: Color(0xFF71727A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
          unselectedItemColor: Color(0xFF71727A),
          selectedFontSize: 15,
          unselectedFontSize: 15,
          selectedIconTheme: null,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(
              () {
                currentIndex = index;
              },
            );
          },
          items: [
            icons.item(
              20,
              20,
              "Home",
              22,
              currentIndex == 0,
              "assets/HomeIcon.png",
            ),
            icons.item(
              20,
              20,
              "Chats",
              22,
              currentIndex == 1,
              "assets/Chat Icon.png",
            ),
            icons.item(
              29,
              30,
              "Projects",
              22,
              currentIndex == 2,
              "assets/Community Icon.png",
            ),
          ],
        ),
      ),
    );
  }
}

class dontKnowPage extends StatefulWidget {
  const dontKnowPage({Key? key}) : super(key: key);

  @override
  _dontKnowPageState createState() => _dontKnowPageState();
}

class _dontKnowPageState extends State<dontKnowPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Global.role == "developer"
        ? ProjectScreen()
        : ManagerProjectScreen();
  }
}

class decideHomePage extends StatefulWidget {
  const decideHomePage({Key? key}) : super(key: key);

  @override
  _decideHomePageState createState() => _decideHomePageState();
}

class _decideHomePageState extends State<decideHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Global.role == "developer"
        ? HomePageScreen()
        : ManagerHomePageScreen();
  }
}
