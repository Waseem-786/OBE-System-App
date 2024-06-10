import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Approval {

  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static Future<bool> createApprovalChain(int campusId, List<Map<String, dynamic>> steps) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/approval-chain');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'campus_id': campusId,
        'steps': steps,
      }),
    );
    print(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create approval chain');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getApprovalChainDetails(int chainId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/approval-chain/$chainId');
    final response = await http.get(
        url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch approval chain details');
    }
  }

  static Future<List<dynamic>> getApprovalChainsByCampus(int campusId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/approval-chains/$campusId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch approval chains');
    }
  }

  static Future<void> approveRequest(int requestId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/approve-reject-process/$requestId');
    final response = await http.put(
        url,
        body: {'status': 'Approved'},
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to approve request');
    }
  }

  static Future<void> rejectRequest(int requestId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/approve-reject-process/$requestId');
    final response = await http.put(
        url,
        body: {'status': 'Rejected'},
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reject request');
    }
  }

  static Future<Map<String, dynamic>> createCLOUpdateRequest(Map<String, dynamic> data) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/clo-update-request');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create CLO update request');
    }
  }

}
