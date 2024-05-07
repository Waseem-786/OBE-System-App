import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class CourseBooks {
  static const ipAddress = MyApp.ip;
  static int _id = 0;

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String? _bookTitle;
  static String? _bookType;
  static String? _description;
  static String? _link;

  static String? get bookTitle => _bookTitle;

  static set bookTitle(String? value) {
    _bookTitle = value;
  }

  static String? get bookType => _bookType;

  static set bookType(String? value) {
    _bookType = value;
  }

  static String? get description => _description;

  static set description(String? value) {
    _description = value;
  }

  static String? get link => _link;

  static set link(String? value) {
    _link = value;
  }

  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));


  static Future<bool> createBook(String bookTitle, String? bookType, String description, String link, int outlineId) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/book');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': bookTitle,
          'book_type': bookType,
          'description': description,
          'link': link,
          'course_outline': outlineId,
        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create Book. Status code: ${response.statusCode}');
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Exception while creating Book: $e');
      return false;
    }
  }

  static  Future<List<dynamic>> fetchBooksByOutlineId(int outline_id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/outline/$outline_id/book');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load Outline');
      return [];
    }
  }

  static  Future<Map<String, dynamic>?> getBookbyId(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/book/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load Book');
      return {};
    }
  }


  static Future<bool> deleteBook(int bookId) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/book/$bookId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Exception while deleting Book: $e');
      return false;
    }
  }
  static Future<bool> updateCourseBook(int id,String bookTitle, String? bookType, String description, String link) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/book/$id');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': bookTitle,
          'book_type': bookType,
          'description': description,
          'link': link,
        }),
      );
      if (response.statusCode == 200) {
        print('Course Book updated successfully');
        return true;
      } else {
        print('Failed to update Course Book. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while updating Course Book: $e');
      return false;
    }
  }
}




