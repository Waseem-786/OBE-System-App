import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_screen/Create_University.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/University.dart';
import 'package:login_screen/University_Profile.dart';

class University_Page extends StatefulWidget {
  @override
  State<University_Page> createState() => _University_PageState();
}

class _University_PageState extends State<University_Page> {
  late Future<List<dynamic>> universitiesFuture;

  @override
  void initState() {
    super.initState();
    universitiesFuture = fetchUniversities();
  }

  Future<Map<String, dynamic>?> getUniversityById(int id) async {
    final universities = await universitiesFuture;
    if (universities != null) {
      for (var university in universities) {
        if (university['id'] == id) {
          print(university);
          return university;
        }
      }
    }
    return null;
  }




  Future<List<dynamic>> fetchUniversities() async
  {
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('http://192.168.0.105:8000/api/university');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
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
              style: CustomTextStyles.headingStyle(fontSize: 22)
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: universitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final universities = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: universities.length,
                    itemBuilder: (context, index) {
                      final university = universities[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(university['name'],style: CustomTextStyles.bodyStyle(fontSize: 17),),
                          ),
                          onTap:  () async {
                            // call of a function to get the data of that user whose id is passed and id is
                            // passed by tapping the user
                            var user = await getUniversityById(universities[index]['id']);
                            if (user != null) {
                              University.id = user['id'];
                              University.name = user['name'];
                              University.vision = user['vision'];
                              University.mission = user['mission'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        University_Profile()),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20,top: 12),
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
