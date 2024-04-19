import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Token {
  static String accessToken = '';
  static String refreshToken = '';
  static String ipAddress = MyApp.ip;

  static Future<bool> verify(String accessToken) async {
    final response = await http.post(
      Uri.parse('$ipAddress:8000/auth/jwt/verify'),
      body: {
        'token': accessToken,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      return false;
    }
    return false;
  }


  // function to store tokens when login is performed
  static Future<void> storeTokens(Map<String, dynamic> tokens) async {
    // For encryption of tokens
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );

    await storage.write(key: "access_token", value: tokens['access']);
    await storage.write(key: "refresh_token", value: tokens['refresh']);
  }

}
