
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
        return false;
      }
    } catch (e) {
      print('Exception while creating Objective: $e');
      return false;
    }
  }

  static  Future<List<dynamic>> fetchObjectivesByCourseId(int course_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/course/$course_id/objective');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to load Outline');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getObjectivebyObjectiveId(int
  ObjectiveId)
  async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/objective/$ObjectiveId');
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
      throw Exception('Failed to fetch Objective with ID $ObjectiveId');
    }
  }


  static Future<bool> deleteObjective(int ObjectiveId) async {
    try {
      final accessToken = await storage.read(key: "access_token");

      final url = Uri.parse('$ipAddress:8000/api/objective/$ObjectiveId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        print('Objective deleted successfully');
        return true;
      } else {
        print('Failed to delete Objective. Status code: ${response
            .statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Objective: $e');
      return false;
    }
  }



}