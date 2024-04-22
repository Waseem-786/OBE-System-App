import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:login_screen/Token.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class User {
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

  static String ipAddress = MyApp.ip;

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

  static bool isUniLevel(){
    if(universityid!=0 && campusid==0 && departmentid==0){
      return true;
    }
    return false;
  }

  static bool iscampusLevel(){
    if(universityid!=0 && campusid!=0 && departmentid==0){
      return true;
    }
    return false;
  }

  static bool isdeptLevel(){
    if(universityid!=0 && campusid!=0 && departmentid!=0){
      return true;
    }
    return false;
  }

  static Future<void> getUser() async {
    String? accessToken = await Token.readAccessToken();
    try {
      final response = await http.get(
        Uri.parse('$ipAddress:8000/auth/users/'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        SetUserData(responseData);
      } else {

      }

    } catch (e) {
      print("Something went wrong. Server Error");
      print(e);
    }


  }

  static void SetUserData(var responseData) {
    responseData = responseData[0];

    id = int.parse(responseData['id'].toString());
    username = responseData['username'].toString();
    firstName = responseData['first_name'].toString();
    lastName = responseData['username'].toString();
    email = responseData['email'].toString();
    universityid = int.parse(responseData['university'].toString());
    campusid = int.parse(responseData['campus'].toString());
    departmentid = int.parse(responseData['department'].toString());
    universityName = responseData['university_name'].toString();
    campusName = responseData['campus_name'].toString();
    departmentName = responseData['department_name'].toString();
    isSuperUser = bool.parse(responseData['is_superuser'].toString());
  }

  // Get All users for superuser
  static Future<List> getAllUsers() async {
    String? accessToken = await Token.readAccessToken();

    final response = await http.get(
      Uri.parse('$ipAddress:8000/api/users'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      // all the data of the users is stored in responseData
      var responseData = jsonDecode(response.body);
      return responseData;
    } else {
      return [];
    }
  }

  // Create User
  static Future<String> registerUser(String firstName, String lastName, String email, String password, String confirmPassword, String userName, int? universityId, int? campusId, int? departmentId) async {
    String message = "";
    // Create a map containing the user registration data
    Map<String, dynamic> userData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      're_password': confirmPassword,
      'username': userName,
    };

    // Conditionally include universityId, campusId, and departmentId if provided
    if (universityId != null) {
      userData['university'] = universityId;
    }
    if (campusId != null) {
      userData['campus'] = campusId;
    }
    if (departmentId != null) {
      userData['department'] = departmentId;
    }

    // Convert the map to a JSON string
    String requestBody = jsonEncode(userData);

    // Send the POST request
    try {
      http.Response response = await http.post(
        Uri.parse('$ipAddress:8000/auth/users/'),
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        message = 'Registration successful';
        // You can navigate to another screen or show a success message here
      } else if (response.statusCode == 400) {
        message = 'Please Enter all Fields';
      }
      else {
        message = 'Failed create user ${response.body}';
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      message = 'Failed to connect to the server. Please try again later.$e';
    }

    return message;
  }

}