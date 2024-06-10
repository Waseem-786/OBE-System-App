import 'package:flutter/material.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/CourseBooks.dart';
import 'package:login_screen/Course_Schedule.dart';
import 'package:login_screen/User.dart';
import 'package:login_screen/Weekly_Topics.dart';

import 'CLO.dart';
import 'Course.dart';
import 'CourseObjective.dart';
import 'Course_Assessment.dart';
import 'Create_CLO.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Outline.dart';

class View_CLOs extends StatefulWidget {
  final bool isFromOutline;

  View_CLOs({this.isFromOutline = false});

  @override
  State<View_CLOs> createState() => _View_CLOsState();
}

class _View_CLOsState extends State<View_CLOs> {
  int Course_id = Course.id;
  String? errorMessage;
  var isLoading = false;
  List<Map<String, dynamic>> existingCLOs = [];

  @override
  void initState() {
    super.initState();
    _loadExistingCLOs();
  }

  Future<void> _loadExistingCLOs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final clos = await CLO.fetchCLO(Course_id);
      setState(() {
        existingCLOs = clos.map((clo) => {
          'description': clo['description'],
          'bloom_taxonomy': clo['bloom_taxonomy'],
          'level': clo['level'].toString(),
          'plo': clo['plo'],
          'course': clo['course'],
          'course_outline': clo['course_outline']
        }).toList();
        CLO.clos = existingCLOs; // Store the fetched CLOs in the static variable
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load existing CLOs';
      });
    }
  }

  void _showCreateOrUpdateCLOForm(bool isUpdate) {
    if (isUpdate) {
      _showJustificationDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Create_CLO()),
      );
    }
  }

  Future<void> _showJustificationDialog() async {
    TextEditingController justificationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Justification for CLO Update"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please provide a justification for updating the CLOs:"),
              SizedBox(height: 10),
              TextField(
                controller: justificationController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter justification',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                if (justificationController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Create_CLO(
                        isFromOutline: widget.isFromOutline,
                        justification: justificationController.text,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _createCompleteOutline() async {
    setState(() {
      isLoading = true;
    });

    final batch = Outline.batch;
    final teacher = Outline.teacher;
    final course = Outline.course;

    final objectives = CourseObjective.objectivesList;
    final clos = CLO.clos;
    final schedule = {
      "lecture_hours_per_week": Course_Schedule.lecture_hours_per_week,
      "lab_hours_per_week": Course_Schedule.lab_hours_per_week,
      "discussion_hours_per_week": Course_Schedule.discussion_hours_per_week,
      "office_hours_per_week": Course_Schedule.office_hours_per_week,
      "course_outline": Course_Schedule.course_outline
    };
    final assessments = Course_Assessment.assessments;
    final weeklyTopics = WeeklyTopics.weeklyTopics;
    final books = CourseBooks.books;

    final success = await Outline.createCompleteOutline(
      batch: batch,
      teacher: teacher,
      course: course,
      objectives: objectives,
      clos: clos,
      schedule: schedule,
      assessments: assessments,
      weeklyTopics: weeklyTopics,
      books: books,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Complete Outline created successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create Complete Outline')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            "View CLOs",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const CircularProgressIndicator(),
                ] else ...[
                  Text(
                    "Existing CLOs",
                    style: CustomTextStyles.headingStyle(fontSize: 20, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  ...existingCLOs.map((clo) {
                    return Card(
                      elevation: 4,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        title: Text(
                          clo['description'],
                          style: CustomTextStyles.headingStyle(fontSize: 18, color: Colors.black87),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Bloom Taxonomy: ${clo['bloom_taxonomy']}",
                              style: CustomTextStyles.bodyStyle(color: Colors.black54),
                            ),
                            Text(
                              "BT Level: ${clo['level']}",
                              style: CustomTextStyles.bodyStyle(color: Colors.black54),
                            ),
                            Text(
                              "PLOs: ${clo['plo'].join(', ')}",
                              style: CustomTextStyles.bodyStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  Custom_Button(
                    onPressedFunction: () => _showCreateOrUpdateCLOForm(existingCLOs.isNotEmpty),
                    ButtonText: existingCLOs.isNotEmpty ? "Update CLOs" : "Create CLOs",
                    ButtonIcon: Icons.update,
                    ForegroundColor: Colors.white,
                    BackgroundColor: Colors.purple,
                    ButtonWidth: 200,
                    ButtonHeight: 50,
                  ),
                  if (widget.isFromOutline) ...[
                    const SizedBox(height: 20),
                    Custom_Button(
                      onPressedFunction: _createCompleteOutline,
                      ButtonText: "Create Complete Outline",
                      ButtonIcon: Icons.arrow_forward,
                      ForegroundColor: Colors.white,
                      BackgroundColor: const Color(0xffc19a6b),
                      ButtonWidth: 300,
                    ),
                  ],
                ],
                if (errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    errorMessage!,
                    style: CustomTextStyles.bodyStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
