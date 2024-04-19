import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Create_Campus.dart';
import 'package:login_screen/Create_Department.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Department_Profile.dart';
import 'package:http/http.dart' as http;
import 'package:login_screen/main.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Department_Page extends StatefulWidget{

  @override
  State<Department_Page> createState() => _Department_PageState();
}

class _Department_PageState extends State<Department_Page> {

  final int campus_id = Campus.id;

  late Future<List<dynamic>> DepartmentFuture;

  @override
  void initState() {
    super.initState();
    DepartmentFuture = fetchDepartments();
  }
  Future<Map<String, dynamic>?> getCampusById(int id) async {
    final campuses = await DepartmentFuture; // Assuming campusesFuture is a Future<List<dynamic>> containing campus data
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

  Future<List<dynamic>> fetchDepartments() async
  {
    final ipAddress = MyApp.ip;

    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/campus/${campus_id}/department');
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
            future: DepartmentFuture,
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
                            var department_data = await getCampusById(campuses[index]['id']);
                            if (department_data != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    Department_Profile(department_data: department_data)
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
                    MaterialPageRoute(builder: (context) => Create_Department()),
                  );
                },
                ButtonText: 'Add Department',
                ButtonWidth: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }

}