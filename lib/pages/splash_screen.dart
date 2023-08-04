// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constant.dart';
import 'loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() async {
    await Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Get.offAll(() => const LoginPage());
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
