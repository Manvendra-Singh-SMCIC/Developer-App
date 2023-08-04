// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:amacle_studio_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailcontroller = TextEditingController();
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  Future passwordreset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailcontroller.text.trim(),
      );
      Fluttertoast.showToast(
        msg: "Password reset email sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              e.message.toString(),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: width(context) * 0.87,
              height: width(context) * 0.18,
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: _emailcontroller,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: "Email",
                  floatingLabelBehavior: _emailcontroller.text.isEmpty
                      ? FloatingLabelBehavior.never
                      : FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          addVerticalSpace(height(context) * 0.05),
          Container(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: width(context) * 0.87,
                height: width(context) * 0.16,
                child: MaterialButton(
                  onPressed: () {
                    passwordreset();
                  },
                  child: AppText(
                    text: "RESET PASSWORD",
                    size: width(context) * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                  color: btnColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
