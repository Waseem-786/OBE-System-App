import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Campus.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DropDown.dart';

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
  final TextEditingController CourseDescriptionController =
      TextEditingController();

  final TextEditingController PreReqController  = TextEditingController();
  String? SelectedCourseReqElec;
  String? SelectedCourseType;
  dynamic SelectedCoursePrerequisite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Create Course',
          style: CustomTextStyles.headingStyle(fontSize: 20),
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
                hintText: 'MGT-271',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CourseTitleController,
                label: 'Course Title',
                hintText: 'Machine Learning',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CourseTheoryCreditsController,
                label: 'Theory Credits',
                hintText: '2',
                borderColor: errorColor,
                Keyboard_Type: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CourseLabCreditsController,
                label: 'Lab Credits',
                hintText: '1',
                borderColor: errorColor,
                Keyboard_Type: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Radio<String>(
                      value: 'Required',
                      groupValue: SelectedCourseType,
                      onChanged: (value) {
                        setState(() {
                          SelectedCourseType = value as String;
                        });
                      }),
                  Text('Lecture', style: CustomTextStyles.bodyStyle()),
                  Radio<String>(
                      value: 'Lab',
                      groupValue: SelectedCourseType,
                      onChanged: (value) {
                        setState(() {
                          SelectedCourseType = value as String;
                        });
                      }),
                  Text(
                    'Lab',
                    style: CustomTextStyles.bodyStyle(),
                  )
                ],
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
              DropDown(
                fetchData: ( )=> Course.fetchCoursesbyCampusId(Campus.id),
                selectedValue: SelectedCoursePrerequisite,
                keyName: 'title',
                controller: PreReqController,
                hintText: 'Select Requisite',
                label: "Pre Requisite",
                onValueChanged: (dynamic id) {
                  setState(() {
                    SelectedCoursePrerequisite = id;
                  });
                }
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
                  String CourseCode = CourseCodeController.text;
                  String CourseTitle = CourseTitleController.text;
                  int? theoryCredits =
                      int.tryParse(CourseTheoryCreditsController.text);
                  int? labCredits =
                      int.tryParse(CourseLabCreditsController.text);
                  String? CourseType = SelectedCourseType;
                  String? ReqEelc = SelectedCourseReqElec;
                  int? PreReq = SelectedCoursePrerequisite;
                  String Description = CourseDescriptionController.text;
                  labCredits ??= 0;
                  if (CourseCode.isEmpty ||
                      CourseTitle.isEmpty ||
                      theoryCredits == null ||
                      CourseType == null ||
                      ReqEelc == null ||
                      Description.isEmpty) {
                    setState(() {
                      colorMessage = Colors.red;
                      errorColor = Colors.red;
                      errorMessage = 'Please enter all fields';
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    bool created = await Course.createCourse(
                        CourseCode,
                        CourseTitle,
                        theoryCredits,
                        labCredits,
                        CourseType,
                        ReqEelc,
                        PreReq,
                        Description,
                        Campus.id
                    );
                    if (created) {
                      //Clear all the fields and deselect the radio button and dropdown
                      CourseCodeController.clear();
                      CourseTitleController.clear();
                      CourseTheoryCreditsController.clear();
                      CourseLabCreditsController.clear();
                      SelectedCourseType = null;
                      SelectedCourseReqElec = null;
                      SelectedCoursePrerequisite = null;
                      CourseDescriptionController.clear();

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
              const SizedBox(height: 20),
              Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(),
              ),
              errorMessage != null
                  ? Text(
                      errorMessage!,
                      style: CustomTextStyles.bodyStyle(color: colorMessage),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
