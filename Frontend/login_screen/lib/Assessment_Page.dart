import 'package:flutter/material.dart';
import 'package:login_screen/Assessment.dart';
import 'package:login_screen/Create_Assessment.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Custom_Widgets/PermissionBasedButton.dart';
import 'package:login_screen/Permission.dart';
import 'Assessment_Profile.dart';
import 'Custom_Widgets/PermissionBasedIcon.dart'; // Import Permission class

class Assessment_Page extends StatefulWidget {
  @override
  State<Assessment_Page> createState() => _Assessment_PageState();
}

class _Assessment_PageState extends State<Assessment_Page> {
  late Future<List<dynamic>> AssessmentsFuture;
  late Future<bool> hasEditAssessmentPermissionFuture;
  late Future<bool> hasAddAssessmentPermissionFuture;

  @override
  void initState() {
    super.initState();
    AssessmentsFuture = Assessment.fetchAssessment();
    hasEditAssessmentPermissionFuture =
        Permission.searchPermissionByCodename("change_assessment");
    hasAddAssessmentPermissionFuture =
        Permission.searchPermissionByCodename("add_assessment");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Assessment Page',
            style: CustomTextStyles.headingStyle(fontSize: 22)),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: AssessmentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final assessments = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: assessments.length,
                    itemBuilder: (context, index) {
                      final assessment = assessments[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              assessment['name'],
                              style: CustomTextStyles.bodyStyle(fontSize: 17),
                            ),
                          ),
                          trailing: PermissionBasedIcon(
                              iconData: Icons.edit_square,
                              enabledColor: Color(
                                  0xffc19a6b), // Your desired enabled color
                              disabledColor: Colors.grey,
                              permissionFuture:
                              hasEditAssessmentPermissionFuture,
                              onPressed: () async {
                                var assessment =
                                await Assessment.getAssessmentbyId(
                                    assessments[index]['id']);
                                if (assessment != null) {
                                  Assessment.id = assessment['id'];
                                  Assessment.name = assessment['name'];
                                  Assessment.teacher = assessment['teacher'];
                                  Assessment.batch = assessment['batch'];
                                  Assessment.course = assessment['course'];
                                  Assessment.total_marks = assessment['total_marks'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<bool>(
                                      builder: (context) => Create_Assessment(
                                        isUpdate: true,
                                        AssessmentData: assessment,
                                      ),
                                    ),
                                  ).then((result) {
                                    if (result != null && result) {
                                      setState(() {
                                        AssessmentsFuture =
                                            Assessment.fetchAssessment();
                                      });
                                    }
                                  });
                                }
                              }),
                          onTap: () async {
                            var assessment =
                            await Assessment.getAssessmentbyId(
                                assessments[index]['id']);
                            if (assessment != null) {
                              Assessment.id = assessment['id'];
                              Assessment.name = assessment['name'];
                              Assessment.teacher = assessment['teacher'];
                              Assessment.batch = assessment['batch'];
                              Assessment.course = assessment['course'];
                              Assessment.total_marks = assessment['total_marks'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (context) => Assessment_Profile(),
                                  )).then((result) {
                                if (result != null && result) {
                                  setState(() {
                                    AssessmentsFuture =
                                        Assessment.fetchAssessment();
                                  });
                                }
                              });
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
          PermissionBasedButton(
              buttonText: 'Add Assessment',
              buttonWidth: 200,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Create_Assessment(),
                  ),
                );
              },
              permissionFuture: hasAddAssessmentPermissionFuture)
        ],
      ),
    );
  }
}
