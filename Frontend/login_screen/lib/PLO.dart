
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class PLO{

  static int _id = 0;
  static String? _description;

  static String? get name => _name;

  static set name(String? value) {
    _name = value;
  }

  static String? _name;

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String? get description => _description;

  static set description(String? value) {
    _description = value;
  }



  static Future<bool> createPLO(String name,String description,int deptid)
  async {
    try {
      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );
      final accessToken = await storage.read(key: "access_token");
      const ipAddress = MyApp.ip;
      final url = Uri.parse('$ipAddress:8000/api/plo');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'program':deptid

        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        print(
            'Failed to create PLO. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating PLO: $e');
      return false;
    }
  }
  static Future<List<dynamic>> fetchPLO() async {
    final ipAddress = MyApp.ip;
    const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/plo');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to Load PLOs');
    }
  }

  static Future<Map<String, dynamic>?> getPLObyPLOId(int PLO_id) async {
    final plos = await fetchPLO();
    for (var plo in plos) {
      if (plo['id'] == PLO_id) {
        return plo;
      }
    }
    return null;
  }


}