import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';

class Assessment
{
  static int _id = 0;
  static String? _name;
  static int _teacher = 0;
  static int _batch = 0;
  static int _course = 0;
  static int _total_marks = 0;
  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }


  static String? get name => _name;

  static set name(String? value) {
    _name = value;
  }

  static int get teacher => _teacher;

  static set teacher(int value) {
    _teacher = value;
  }

  static int get batch => _batch;

  static set batch(int value) {
    _batch = value;
  }

  static int get course => _course;

  static set course(int value) {
    _course = value;
  }

  static int get total_marks => _total_marks;

  static set total_marks(int value) {
    _total_marks = value;
  }
  static Future<List<dynamic>> fetchAssessment() async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/assessment-creation');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      return [];
    }
  }
  static Future<Map<String, dynamic>?> getAssessmentbyId(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/assessment-creation/$id');
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
      return {};
    }
  }
  static Future<bool> updateAssessment(int id,String name,int teacher, int batch, int course, int total_marks) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/assessment-creation/$id');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'teacher': teacher,
          'batch': batch,
          'course': course,
          'total_marks': total_marks,
        }),
      );
      if (response.statusCode == 200) {
        print('Assessment updated successfully');
        return true;
      } else {
        print('Failed to update Assessment. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while updating Assessment: $e');
      return false;
    }
  }
  static Future<bool> createAssessment(String name,int teacher, int batch, int course, int total_marks) async {
    try {

      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/assessment-creation');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'teacher': teacher,
          'batch': batch,
          'course': course,
          'total_marks': total_marks,
        }),
      );
      print(response.body);
      if (response.statusCode == 201) {
        print('Assessment Created successfully');
        return true;
      } else {
        print('Failed to create Assessment. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Assessment: $e');
      return false;
    }
  }

  static Future<bool> deleteAssessment(int assessmentId) async {
    try {
      final accessToken = await storage.read(key: "access_token");

      final url = Uri.parse('$ipAddress:8000/api/assessment-creation/$assessmentId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 204) {
        print('Assessment deleted successfully');
        return true;
      } else {
        print('Failed to delete Assessment. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Assessment: $e');
      return false;
    }
  }
}