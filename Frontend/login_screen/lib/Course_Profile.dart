import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Course_Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
          title: Center(
              child: Text('Course Profile',
                  style: CustomTextStyles.headingStyle(fontSize: 22))),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                height: 500,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title for course details section.
                        Text("Course Details",
                            style: CustomTextStyles.headingStyle()),
                        const SizedBox(height: 10),

                        // calling of the _buildCourseInfoCards() for every field of course data that will be stored on the card
                        ..._buildCourseInfoCards(), // Spread operator (...) to unpack the list of course info cards into children.
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Button for delete functionality.
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Custom_Button(
                onPressedFunction: () {
                  // Implement delete functionality.
                },
                BackgroundColor: Colors.red,
                ForegroundColor: Colors.white,
                ButtonText: "Delete",
                ButtonWidth: 120,
              ),
            )
          ],
        ));
  }

  List<Widget> _buildCourseInfoCards() {
    return [
      _buildCourseDetailCard("Course Code", Course.code),
      _buildCourseDetailCard("Course Title", Course.title),
      _buildCourseDetailCard(
          "Theory Credits", Course.theory_credits.toString()),
      _buildCourseDetailCard("Lab Credits", Course.lab_credits.toString()),
      _buildCourseDetailCard("Course Type", Course.course_type),
      _buildCourseDetailCard("Course Req/Elec", Course.required_elective),
      _buildCourseDetailCard("Course Prerequisite", Course.prerequisite.toString()),
      _buildCourseDetailCard("Course Description", Course.description),
    ];
  }

  Widget _buildCourseDetailCard(String label, String? value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "$label: ${value ?? 'Not provided'}",
            style: CustomTextStyles.bodyStyle(fontSize: 19),
          ),
        ),
      ),
    );
  }
}
