// ignore_for_file: prefer_const_constructors

import 'package:amacle_studio_app/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constant.dart';
import 'loginpage.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() async {
    await Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        Get.offAll(() => const HomePage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        child: Center(
          child: SizedBox(
            height: height(context) * 0.5,
            width: width(context),
            child: Image.asset(
              "assets/amacle_banner.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
