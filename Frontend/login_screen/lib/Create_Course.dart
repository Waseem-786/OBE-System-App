import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Create_Course extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Create_Course_State();
}

class Create_Course_State extends State<Create_Course> {
  String?
  errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
  false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred

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
            'Create Course',
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
                          SelectedCourseReqElec = value as String;
                        });
                      }),
                  Text('Required', style: CustomTextStyles.bodyStyle()),
                  Radio<String>(
                      value: 'Elective',
                      groupValue: SelectedCourseReqElec,
                      onChanged: (value) {
                        setState(() {
                          SelectedCourseReqElec = value as String;
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
                    SelectedCoursePrerequisite = value as String;
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
                onPressedFunction: () async {
                  print("Hi");
                  String CourseCode = CourseCodeController.text;
                  String CourseTitle = CourseTitleController.text;
                  int? theoryCredits = int.tryParse(CourseTheoryCreditsController.text);
                  int? labCredits = int.tryParse(CourseLabCreditsController.text);
                  String CourseType = CourseTypeController.text;
                  String? ReqEelc = SelectedCourseReqElec;
                  String?  PreReq = SelectedCoursePrerequisite;
                  String Description = CourseDescriptionController.text;
                  labCredits ??= 0;
                  if (CourseCode.isEmpty ||
                      CourseTitle.isEmpty ||
                      theoryCredits == null ||
                      CourseType.isEmpty ||
                      ReqEelc == null ||
                      PreReq == null ||
                      Description.isEmpty
                  ) {
                    setState(() {
                      colorMessage = Colors.red;
                      errorColor = Colors.red;
                      errorMessage = 'Please enter all fields';
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    print('Course Code: $CourseCode');
                    print('Course Title: $CourseTitle');
                    print('Theory Credits: $theoryCredits');
                    print('Lab Credits: $labCredits');
                    print('Course Type: $CourseType');
                    print('Required/Elective: $ReqEelc');
                    print('Prerequisite: $PreReq');
                    print('Description: $Description');

                    bool created = await Course.createCourse(
                        CourseCode,CourseTitle,theoryCredits,labCredits,CourseType,ReqEelc,PreReq,Description);
                    if (created) {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorColor =
                            Colors.black12; // Reset errorColor to default value
                        errorMessage = 'Course Created successfully';
                      });
                    }
                  }
                },
                ButtonText: 'Create Course',
                ButtonWidth: 200,
              ),
              SizedBox(height: 20),
              Visibility(
                visible: isLoading,
                child: CircularProgressIndicator(),
              ),
              errorMessage != null
                  ? Text(
                errorMessage!,
                style: CustomTextStyles.bodyStyle(color: colorMessage),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
