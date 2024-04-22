import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';
import 'package:http/http.dart' as http;


class University {
  static int _id = 0;
  static String _name = '';
  static String? _vision; // Updated to nullable String
  static String? _mission; // Updated to nullable String

  University();

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String get name => _name;

  static set name(String value) {
    _name = value;
  }

  static String? get vision => _vision; // Updated getter to return nullable String

  static set vision(String? value) { // Updated setter to accept nullable String
    _vision = value;
  }

  static String? get mission => _mission; // Updated getter to return nullable String

  static set mission(String? value) { // Updated setter to accept nullable String
    _mission = value;
  }

  static  Future<List<dynamic>> fetchUniversities() async {
    final ipAddress = MyApp.ip;
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/university');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load universities');
    }
  }

  static Future<Map<String, dynamic>?> getUniversityById(int id) async {
    final universities = await fetchUniversities();
    for (var university in universities) {
      if (university['id'] == id) {
        print(university);
        return university;
      }
    }
    return null;
  }
  static Future<bool> createUniversity(String name, String mission, String vision) async {
    try {
      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );
      final accessToken = await storage.read(key: "access_token");
      const ipAddress = MyApp.ip;
      final url = Uri.parse('$ipAddress:8000/api/university');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'mission': mission,
          'vision': vision,
        }),
      );
      if (response.statusCode == 201) {
        print('University Created successfully');
        return true;
      } else {
        print('Failed to create university. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating university: $e');
      return false;
    }
  }

}
