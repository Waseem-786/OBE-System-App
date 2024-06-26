import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Role {
  static int _id = 0;
  static String _name = "";
  static List<dynamic> _group_permissions = [];
  static List<dynamic> _user = [];
  static int _university_id = 0;
  static String _university_name = "";
  static int _campus_id=0;
  static String _campus_name = "";
  static int _department_id=0;
  static String _department_name = "";

  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String get name => _name;
  static set name(String value) {
    _name = value;
  }

  static List<dynamic> get group_permissions => _group_permissions;
  static set group_permissions(List<dynamic> value) {
    _group_permissions = value;
  }

  static List<dynamic> get user => _user;
  static set user(List<dynamic> value) {
    _user = value;
  }

  static int get university_id => _university_id;
  static set university_id(int value) {
    _university_id = value;
  }

  static String get university_name => _university_name;
  static set university_name(String value) {
    _university_name = value;
  }

  static int get campus_id => _campus_id;
  static set campus_id(int value) {
    _campus_id = value;
  }

  static String get campus_name => _campus_name;
  static set campus_name(String value) {
    _campus_name = value;
  }

  static int get department_id => _department_id;
  static set department_id(int value) {
    _department_id = value;
  }

  static String get department_name => _department_name;
  static set department_name(String value) {
    _department_name = value;
  }


  //Create Top level Roles
  static Future<bool> createTopLevelRole(
      String name,List<dynamic> users, List<dynamic>
      permissions) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse
        ('$ipAddress:8000/api/top/role');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'users':users,
          'permissions':permissions
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create Role. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Role: $e');
      return false;
    }
  }


  //Get all Top level Roles
  static Future<List<dynamic>> fetchTopLevelRoles() async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/top/role');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to load Roles');
      return [];
    }
  }


  //Create University level Roles
  static Future<bool> createUniversityLevelRole(
      String name, int university_id,List<dynamic> users, List<dynamic>
      permissions)
  async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse
        ('$ipAddress:8000/api/university/role/$university_id');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'users':users,
          'permissions':permissions
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create Role. Status code: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Exception while creating Role: $e');
      return false;
    }
  }


  //Get all University level Roles
  static Future<List<dynamic>> fetchUniLevelRoles(int university_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/university/role/$university_id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to load Roles');
      return [];
    }
  }


  //Create Campus level Roles
  static Future<bool> createCampusLevelRole(
      String name, int campus_id,List<dynamic> users, List<dynamic>
      permissions) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse
        ('$ipAddress:8000/api/campus/role/$campus_id');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'users':users,
          'permissions' : permissions
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create Role. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Role: $e');
      return false;
    }
  }

  //Get all Campus level Roles
  static Future<List<dynamic>> fetchCampusLevelRoles(int campus_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/campus/role/$campus_id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to load Roles');
      return [];
    }
  }

  //Create Department level Roles
  static Future<bool> createDepartmentLevelRole(
      String name, int department_id,List<dynamic> users, List<dynamic>
      permissions) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse
        ('$ipAddress:8000/api/department/role/$department_id');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'users' : users,
          'permissions': permissions

        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create Role. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Role: $e');
      return false;
    }
  }

  //Get all Department level Roles
  static Future<List<dynamic>> fetchDeptLevelRoles(int department_id)
  async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/department/role/$department_id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      print('Failed to load Roles');
      return [];
    }
  }



  //Get Single Role data
  static Future<Map<String, dynamic>?> getRolebyRoleId(int roleId)
  async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/role/$roleId');
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

  //Delete Single Role
  static Future<bool> deleteRole(int roleId) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/role/$roleId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        print('Role deleted successfully');
        return true;
      } else {
        print('Failed to delete Role. Status code: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Exception while deleting Role: $e');
      return false;
    }
  }

  //  Update Single Role





  //Get all Groups for Specific User
  static Future<List> getUserGroups(int userId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/user/$userId/groups');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      // Return the groups as a list
      return jsonDecode(response.body);
    } else {
      // If there's an error, return an empty list
      return [];
    }
  }



}

