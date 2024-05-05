import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/main.dart';

class WeeklyTopics{
  static int? _id;
  static int? _week_number;
  static String? _topic;
  static String? _description;
  static List<dynamic>? _clo;
  static String? _assessments;
  static int? _course_outline;

  static int? get id => _id;

  static set id(int? value){
    _id = value;
  }

  static int? get week_number => _week_number;

  static set week_number(int? value){
    _week_number = value;
  }

  static String? get topic => _topic;

  static set topic(String? value){
    _topic = value;
  }

  static String? get description => _description;

  static set description(String? value){
    _description = value;
  }

  static List<dynamic>? get clo => _clo;

  static set clo(List<dynamic>? value){
    _clo = value;
  }

  static String? get assessments => _assessments;

  static set assessments(String? value){
    _assessments = value;
  }

  static int? get course_outline => _course_outline;

  static set course_outline(int? value){
    _course_outline = value;
  }

  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true)
  );

  static Future<bool> addWeeklyTopics(int weekNumber, String topic, String description, List<dynamic> clos, String assessments, int courseOutlineId) async {
    final accessToken = await storage.read(key: 'access_token');
    final url = Uri.parse('$ipAddress:8000/api/weekly-topics');
    try{
      final List<int> closIds = clos.map((item) {
        if (item is int) {
          return item;
        } else if (item is Map<String, dynamic> && item.containsKey('id')) {
          return item['id'] as int;
        }
        return null;
      }).whereType<int>().toList(); // Filter out non-integer values

      final response = await http.post(
          url,
          headers: {
            'Authorization' : 'Bearer $accessToken',
            'Content-Type' : 'application/json'
          },
          body: jsonEncode({
            'week_number' : weekNumber,
            'topic' : topic,
            'description' : description,
            'clo': closIds,
            'assessments' : assessments,
            'course_outline' : courseOutlineId
          }));
      if(response.statusCode == 201){
        print('Weekly Topics added Successfully');
        return true;
      } else {
        print('Failed to add Weekly Topics. Status Code: ${response.statusCode} : ${response.body}');
        return false;
      }
    } catch(e){
      print('Exception while adding Weekly Topics: $e');
      return false;
    }
  }

  static Future<List<dynamic>> fetchWeeklyTopicsByCourseOutline(
      int courseOutlineId) async {
    final accessToken = await storage.read(key: 'access_token');
    final url = Uri.parse('$ipAddress:8000/api/outline/$courseOutlineId/weekly-topics');
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

  static Future<Map<String, dynamic>?> getWeeklyTopicById(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/weekly-topics/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to load weekly topic. Status Code: ${response.statusCode} : ${response.body}");
      return {};
    }
  }

  static Future<bool> deleteWeeklyTopic(int weeklyTopicId) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/weekly-topics/$weeklyTopicId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 204) {
        print('Weekly Topic deleted successfully');
        return true;
      } else {
        print('Failed to delete Weekly Topic. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Weekly Topic: $e');
      return false;
    }
  }

}