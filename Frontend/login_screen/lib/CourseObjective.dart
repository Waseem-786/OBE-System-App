
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class CourseObjective {

  static int _id=0;
  static String? _description;
  static const ipAddress = MyApp.ip;

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String? get description => _description;

  static set description(String? value) {
    _description = value;
  }

  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static Future<bool> createCourseObjective(List<String> description,int courseId)
  async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/objective');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'description': description,
          'course' : courseId


        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        print(
            'Failed to create Objective. Status code: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Exception while creating Objective: $e');
      return false;
    }
  }








}