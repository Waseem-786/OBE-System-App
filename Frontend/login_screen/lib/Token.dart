import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Token {
  static String accessToken = '';
  static String refreshToken = '';
  static String ipAddress = MyApp.ip;

  // For encryption of tokens
  static final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static Future<bool> verifyToken(String accessToken) async {
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

    await storage.write(key: "access_token", value: tokens['access']);
    await storage.write(key: "refresh_token", value: tokens['refresh']);
  }


  static Future<String?> readAccessToken() async {
    try {
      final accessToken = await storage.read(key: "access_token");
      return accessToken;
    } catch (e) {
      print("Error reading access token: $e");
      return null;
    }
  }


  static Future<String?> readRefreshToken() async {
    try {
      final refreshToken = await storage.read(key: "refresh_token");
      return refreshToken;
    } catch (e) {
      print("Error reading access token: $e");
      return null;
    }
  }

  static void deleteTokens() {
    storage.delete(key: "access_token");
    storage.delete(key: "refresh_token");
  }

  // function to post the request to the server to get tokens by passing
  // username and password
  static Future<String?> getToken(String username, String password) async {
    String errorMessage;
    try {
      final response = await http.post(
        Uri.parse('$ipAddress:8000/auth/jwt/create'),
        body: {
          'username': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // function call to store tokens
        await Token.storeTokens(responseData);
        return "ok";
      } else if (response.statusCode == 400){
          errorMessage = 'Please Enter Credentials';
      }
      else if (response.statusCode == 401) {
        errorMessage = '*Incorrect Username & Password';
      }
      else {
        errorMessage = response.body;
      }
      return errorMessage;
    } catch (e) {
        errorMessage = "Something went wrong. Server Error";
    }
  }

}
