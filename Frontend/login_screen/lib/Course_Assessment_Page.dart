import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Campus_Profile.dart';
import 'package:login_screen/Course_Assessment.dart';
import 'package:login_screen/Course_Assessment_Profile.dart';
import 'package:login_screen/Create_Campus.dart';
import 'package:login_screen/Create_Course_Assessment_Page.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/University.dart';

import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Course_Assessment_Page extends StatefulWidget {
  @override
  State<Course_Assessment_Page> createState() => _Course_Assessment_PageState();
}

class _Course_Assessment_PageState extends State<Course_Assessment_Page> {
  final int course_outline_id = Outline.id;
  late Future<List<dynamic>> CourseAssessment;

  @override
  void initState() {
    super.initState();
    CourseAssessment =
        Course_Assessment.fetchCourseAssessment(course_outline_id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        CourseAssessment =
            Course_Assessment.fetchCourseAssessment(course_outline_id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Course Assessment Page',
            style: CustomTextStyles.headingStyle(fontSize: 22)),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: CourseAssessment,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final courseAssessments = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: courseAssessments.length,
                    itemBuilder: (context, index) {
                      final item = courseAssessments[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(item['name'],
                                style:
                                    CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),
                          trailing: InkWell(
                            onTap: () async {
                              var itemData = await Course_Assessment
                                  .fetchSingleCourseAssessment(
                                      courseAssessments[index]['id']);
                              if (itemData != null) {
                                Course_Assessment.id = itemData['id'];
                                Course_Assessment.name = itemData['name'];
                                Course_Assessment.count = itemData['count'];
                                Course_Assessment.weight =
                                    double.tryParse(itemData['weight'])!;
                                Course_Assessment.clo =
                                    List<int>.from(itemData['clo']);
                                Course_Assessment.course_outline =
                                    itemData['course_outline'];

                                Navigator.push(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (context) =>
                                        Create_Course_Assessment_Page(
                                      isUpdate: true,
                                      courseAssessmentData: itemData,
                                    ),
                                  ),
                                ).then((result) {
                                  if (result != null && result) {
                                    // Set the state of the page here
                                    setState(() {
                                      CourseAssessment = Course_Assessment
                                          .fetchCourseAssessment(
                                              course_outline_id);
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  size: 32,
                                  Icons.edit_square,
                                  color: Color(0xffc19a6b),
                                )),
                          ),
                          onTap: () async {
                            var itemData = await Course_Assessment
                                .fetchSingleCourseAssessment(
                                    courseAssessments[index]['id']);
                            if (itemData != null) {
                              Course_Assessment.id = itemData['id'];
                              Course_Assessment.name = itemData['name'];
                              Course_Assessment.count = itemData['count'];
                              Course_Assessment.weight =
                                  double.tryParse(itemData['weight'])!;
                              Course_Assessment.clo =
                                  List<int>.from(itemData['clo']);
                              Course_Assessment.course_outline =
                                  itemData['course_outline'];

                              Navigator.push(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (context) =>
                                        Course_Assessment_Profile(),
                                  )).then((result) {
                                if (result != null && result) {
                                  // Set the state of the page here
                                  setState(() {
                                    CourseAssessment =
                                        Course_Assessment.fetchCourseAssessment(
                                            course_outline_id);
                                  });
                                }
                              });
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
              margin: const EdgeInsets.only(bottom: 20, top: 12),
              child: Custom_Button(
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Create_Course_Assessment_Page()),
                  );
                },
                ButtonText: 'Add Course Assessment',
                ButtonWidth: 260,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
