import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Course_Page.dart';
import 'package:login_screen/University.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Department_Select.dart';

class Campus_Select extends StatefulWidget {
  @override
  State<Campus_Select> createState() => _Campus_SelectState();
}

class _Campus_SelectState extends State<Campus_Select> {
  final int university_id = University.id;
  late Future<List<dynamic>> campusesFuture;

  @override
  void initState() {
    super.initState();
    campusesFuture = Campus.fetchCampusesByUniversityId(university_id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Campus Select Page',
            style: CustomTextStyles.headingStyle(fontSize: 22)),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: campusesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(campus['name'],
                                style:
                                CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),
                          onTap: () async {
                            var campusData = await Campus.getCampusById(
                                campuses[index]['id']);
                            if (campusData != null) {
                              Campus.id = campusData['id'];
                              Campus.name = campusData['name'];
                              Campus.mission = campusData['mission'];
                              Campus.vision = campusData['vision'];
                              Campus.university_id = campusData['university'];
                              Campus.university_name =
                              campusData['university_name'];
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Course_Page()));
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
        ],
      ),
    );
  }
}
