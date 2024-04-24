import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'main.dart';
import 'package:http/http.dart' as http;

class Campus {
  static int _id = 0;
  static String _name = '';
  static String _vision = '';
  static String _mission = '';
  static int _university_id = 0;
  static String _university_name = '';

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

  static int get university_id => _university_id;

  static set university_id(int value) {
    _university_id = value;
  }

  static String get mission => _mission;

  static set mission(String value) {
    _mission = value;
  }

  static String get vision => _vision;

  static set vision(String value) {
    _vision = value;
  }

  static set name(String value) {
    _name = value;
  }

  static String get university_name => _university_name;

  static set university_name(String value) {
    _university_name = value;
  }

  static Future<List<dynamic>> fetchCampusesByUniversityId(
      int university_id) async {
    const ipAddress = MyApp.ip;
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    final accessToken = await storage.read(key: "access_token");
    final url =
        Uri.parse('$ipAddress:8000/api/university/${university_id}/campus');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load campuses');
    }
  }
  // static Future<Map<String, dynamic>?> getCampusByCampusId(int Campus_id,int University_id) async {
  //   final campuses = await fetchCampusesByUniversityId(University_id); // Assuming campusesFuture is a Future<List<dynamic>> containing campus data
  //   if (campuses != null) {
  //     for (var campus in campuses) {
  //       if (campus['id'] == Campus_id) {
  //         print(campus);
  //         return campus;
  //       }
  //     }
  //   }
  //   return null;
  // }

  static Future<Map<String, dynamic>?> getCampusById(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/campus/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to load Campus");
      return {};
    }
  }

  static Future<bool> createCampus(
      String name, String mission, String vision, int University_id) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/campus');
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
          'university': University_id
        }),
      );
      if (response.statusCode == 201) {
        print('Campus Created successfully');
        return true;
      } else {
        print('Failed to create Campus. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Campus: $e');
      return false;
    }
  }

  static Future<bool> deleteCampus(int campusId) async {
    try {
      final accessToken = await storage.read(key: "access_token");

      final campusUrl = Uri.parse('$ipAddress:8000/api/campus/$campusId');
      final campusResponse = await http.delete(
        campusUrl,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (campusResponse.statusCode == 204) {
        print('Campus deleted successfully');
        return true;
      } else {
        print(
            'Failed to delete Campus. Status code: ${campusResponse.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Campus: $e');
      return false;
    }
  }
}
