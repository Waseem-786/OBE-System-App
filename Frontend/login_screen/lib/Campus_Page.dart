import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Campus_Profile.dart';
import 'package:login_screen/Create_Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Campus_Page extends StatefulWidget{



  @override
  State<Campus_Page> createState() => _Campus_PageState();
}

class _Campus_PageState extends State<Campus_Page> {

  late Future<List<dynamic>> campusesFuture;

  @override
  void initState() {
    super.initState();
    campusesFuture = fetchCampuses();
  }
  Future<Map<String, dynamic>?> getCampusById(int id) async {
    final campuses = await campusesFuture; // Assuming campusesFuture is a Future<List<dynamic>> containing campus data
    if (campuses != null) {
      for (var campus in campuses) {
        if (campus['id'] == id) {
          print(campus);
          return campus;
        }
      }
    }
    return null;
  }

  Future<List<dynamic>> fetchCampuses() async
  {
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('http://192.168.0.105:8000/api/campus');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load campuses');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Campus Page',style: CustomTextStyles.headingStyle(fontSize: 22)
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: campusesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final campuses = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: campuses.length,
                    itemBuilder: (context, index) {
                      final campus = campuses[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(campus['name'], style: CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),
                          onTap: () async {
                            var campusData = await getCampusById(campuses[index]['id']);
                            if (campusData != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Campus_Profile(campus_data: campusData),
                              ));
                              // Perform actions with campusData
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
              margin: EdgeInsets.only(bottom: 20, top: 12),
              child: Custom_Button(
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Create_Campus()),
                  );
                },
                ButtonText: 'Add Campus',
                ButtonWidth: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }

}