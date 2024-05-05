import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course_Assessment.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Create_Course_Assessment_Page extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? courseAssessmentData;

  Create_Course_Assessment_Page({this.isUpdate = false, this.courseAssessmentData});

  @override
  State<Create_Course_Assessment_Page> createState() =>
      _Create_Course_Assessment_PageState();
}

class _Create_Course_Assessment_PageState
    extends State<Create_Course_Assessment_Page> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //  var a = Course_Assessment.fetchCourseAssessment(2);
  // }
  String? errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors.black12;
  // color of border of text fields when the error is not occurred

  late TextEditingController nameController;
  late TextEditingController countController;
  late TextEditingController weightController;
  late TextEditingController course_outlineController;
  late TextEditingController closController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.courseAssessmentData?['name'] ?? '');
    countController = TextEditingController(text: widget.courseAssessmentData?['count']?.toString() ?? '');
    weightController = TextEditingController(text: widget.courseAssessmentData?['weight']?.toString() ?? '');
    course_outlineController = TextEditingController(text: widget.courseAssessmentData?['course_outline']?.toString() ?? '');
    closController = TextEditingController(text: widget.courseAssessmentData?['clo']?.join(',') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isUpdate ? 'Update' : 'Create';
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
          title: Text('Course Assessment Form',
              style: CustomTextStyles.headingStyle(fontSize: 22)),
        ),
        body: Container(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: nameController,
                        hintText: 'Enter Assignment Name',
                        label: 'Enter Assignment Name',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: countController,
                        hintText: 'Enter  Count',
                        label: 'Enter Count',
                        Keyboard_Type: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: weightController,
                        hintText: 'Enter Weightage',
                        label: 'Enter Weightage',
                        Keyboard_Type: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: closController,
                        hintText: '1,2,3,...',
                        label: 'Enter CLOs number',
                        Keyboard_Type: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: course_outlineController,
                        hintText: 'Enter Course Outline id',
                        label: 'Enter Course Outline id',
                        Keyboard_Type: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Custom_Button(
                        onPressedFunction: () async {
                          String name = nameController.text;
                          int? count = int.tryParse(countController.text);
                          double? weight = double.tryParse(weightController.text);
                          int? course_outline_id = int.tryParse(course_outlineController.text);
                          List<int?> clo = closController.text.split(',').map((e) => int.tryParse(e.trim())).toList();

                          if (name.isEmpty || count == null || weight == null || course_outline_id == null || clo.isEmpty) {
                            setState(() {
                              colorMessage = Colors.red;
                              errorColor = Colors.red;
                              errorMessage = 'Please enter all fields';
                            });
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            bool result;
                            if (widget.isUpdate) {
                              result = await Course_Assessment.updateCourseAssessment(
                                widget.courseAssessmentData?['id'],
                                name,
                                count,
                                weight,
                                course_outline_id,
                                clo,
                              );
                            } else {
                              result = await Course_Assessment.createCourseAssessment(
                                name,
                                count,
                                weight,
                                course_outline_id,
                                clo,
                              );
                            }
                            if (result) {
                              nameController.clear();
                              countController.clear();
                              weightController.clear();
                              course_outlineController.clear();
                              closController.clear();

                              setState(() {
                                isLoading = false;
                                colorMessage = Colors.green;
                                errorColor = Colors.black12; // Reset errorColor to default value
                                errorMessage = widget.isUpdate ? 'Course updated successfully' : 'Course created successfully';
                              });
                            }
                          }
                        },
                        ButtonWidth: 160,
                        ButtonText: buttonText,
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: isLoading,
                        child: const CircularProgressIndicator(),
                      ),
                      errorMessage != null
                          ? Text(
                        errorMessage!,
                        style: CustomTextStyles.bodyStyle(
                            color: colorMessage),
                      )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
