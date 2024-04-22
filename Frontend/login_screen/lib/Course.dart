import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Course {
  static int _id = 0;
  static String? _code;
  static String? _title;
  static int? _theory_credits;
  static int _lab_credits = 0;
  static String? _course_type;
  static String? _required_elective;
  static int? _prerequisite;
  static String? _description;

  static set id(int value) {
    _id = value;
  }
  static int get id => _id;

  Course();

  //setter getter for course code
  static String? get code => _code;

  static set code(String? value) {
    _code = value;
  }

  //setter getter for course title
  static String? get title => _title;

  static set title(String? value) {
    _title = value;
  }

  //setter getter for course's theory credits
  static int? get theory_credits => _theory_credits;

  static set theory_credits(int? value) {
    _theory_credits = value;
  }

  //setter getter for course's lab credits
  static int get lab_credits => _lab_credits;

  static set lab_credits(int value) {
    _lab_credits = value;
  }

  //setter getter for course type
  static String? get course_type => _course_type;

  static set course_type(String? value) {
    _course_type = value;
  }

  //setter getter for course sense of being required or elective
  static String? get required_elective => _required_elective;

  static set required_elective(String? value) {
    _required_elective = value;
  }

  //setter getter for course's prerequisite
  static int? get prerequisite => _prerequisite;

  static set prerequisite(int? value) {
    _prerequisite = value;
  }

  //setter getter for course's description
  static String? get description => _description;

  static set description(String? value) {
    _description = value;
  }
  static Future<bool> createCourse(String code, String title, int theoryCredits,int labCredits,String courseType,
      String reqElec, String preReq, String description) async {
    try {
      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );
      final accessToken = await storage.read(key: "access_token");
      const ipAddress = MyApp.ip;
      final url = Uri.parse('$ipAddress:8000/api/course');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'code' : code,
          'title': title,
          'theory_credits':theoryCredits,
          'lab_credits': labCredits,
          'course_type':courseType,
          'required_elective':reqElec,
          'prerequisite':1,
          'description':description,
          'university':11
        }),
      );
      if (response.statusCode == 201) {
        print('Course Created successfully');
        return true;
      } else {
        print('Failed to create Course. Status code: ${response.statusCode}');
        print('Body: ${response.body}');

        return false;
      }
    } catch (e) {
      print('Exception while creating Course: $e');
      return false;
    }
  }
  static Future<List<dynamic>> fetchCourses() async {
    final ipAddress = MyApp.ip;
    const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/course');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to Load Courses');
    }
  }

  static Future<Map<String, dynamic>?> getCoursebyCode(String code) async {
    final courses = await fetchCourses();
    for (var course in courses) {
      if (course['code'] == code) {
        print(course);
        return course;
      }
    }
    return null;
  }
}
