import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/main.dart';
import 'package:http/http.dart' as http;

class Course_Schedule {
  static int? _id;
  static int? _course_outline;
  static int? _lecture_hours_per_week;
  static int? _lab_hours_per_week;
  static int? _discussion_hours_per_week;
  static int? _office_hours_per_week;

  static int? get id => _id;

  static set id(int? value){
    _id = value;
  }

  static int? get course_outline => _course_outline;

  static set course_outline(int? value) {
    _course_outline = value;
  }

  static int? get lecture_hours_per_week => _lecture_hours_per_week;

  static set lecture_hours_per_week(int? value) {
    _lecture_hours_per_week = value;
  }

  static int? get lab_hours_per_week => _lab_hours_per_week;

  static set lab_hours_per_week(int? value) {
    _lab_hours_per_week = value;
  }

  static int? get discussion_hours_per_week => _discussion_hours_per_week;

  static set discusion_hours_per_week(int? value) {
    _discussion_hours_per_week = value;
  }

  static int? get office_hours_per_week => _office_hours_per_week;

  static set office_hours_per_week(int? value) {
    _office_hours_per_week = value;
  }

  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static Future<bool> createCourseSchedule(int courseOutline, int lectureHours,
      int labHours, int discussionHours, int officeHours) async {
    final accessToken = await storage.read(key: 'access_token');
    final url = Uri.parse('$ipAddress:8000/api/schedule');
    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'course_outline': courseOutline,
            'lecture_hours_per_week': lectureHours,
            'lab_hours_per_week': labHours,
            'discussion_hours_per_week': discussionHours,
            'office_hours_per_week': officeHours
          }));
      if (response.statusCode == 201) {
        print('Course Schedule Created Successfully');
        return true;
      } else {
        print(
            'Failed to create Course Schedule. Status Code: ${response.statusCode}');
        return false;
      }
      return true;
    } catch (e) {
      print('Exception while creating Course Schedule: $e');
      return false;
    }
  }

  static Future<List<dynamic>> fetchCourseScheduleByCourseOutline(
      int courseOutlineId) async {
    final accessToken = await storage.read(key: 'access_token');
    final url = Uri.parse('$ipAddress:8000/api/outline/$courseOutlineId/schedule');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization' : 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print(
            'Failed to load Course Schedule. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception while loading Course Schedule: $e');
      return [];
    }
  }
}
