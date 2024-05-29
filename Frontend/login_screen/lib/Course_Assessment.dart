
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'main.dart';
import 'package:http/http.dart' as http;

class Course_Assessment
{
  static int _id =0;
  static String  _name = '';
  static int  _count = 0;
  static double  _weight = 0;
  static int  _course_outline = 0;
  static List<int?> _clo = [];

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
  static String get name => _name;

  static set name(String value) {
    _name = value;
  }


  static int get count => _count;

  static set count(int value) {
    _count = value;
  }

  static double get weight => _weight;

  static set weight(double value) {
    _weight = value;
  }

  static int get course_outline => _course_outline;

  static set course_outline(int value) {
    _course_outline = value;
  }

  static List<int?> get clo => _clo;

  static set clo(List<int?> value) {
    _clo = value;
  }


  static Future<bool> createCourseAssessment(
      String name, int count, double weight, int course_outline_id, List clo) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/assessment');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'count': count,
          'weight': weight,
          'clo': clo,
          'course_outline' : course_outline_id
        }),
      );
      if (response.statusCode == 201) {
        print('Course Assessment Created successfully');
        return true;
      } else {
        print('Failed to create Course Assessment. Status code: ${response.statusCode}');
        print({response.body});
        return false;
      }
    } catch (e) {
      print('Exception while creating Course Assessment: $e');
      return false;
    }
  }
  static  Future<List<dynamic>> fetchCourseAssessment(int course_outline_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/outline/$course_outline_id/assessment');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to Load Course Assessment');
      return [];
    }
  }
  static Future<bool> updateCourseAssessment(int id,String name, int count, double weight, int course_outline_id, List clo) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/assessment/$id');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'count': count,
          'weight': weight,
          'clo': clo,
          'course_outline' : course_outline_id
        }),
      );
      if (response.statusCode == 200) {
        print('Course Assessment updated successfully');
        return true;
      } else {
        print('Failed to update Course Assessment. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while updating Course Assessment: $e');
      return false;
    }
  }
  static Future<bool> deleteCourseAssessment(int id) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/assessment/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 204) {
        print('Course Assessment deleted successfully');
        return true;
      } else {
        print('Failed to delete Outline. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Course Assessment: $e');
      return false;
    }
  }
  static  Future<Map<String, dynamic>?> fetchSingleCourseAssessment(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/assessment/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print('Failed to load Course Assessment');
      return {};
    }
  }
}