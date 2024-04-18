import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_screen/Create_University.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';

class University_Page extends StatefulWidget {
  @override
  State<University_Page> createState() => _University_PageState();
}

class _University_PageState extends State<University_Page> {
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  @override
  void initState() {
    super.initState();
    storage.read(key: "access_token").then((accessToken) {
      fetchUniversities(accessToken!);
    });
  }
  List<dynamic> universities = [];

  Future<void> fetchUniversities(String accessToken) async {
    print(accessToken);
    final response = await http.get(
      Uri.parse('http://192.168.0.103:8000/api/university'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print("response.body");
    if (response.statusCode == 200) {
      print("Success");

      // all the data of the users is stored in responseData
      universities = jsonDecode(response.body);
      // Handle the response data
      print("Hellog");
      print(universities);

      setState(() {}); // Refresh the UI after fetching data
    } else {
      throw Exception('Failed to load universities');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'University Page',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: universities.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(universities[index]['name']),
                  ),
                );
              },
            ),
          ),
          Center(
            child: Container(
              child: Custom_Button(
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Create_University()),
                  );
                },
                ButtonText: 'Add University',
                ButtonWidth: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}