import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Permission {
  static int _id = 0;
  static String _name = "";
  static String _codename = "";
  static List<dynamic> _Userpermissions = [];

  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static int get id => _id;
  static set id(int value) {
    _id = value;
  }

  static String get name => _name;
  static set name(String value) {
    _name = value;
  }

  static String get codename => _codename;
  static set codename(String value) {
    _codename = value;
  }

  static List<dynamic> get Userpermissions => _Userpermissions;
  static set Userpermissions(List<dynamic> value) {
    _Userpermissions = value;
  }

  //Get all Permissions of Specific Group/Role
  static  Future<List> fetchPermissionsbyGroupId(int groupId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/groups/$groupId/permissions');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load Permissions');
      return [];
    }
  }

  //Add Permissions in Specific Group
  static Future<String> addPermissionsToGroup(int groupId, List<int> permissions) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/groups/$groupId/permissions');

    final Map<String, dynamic> data = {
      'permissions': permissions,
    };

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 400) {
      // Return the message from the response
      final responseData = jsonDecode(response.body);
      return responseData['message'];
    } else {
      // Return error message
      return 'Error: ${response.statusCode}';
    }
  }

  //Get All Permissions
  static Future<List> getAllPermissions() async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/permissions');

    final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      // Return the permissions as a list
      return jsonDecode(response.body);
    } else {
      // If there's an error, return an empty list
      return [];
    }
  }


  //Get All permissions of Specific User
  static Future<List> getUserPermissions(int userId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/user/$userId/permissions');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      // Return the permissions as a list
      _Userpermissions =  jsonDecode(response.body);
      return _Userpermissions;
    } else {
      // If there's an error, return an empty list
      return [];
    }
  }

  // Search for a permission by codename
  static Future<bool> searchPermissionByCodename(String codename) async {
    // Check if user permissions are available
    if (_Userpermissions.isNotEmpty) {
      // Search for the permission by codename in user permissions
      for (var permission in _Userpermissions) {
        if (permission['codename'] == codename) {
          print(codename);
          return true;
        }
      }
    }
    // If permission not found, return false
    return false;
  }



}