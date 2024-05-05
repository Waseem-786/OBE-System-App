import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Role {
  static int _id = 0;
  static String? _name;

  static const ipAddress = MyApp.ip;

  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String? get name => _name;

  static set name(String? value) {
    name = value;
  }

  static Future<bool> createRoleByUniversityPerson(
      String name, String university_name) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse
        ('$ipAddress:8000/api/university/role/$university_name');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'university_name': university_name
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create Role. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Role: $e');
      return false;
    }
  }

  static Future<bool> createRoleByCampusPerson(
      String name, String campus_name) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse
        ('$ipAddress:8000/api/university/role/$campus_name');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'campus_name': campus_name
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create Role. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Role: $e');
      return false;
    }
  }




}
