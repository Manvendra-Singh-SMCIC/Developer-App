// ignore_for_file: prefer_const_constructors

import 'package:amacle_studio_app/authentication/auth_controller.dart';
import 'package:amacle_studio_app/pages/signup_page.dart';
import 'package:amacle_studio_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_button/sign_button.dart';
import 'package:fluttericon/typicons_icons.dart';

import 'forgot_password_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 86, left: 23),
            child: Text(
              "Welcome Back !",
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
              "Please enter your details",
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
            ),
          ),
          addVerticalSpace(height(context) * 0.03),
          Center(
            child: SizedBox(
              width: width(context) * 0.87,
              height: width(context) * 0.18,
              child: TextField(
                controller: emailcontroller,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: "Email",
                  floatingLabelBehavior: emailcontroller.text.isEmpty
                      ? FloatingLabelBehavior.never
                      : FloatingLabelBehavior.always,
                  suffixIcon: Icon(Typicons.at),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
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
                controller: passwordcontroller,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: "Password",
                  floatingLabelBehavior: passwordcontroller.text.isEmpty
                      ? FloatingLabelBehavior.never
                      : FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                obscureText: true,
                obscuringCharacter: '*',
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  width(context) * 0.06,
                  width(context) * 0.08,
                  width(context) * 0.05,
                ),
                child: GestureDetector(
                  onTap: () {
                    nextScreen(context, ForgotPassword());
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: themeColor,
                      fontSize: width(context) * 0.036,
                    ),
                  ),
                ),
              ),
            ],
          ),
          addVerticalSpace(height(context) * 0.005),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: height(context) * 0.01),
              child: SizedBox(
                width: width(context) * 0.87,
                height: width(context) * 0.16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TextButton(
                    onPressed: () {
                      if (emailcontroller.text.isNotEmpty &&
                          passwordcontroller.text.isNotEmpty) {
                        AuthController.instance.login(
                            emailcontroller.text.trim(),
                            passwordcontroller.text.trim(),
                            (val) {});
                        passwordcontroller.text = "";
                        emailcontroller.text = "";
                      } else if (emailcontroller.text.isEmpty &&
                          passwordcontroller.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Please enter the required fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else if (emailcontroller.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Please enter the email",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Please enter the password",
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
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          addVerticalSpace(width(context) * 0.05),
          Center(
            child: Container(
              height: width(context) * 0.16,
              child: SignInButton(
                btnText: " Sign in with Google",
                buttonType: ButtonType.google,
                btnColor: white,
                btnTextColor: Colors.black26,
                elevation: 0,
                width: width(context) * 0.78,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10),
                ),
                buttonSize: ButtonSize.large,
                onPressed: () {
                  AuthController.instance.signInWithGoogle((val) {});
                },
              ),
            ),
          ),
          addVerticalSpace(height(context) * 0.135),
          Padding(
            padding: EdgeInsets.fromLTRB(
              width(context) * 0.03,
              0,
              width(context) * 0.03,
              0,
            ),
            child: Row(
              children: [
                Container(
                  height: 1,
                  width: width(context) * 0.4,
                  decoration: const BoxDecoration(color: Colors.black26),
                ),
                Text(
                  "  or  ",
                  style: TextStyle(
                    fontSize: width(context) * 0.05,
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 1,
                  width: width(context) * 0.4,
                  decoration: const BoxDecoration(color: Colors.black26),
                ),
              ],
            ),
          ),
          addVerticalSpace(height(context) * 0.02),
          Center(
            child: Container(
              width: width(context) * 0.87,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: themeColor,
                ),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    replaceScreen(context, SignupPage());
                  },
                  child: const Text(
                    "Create a new account",
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
