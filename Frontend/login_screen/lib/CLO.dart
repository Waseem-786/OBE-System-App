import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class CLO
{
  static int _id = 0;
  static String? _description;
  static String? _bloom_taxonomy;
  static int? _level;
  static int? _course;

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
  static Future<bool> createCLO(String description, String BT, int BTLevel, int course_id) async {
    try {
      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );
      final accessToken = await storage.read(key: "access_token");
      const ipAddress = MyApp.ip;
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
        print(
            'Failed to create CLO. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating CLO: $e');
      return false;
    }
  }
  static Future<List<dynamic>> fetchCLO() async {
    final ipAddress = MyApp.ip;
    const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/clo');
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
    final clos = await fetchCLO();
    for (var clo in clos) {
      if (clo['id'] == CLO_id) {
        return clo;
      }
    }
    return null;
  }
}