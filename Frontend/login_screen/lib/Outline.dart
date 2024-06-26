import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'main.dart';
import 'package:http/http.dart' as http;

class Outline {
  static int _id = 0;
  static int _course = 0;
  static int _batch = 0;
  static int _teacher = 0;
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

  static int get course => _course;

  static set course(int value) {
    _course = value;
  }

  static int get batch => _batch;

  static set batch(int value) {
    _batch = value;
  }

  static int get teacher => _teacher;

  static set teacher(int value) {
    _teacher = value;
  }

  static Future<Map<String, dynamic>> createOutline(int course, int batch, int teacher) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/outline');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'course': course,
          'batch': batch,
          'teacher': teacher,
        }),
      );

      if (response.statusCode == 201) {
        print('Outline created successfully');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to create Outline. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Exception while creating Outline: $e');
      return {};
    }
  }

  static Future<List<dynamic>> fetchOutlineByCourse(
      int course_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/course/$course_id/outline');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to load Outline');
      return []; // Return null instead of an empty map
    }

  }

  static  Future<Map<String, dynamic>?> fetchOutlineByBatch(int batch_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/batch/$batch_id/outline');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      print('Failed to load Outline');
      return {};
    }
  }
  static Future<List<dynamic>> fetchOutlineByTeacher(int teacher_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/user/$teacher_id/outline');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load Outline');
      return [];
    }
  }
  static Future<bool> updateOutline(int id, String course, String batch, String teacher) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/outline/$id');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'course': course,
          'batch': batch,
          'teacher': teacher,
        }),
      );
      if (response.statusCode == 200) {
        print('Outline updated successfully');
        return true;
      } else {
        print('Failed to update Outline. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while updating Outline: $e');
      return false;
    }
  }
  static Future<bool> deleteOutline(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/outline/$id');
    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        print('Outline deleted successfully');
        return true;
      } else {
        print('Failed to delete Outline. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Outline: $e');
      return false;
    }
  }

  static  Future<Map<String, dynamic>?> fetchSingleOutline(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/outline/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load Outline');
      return {};
    }
  }

  static  Future<Map<String, dynamic>?> fetchCompleteOutline(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/complete-outline/$id');
    try{
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load Outline');
        return null;
      }
    } catch(e){
      print("Exception while fetching complete outline: $e");
      return null;
    }
  }


  static Future<bool> createCompleteOutline({
    required int batch,
    required int teacher,
    required int course,
    required List<Map<String, dynamic>> objectives,
    required List<Map<String, dynamic>> clos,
    required Map<String, dynamic> schedule,
    required List<Map<String, dynamic>> assessments,
    required List<Map<String, dynamic>> weeklyTopics,
    required List<Map<String, dynamic>> books,
  }) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/create/complete-outline');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'batch': batch,
          'teacher': teacher,
          'course': course,
          'objectives': objectives,
          'clos': clos,
          'schedule': schedule,
          'assessments': assessments,
          'weekly_topics': weeklyTopics,
          'books': books,
        }),
      );

      print(response.body);
      if (response.statusCode == 201) {
        print('Complete Outline created successfully');
        return true;
      } else {
        print('Failed to create Complete Outline. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Complete Outline: $e');
      return false;
    }
  }



}