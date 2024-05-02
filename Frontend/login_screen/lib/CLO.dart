import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'Course.dart';
import 'main.dart';

class CLO {
  static int _id = 0;
  static String? _description;
  static String? _bloom_taxonomy;
  static int? _level;
  static int? _course;

  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static set id(int value) {
    _id = value;
  }

  static int get id => _id;

  static String? get description => _description;

  static set description(String? value) {
    _description = value;
  }

  static String? get bloom_taxonomy => _bloom_taxonomy;

  static set bloom_taxonomy(String? value) {
    _bloom_taxonomy = value;
  }

  static int? get level => _level;

  static set level(int? value) {
    _level = value;
  }

  static int? get course => _course;

  static set course(int? value) {
    _course = value;
  }

  static Future<bool> createCLO(
      String description, String BT, int BTLevel, int course_id) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/clo');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'description': description,
          'bloom_taxonomy': BT,
          'level': BTLevel,
          'course': course_id
        }),
      );
      if (response.statusCode == 201) {
        print('CLO Created successfully');
        return true;
      } else {
        print('Failed to create CLO. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating CLO: $e');
      return false;
    }
  }

  static Future<List<dynamic>> fetchCLO(int CourseId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/course/${CourseId}/clo');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to Load CLOs');
    }
  }

  static Future<Map<String, dynamic>?> getCLObyCLOId(int CLO_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/clo/$CLO_id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      // Return null if the CLO with the given ID does not exist
      return null;
    } else {
      // Throw an exception for any other error status code
      throw Exception('Failed to fetch CLO with ID $CLO_id');
    }
  }

  static Future<bool> deleteCLO(int cloId) async {
    try {
      final accessToken = await storage.read(key: "access_token");

      final url = Uri.parse('$ipAddress:8000/api/clo/$cloId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        print('CLO deleted successfully');
        return true;
      } else {
        print('Failed to delete CLO. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting CLO: $e');
      return false;
    }
  }
}
