import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static String phone = "";
  static String email = "";
  static String role = "";
  static String name = "";
  static bool isNew = false;
  static int id = -1;
  static List mainMap = [];
  static List graphData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  static List<String> graphX = ["", "", "", "", "", "", ""];

  destroy() {
    phone = "";
    email = "";
    id = -1;
    role = "";
    name = "";

    graphData = [0, 0, 0, 0, 0, 0, 0];
    graphX = ["", "", "", "", "", "", ""];

    removePhoneNumber();
    removeEmail();
    removeRole();
    removeName();

    log("destroyed");
  }

  fetchData() {
    getPhoneNumber().then((phoneNumber) async {
      print('Phone Number: $phoneNumber');
      Global.phone = phoneNumber;
    });
    getEmail().then((email) async {
      print('Email: $email');
      Global.email = email;
    });
    getRole().then((rol) async {
      print('Login: $rol');
      Global.role = rol;
    });
    getName().then((nm) async {
      print('Name: $nm');
      Global.name = nm;
    });
  }

  void savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcPhoneNumber', phoneNumber);
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcPhoneNumber') ?? "";
  }

  void removePhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcPhoneNumber');
  }

  void saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcEmail', email);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcEmail') ?? "";
    ;
  }

  void removeEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcEmail');
  }

  void saveRole(String log) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcRole', log);
  }

  Future<String> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcRole') ?? "";
  }

  void removeRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcRole');
  }

  void saveName(String log) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('AmcName', log);
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('AmcName') ?? "";
  }

  void removeName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AmcName');
  }
}
