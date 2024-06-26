
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Batch{

  static const ipAddress = MyApp.ip;
  static int _id=0;

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String _name = "";

  static List<dynamic> _sections = [];

  static List<dynamic> get sections => _sections;

  static set sections(List<dynamic> value) {
    _sections = value;
  }

  static String get name => _name;

  static set name(String value) {
    _name = value;
  }





  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static Future<bool> createBatch(String name,int deptId ,List<String> sections)
  async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/batch');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'department' : deptId,
          'sections' : sections
        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        print(
            'Failed to create Batch. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Batch: $e');
      return false;
    }
  }

  static  Future<List<dynamic>> getBatchBydeptId(int dept_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/department/$dept_id/batch');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to load Batches');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getBatchbyBatchId(int batchId)
  async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/batch/$batchId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      return {};
    }
  }



    static updateBatch(int batchId, String batchName, List<String> sectionNames) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/batch/$batchId');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': batchName,
          'sections' : sectionNames
        }),
      );
      if (response.statusCode == 200) {
        print('Batch updated successfully');
        return true;
      } else {
        print('Failed to update Batch. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while updating Batch: $e');
      return false;
    }
  }

}
