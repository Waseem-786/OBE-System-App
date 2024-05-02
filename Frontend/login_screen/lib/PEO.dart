import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class PEO {
  static int _id = 0;
  static String? _description;

  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String? get description => _description;

  static set description(String? value) {
    _description = value;
  }

  static Future<bool> createPEO(String description, int deptid) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/peo');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'description': description, 'program': deptid}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create PEO. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating PEO: $e');
      return false;
    }
  }

  static Future<List<dynamic>> fetchPEO() async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/peo');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to Load PEOs');
    }
  }

  static Future<Map<String, dynamic>?> getPEObyPEOId(int PEO_id) async {
    final peos = await fetchPEO();
    for (var peo in peos) {
      if (peo['id'] == PEO_id) {
        return peo;
      }
    }
    return null;
  }

  static Future<bool> deletePEO(int peoId) async {
    try {
      final accessToken = await storage.read(key: "access_token");

      final url = Uri.parse('$ipAddress:8000/api/peo/$peoId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        print('PEO deleted successfully');
        return true;
      } else {
        print('Failed to delete PEO. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting PEO: $e');
      return false;
    }
  }
}