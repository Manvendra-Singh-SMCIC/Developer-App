// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:amacle_studio_app/authentication/director_screen.dart';
import 'package:amacle_studio_app/main.dart';
import 'package:amacle_studio_app/pages/loginpage.dart';
import 'package:amacle_studio_app/pages/profile.dart';
import 'package:amacle_studio_app/pages/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../global/globals.dart';
import '../pages/contact_info.dart';
import '../pages/splash_screen_2.dart';

class AuthController extends GetxController {
  //AuthController instance
  static AuthController instance = Get.find();
  //Email, password, name
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Map<String, dynamic>? facebookMapUserData;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    Global().getEmail().then((email) async {
      log('Email: $email');
      Global.email = email;
    });
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      Global.email = user.email!;
      log(user.email!);
      Global().saveEmail(Global.email);
      QuerySnapshot snapshot =
          await users.where('email', isEqualTo: Global.email).get();
      Get.offAll(
        () => Global.isNew
            ? ContactInfo()
            : snapshot.docs.isNotEmpty
                ? DirectorScreen()
                : ContactInfo(),
      );
    }
  }

  Future<void> register(String email, String password) async {
    try {
      Global.email = email;
      Global.isNew = true;
      Global().saveEmail(email);
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (e) {
      // Handle Firebase-specific exceptions here
      print("Firebase Exception: ${e.message}");
      Fluttertoast.showToast(
        msg: "Firebase error: ${e.message}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions here
      print("Platform Exception: ${e.message}");
      Fluttertoast.showToast(
        msg: "Platform error: ${e.message}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: "Account creation failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print(e);
    }
  }

  Future<void> login(String email, String password,
      void Function(String errorMessage) errorCallback) async {
    try {
      Global.email = email;
      Global().saveEmail(email);
      Global.isNew = false;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Login failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on Exception catch (e) {
      print(e);
      errorCallback(e.toString());
    }
  }

  signInWithGoogle(void Function(String errorMessage) errorCallback) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn(scopes: <String>["email"]).signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Access the email ID of the registered user

      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        Global.isNew = true;
        log('New user signed in');
      } else {
        Global.isNew = false;
        log('Registered user signed in');
      }

      final String? email = user?.email;
      Global.email = email ?? "";
      Global().saveEmail(email ?? "");

      return userCredential;
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions here
      print("Platform Exception: ${e.message}");
      Fluttertoast.showToast(
        msg: "Platform error: ${e.message}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on Exception catch (e) {
      print(e);
      errorCallback(e.toString());
    }
  }

  Future<void> logout() async {
    Global().destroy();
    auth.signOut;
    await googleSignIn.signOut();
    await auth.signOut();
  }
}
