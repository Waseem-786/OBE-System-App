import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course_Assessment.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Create_Course_Assessment_Page extends StatefulWidget {
  @override
  State<Create_Course_Assessment_Page> createState() => _Create_Course_Assessment_PageState();
}

class _Create_Course_Assessment_PageState extends State<Create_Course_Assessment_Page> {
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController course_outlineController =
  TextEditingController();
  final TextEditingController closController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
          title: Text('Create Course Assessment Page',
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
                        controller: course_outlineController,
                        hintText: 'Enter Course Outline id',
                        label: 'Enter Course Outline id',
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
                      Custom_Button(
                        onPressedFunction: () async {
                          String name = nameController.text;
                          int? count = int.tryParse(countController.text);
                          double? weight =
                          double.tryParse(weightController.text);
                          int? course_outline_id =
                          int.tryParse(course_outlineController.text);
                          List<int?> clo = closController.text
                              .split(',')
                              .map((e) => int.tryParse(e.trim()))
                              .toList();

                          if (name.isEmpty ||
                              count == null ||
                              weight == null ||
                              course_outline_id == null ||
                              clo.isEmpty) {
                            setState(() {
                              colorMessage = Colors.red;
                              errorColor = Colors.red;
                              errorMessage = 'Please enter all fields';
                            });
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            bool created =
                            await Course_Assessment.createCourseAssessment(
                                name,
                                count,
                                weight,
                                course_outline_id,
                                clo);
                            if (created) {
                              nameController.clear();
                              countController.clear();
                              weightController.clear();
                              course_outlineController.clear();
                              closController.clear();

                              setState(() {
                                isLoading = false;
                                colorMessage = Colors.green;
                                errorColor = Colors
                                    .black12; // Reset errorColor to default value
                                errorMessage =
                                'Course Assessment Created successfully';
                              });
                            }
                          }
                        },
                        ButtonWidth: 160,
                        ButtonText: 'Create',
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
