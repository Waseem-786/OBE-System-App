import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Token.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class SelectedUser {
  static int _id = 0;
  static String _username = '';
  static String _firstName = '';
  static String _lastName = '';
  static String _email = '';
  static int _universityid = 0;
  static int _campusid = 0;
  static int _departmentid = 0;
  static String _universityName = '';
  static String _campusName = '';
  static String _departmentName = '';
  static bool _isSuperUser = false;

  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String get username => _username;

  static set username(String value) {
    _username = value;
  }

  static String get firstName => _firstName;

  static set firstName(String value) {
    _firstName = value;
  }

  static String get lastName => _lastName;

  static set lastName(String value) {
    _lastName = value;
  }

  static String get email => _email;

  static set email(String value) {
    _email = value;
  }


  static int get universityid => _universityid;

  static set universityid(int value) {
    _universityid = value;
  }

  static int get campusid => _campusid;

  static set campusid(int value) {
    _campusid = value;
  }

  static int get departmentid => _departmentid;

  static set departmentid(int value) {
    _departmentid = value;
  }

  static String get universityName => _universityName;

  static set universityName(String value) {
    _universityName = value;
  }

  static String get campusName => _campusName;

  static set campusName(String value) {
    _campusName = value;
  }

  static String get departmentName => _departmentName;

  static set departmentName(String value) {
    _departmentName = value;
  }

  static bool get isSuperUser => _isSuperUser;

  static set isSuperUser(bool value) {
    _isSuperUser = value;
  }

  static bool isUniLevel() {
    if (universityid != 0 && campusid == 0 && departmentid == 0) {
      return true;
    }
    return false;
  }

  static bool iscampusLevel() {
    if (universityid != 0 && campusid != 0 && departmentid == 0) {
      return true;
    }
    return false;
  }

  static bool isdeptLevel() {
    if (universityid != 0 && campusid != 0 && departmentid != 0) {
      return true;
    }
    return false;
  }
}