import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UniversityDropdown extends StatefulWidget {
  @override
  _UniversityDropdownState createState() => _UniversityDropdownState();
}

class _UniversityDropdownState extends State<UniversityDropdown> {
  late Future<List<Map<String, dynamic>>> universities;
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    storage.read(key: "access_token").then((accessToken) {
      universities = fetchUniversities(accessToken!);
    });
  }

  Future<List<Map<String, dynamic>>> fetchUniversities(
      String accessToken) async {
    final response = await http.get(
      Uri.parse('http://192.168.43.101:8000/api/university'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> universities = [];
      data.forEach((element) {
        universities.add({'id': element['id'], 'name': element['name']});
      });
      return universities;
    } else {
      throw Exception('Failed to load universities');
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: universities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data');
        } else {
          List<Map<String, dynamic>> universities = snapshot.data!;
          return DropdownButtonFormField<String>(
            items: universities.map((Map<String, dynamic> university) {
              return DropdownMenuItem<String>(
                value: university['name'],
                child: Text(university['name']),
              );
            }).toList(),
            onChanged: (String? value) {
              // Handle dropdown value change
            },
            decoration: InputDecoration(
              labelText: 'University',
              hintText: 'Select University',
              border: OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }

}
