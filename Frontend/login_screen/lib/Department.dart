import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Department {
  static int _id = 0;
  static String _name = '';
  static String _vision = '';
  static String _mission = '';
  static int _campus_id = 0;
  static String _campus_name = '';

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

  static String get vision => _vision;

  static set vision(String value) {
    _vision = value;
  }

  static String get mission => _mission;

  static set mission(String value) {
    _mission = value;
  }


  static int get campus_id => _campus_id;

  static set campus_id(int value) {
    _campus_id = value;
  }

  static String get campus_name => _campus_name;

  static set campus_name(String value) {
    _campus_name = value;
  }

  static Future<List<dynamic>> getDepartmentsbyCampusid(campusId) async
  {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/campus/$campusId/department');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getDepartmentById(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/department/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to load Department");
      return {};
    }
  }
  static Future<bool> createDepartment(String name, String mission, String vision,int campusId) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/department');
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
          'campus':campusId
        }),
      );
      if (response.statusCode == 201) {
        print('Department Created successfully');
        return true;
      } else {
        print('Failed to create Department. Status code: ${response.statusCode}');
        print('Failed to create Department. Status body: ${response.body}');

        return false;
      }
    } catch (e) {
      print('Exception while creating Department: $e');
      return false;
    }
  }

  static Future<bool> deleteDepartment(int departmentId) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/department/$departmentId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        print('Department deleted successfully');
        return true;
      } else {
        print('Failed to delete Department. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Department: $e');
      return false;
    }
  }
  static Future<bool> updateDepartment(int id,String name,String mission,String vision) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/department/$id');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'mission': mission,
          'vision': vision,
        }),
      );
      if (response.statusCode == 200) {
        print('Department updated successfully');
        return true;
      } else {
        print('Failed to update Department. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while updating Department: $e');
      return false;
    }
  }
}