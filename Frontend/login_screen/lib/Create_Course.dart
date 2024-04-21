import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Create_Course extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Create_Course_State();
}

class Create_Course_State extends State<Create_Course> {
  Color errorColor = Colors.black12;

  // Text Editing controllers for this form page
  final TextEditingController CourseCodeController = TextEditingController();
  final TextEditingController CourseTitleController = TextEditingController();
  final TextEditingController CourseTheoryCreditsController =
      TextEditingController();
  final TextEditingController CourseLabCreditsController =
      TextEditingController();
  final TextEditingController CourseTypeController = TextEditingController();
  final TextEditingController CourseDescriptionController =
      TextEditingController();

  String? SelectedCourseReqElec;
  String? SelectedCoursePrerequisite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Course Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextFormField(
                controller: CourseCodeController,
                label: 'Course Code',
                hintText: 'Enter Course Code',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CourseTitleController,
                label: 'Course Title',
                hintText: 'Enter Course Title',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CourseTheoryCreditsController,
                label: 'Theory Credits',
                hintText: 'Enter Theory Credit Hours',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CourseLabCreditsController,
                label: 'Lab Credits',
                hintText: 'Enter Lab Credit Hours',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CourseTypeController,
                label: 'Course Type',
                hintText: 'Enter Course Type',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Radio<String>(
                      value: 'Required',
                      groupValue: SelectedCourseReqElec,
                      onChanged: (value) {
                        setState(() {
                          SelectedCourseReqElec = value;
                        });
                      }),
                  Text('Required', style: CustomTextStyles.bodyStyle()),
                  Radio<String>(
                      value: 'Elective',
                      groupValue: SelectedCourseReqElec,
                      onChanged: (value) {
                        setState(() {
                          SelectedCourseReqElec = value;
                        });
                      }),
                  Text(
                    'Elective',
                    style: CustomTextStyles.bodyStyle(),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                value: SelectedCoursePrerequisite,
                onChanged: (value) {
                  setState(() {
                    SelectedCoursePrerequisite = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Course Prerequisite',
                  hintText: 'Select Course Prerequisite',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12, // Default border
                      // color
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: errorColor),
                  ),
                ),
                items: ['FOP', 'OOP', 'None'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CourseDescriptionController,
                label: 'Course Description',
                hintText: 'Enter Course Description',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Custom_Button(
                onPressedFunction: () {},
                ButtonText: 'Create Course',
                ButtonWidth: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
