import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Campus_Profile.dart';
import 'package:login_screen/Create_Campus.dart';
import 'package:login_screen/University.dart';

import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Campus_Page extends StatefulWidget{

  @override
  State<Campus_Page> createState() => _Campus_PageState();
}

class _Campus_PageState extends State<Campus_Page> {

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
                            var campusData = await Campus.getCampusByCampusId(campuses[index]['id'],university_id);
                            if (campusData != null) {
                              Campus.id = campusData['id'];
                              Campus.name = campusData['name'];
                              Campus.mission = campusData['mission'];
                              Campus.vision = campusData['vision'];
                              Campus.university_id = campusData['university'];
                              Campus.university_name = campusData['university_name'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Campus_Profile(),
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