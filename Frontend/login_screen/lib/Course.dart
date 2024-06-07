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
  static String? _pecContent;

  static String? get pecContent => _pecContent;

  static set pecContent(String? value) {
    _pecContent = value;
  }

  static int _campus = 0;


  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static set id(int value) {
    _id = value;
  }
  static int get id => _id;

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

  static int get campus => _campus;
  static set campus(int value) {
    _campus = value;
  }


  static Future<bool> createCourse(String code, String title, int theoryCredits, int labCredits, String courseType,
      String reqElec, int? preReq, String description, String content, int campus) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/course');
      final Map<String, dynamic> requestBody = {
        'code': code,
        'title': title,
        'theory_credits': theoryCredits,
        'lab_credits': labCredits,
        'course_type': courseType,
        'required_elective': reqElec,
        'description': description,
        'pec_content': content,
        'campus': campus
      };

      if (preReq != null) {
        requestBody['prerequisite'] = preReq;
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print(response.body);
      if (response.statusCode == 201) {
        print('Course Created successfully');
        return true;
      } else {
        print('Failed to create Course. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Course: $e');
      return false;
    }
  }

  static Future<List<dynamic>> fetchCourses() async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/course');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> fetchCoursesbyCampusId(int campusId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/campus/$campusId/course');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to Load Courses');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getCoursebyId(int courseId) async {
    final courses = await fetchCourses();
    for (var course in courses) {
      if (course['id'] == courseId) {
        return course;
      }
    }
    return null;
  }

  static Future<bool> deleteCourse(int courseId) async {
    try {
      final accessToken = await storage.read(key: "access_token");

      final url = Uri.parse('$ipAddress:8000/api/course/$courseId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        print('Course deleted successfully');
        return true;
      } else {
        print('Failed to delete Course. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Course: $e');
      return false;
    }
  }


}
