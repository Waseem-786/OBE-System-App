import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';

class Assessment {
  static const ipAddress = MyApp.ip;
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static int _id = 0;
  static String? _name;
  static int _teacher = 0;
  static int _batch = 0;
  static int _course = 0;
  static int _total_marks = 0;
  static String? _instructions;
  static String? _duration;
  static List<int>? _CLOs;
  static String? _Part_desc;
  static int _Part_marks = 0;
  static List<Map<String, dynamic>>? _questions;

  static List<Map<String, dynamic>>? get questions => _questions;
  static set questions(List<Map<String, dynamic>>? value) {
    _questions = value;
  }

  static void addQuestion(Map<String, dynamic> question) {
    _questions?.add(question);
  }

  static void addPartToQuestion(int questionIndex, Map<String, dynamic> part) {
    if (_questions != null && questionIndex < _questions!.length) {
      _questions![questionIndex]['parts'].add(part);
    }
  }

  static List<int>? get CLOs => _CLOs;

  static set CLOs(List<int>? value) {
    _CLOs = value;
  }

  static String? get Part_desc => _Part_desc;

  static set Part_desc(String? value) {
    _Part_desc = value;
  }

  static int get Part_marks => _Part_marks;

  static set Part_marks(int value) {
    _Part_marks = value;
  }

  static String? get duration => _duration;

  static set duration(String? value) {
    _duration = value;
  }

  static int get id => _id;

  static set id(int value) {
    _id = value;
  }

  static String? get name => _name;

  static set name(String? value) {
    _name = value;
  }

  static int get teacher => _teacher;

  static set teacher(int value) {
    _teacher = value;
  }

  static int get batch => _batch;

  static set batch(int value) {
    _batch = value;
  }

  static int get course => _course;

  static set course(int value) {
    _course = value;
  }

  static int get total_marks => _total_marks;

  static set total_marks(int value) {
    _total_marks = value;
  }

  static String? get instructions => _instructions;

  static set instructions(String? value) {
    _instructions = value;
  }

  static Future<List<dynamic>> fetchAllAssessments(
      int batchId, int courseId, int teacherId) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse(
        '$ipAddress:8000/api/assessments?batch_id=$batchId&course_id=$courseId&teacher_id=$teacherId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getAssessmentById(int id) async {
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/complete-assessment/$id');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      return {};
    }
  }

  static Future<bool> updateCompleteAssessment(
      int id,
      String name,
      int teacher,
      int batch,
      int course,
      int totalMarks,
      String duration,
      String instruction,
      List<Map<String, dynamic>> questions) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/complete-assessment/$id');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'name': name,
          'teacher': teacher,
          'batch': batch,
          'course': course,
          'total_marks': totalMarks,
          'duration': duration,
          'instruction': instruction,
          'questions': questions,
        }),
      );
      if (response.statusCode == 200) {
        print('Assessment updated successfully');
        return true;
      } else {
        print(
            'Failed to update Assessment. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while updating Assessment: $e');
      return false;
    }
  }

  static Future<bool> createCompleteAssessment(
      String name,
      int teacher,
      int batch,
      int course,
      int totalMarks,
      String duration,
      String instruction,
      List<Map<String, dynamic>> questions) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/complete-assessment');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "teacher": teacher,
          "batch": batch,
          "course": course,
          "total_marks": totalMarks,
          "duration": duration,
          "instruction": instruction,
          "questions": questions,
        }),
      );
      print(response.body);
      if (response.statusCode == 201) {
        print('Assessment Created successfully');
        return true;
      } else {
        print(
            'Failed to create Assessment. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while creating Assessment: $e');
      return false;
    }
  }

  static Future<bool> deleteAssessment(int assessmentId) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url =
      Uri.parse('$ipAddress:8000/api/complete-assessment/$assessmentId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 204) {
        print('Assessment deleted successfully');
        return true;
      } else {
        print(
            'Failed to delete Assessment. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception while deleting Assessment: $e');
      return false;
    }
  }

  static Future<List<dynamic>> refineCompleteAssessment(
      String name,
      int teacher,
      int batch,
      int course,
      int totalMarks,
      String duration,
      String instruction,
      List<Map<String, dynamic>> questions) async {
    try {
      final accessToken = await storage.read(key: "access_token");
      final url = Uri.parse('$ipAddress:8000/api/assessment/refine-complete');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "teacher": teacher,
          "batch": batch,
          "course": course,
          "total_marks": totalMarks,
          "duration": duration,
          "instruction": instruction,
          "questions": questions,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print(
            'Failed to refine assessment. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception while refining assessment: $e');
      return [];
    }
  }
}
