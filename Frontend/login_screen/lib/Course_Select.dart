import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Assessment_Page.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Course_Page.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/PEO_Page.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Course_Select extends StatefulWidget {
  static bool isForAssessment = false;

  @override
  State<Course_Select> createState() => _Course_SelectState();
}

class _Course_SelectState extends State<Course_Select> {
  final int campus_id = Campus.id;
  late Future<List<dynamic>> courseFuture;

  @override
  void initState() {
    super.initState();
    courseFuture = Course.fetchCoursesbyCampusId(campus_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text('Course Select Page',
              style: CustomTextStyles.headingStyle(fontSize: 22)),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: courseFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final courses = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(course['title'],
                                style:
                                CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),
                          onTap: () async {
                            var courseData = await Course.getCoursebyId(courses[index]['id']);
                            if (courseData != null) {
                              Course.id = courseData['id'];
                              Course.title = courseData['title'];
                              Course.code = courseData['code'];
                              Course.theory_credits = courseData['theory_credits'];
                              Course.lab_credits = courseData['lab_credits'];
                              Course.course_type = courseData['course_type'];
                              Course.required_elective = courseData['required_elective'];
                              Course.prerequisite = courseData['prerequisite'];
                              Course.description = courseData['description'];
                              Course.pecContent = courseData['pec_content'];
                              Course.campus = courseData['campus'];

                              if(Course_Select.isForAssessment){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Assessment_Page()));
                              }
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
