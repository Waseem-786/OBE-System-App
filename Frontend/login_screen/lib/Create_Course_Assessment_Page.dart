import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course_Assessment.dart';
import 'package:login_screen/CreateCourseBook.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/UpdateWidget.dart';

class Create_Course_Assessment_Page extends StatefulWidget {
  final bool isFromOutline;
  final bool isUpdate;
  final Map<String, dynamic>? courseAssessmentData;

  Create_Course_Assessment_Page({this.isFromOutline = false, this.isUpdate = false, this.courseAssessmentData});

  @override
  State<Create_Course_Assessment_Page> createState() => _Create_Course_Assessment_PageState();
}

class _Create_Course_Assessment_PageState extends State<Create_Course_Assessment_Page> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

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
    String buttonText = widget.isFromOutline ? 'Next' : (widget.isUpdate ? 'Update' : 'Create');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Course Assessment Form', style: CustomTextStyles.headingStyle(fontSize: 22)),
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
                      borderColor: errorColor,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: countController,
                      hintText: 'Enter Count',
                      label: 'Enter Count',
                      Keyboard_Type: TextInputType.number,
                      borderColor: errorColor,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: weightController,
                      hintText: 'Enter Weightage',
                      label: 'Enter Weightage',
                      Keyboard_Type: TextInputType.number,
                      borderColor: errorColor,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: closController,
                      hintText: '1,2,3,...',
                      label: 'Enter CLOs number',
                      Keyboard_Type: TextInputType.number,
                      borderColor: errorColor,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: course_outlineController,
                      hintText: 'Enter Course Outline id',
                      label: 'Enter Course Outline id',
                      Keyboard_Type: TextInputType.number,
                      borderColor: errorColor,
                    ),
                    const SizedBox(height: 20),
                    Custom_Button(
                      onPressedFunction: () async {
                        if (widget.isUpdate) {
                          // Show confirmation dialog
                          bool confirmUpdate = await showDialog(
                            context: context,
                            builder: (context) => const UpdateWidget(
                              title: "Confirm Update",
                              content: "Are you sure you want to update Course Assessment?",
                            ),
                          );
                          if (!confirmUpdate) {
                            return; // Cancel the update if user selects 'No' in the dialog
                          }
                        }

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

                          if (widget.isFromOutline) {
                            Course_Assessment.name = name;
                            Course_Assessment.count = count;
                            Course_Assessment.weight = weight;
                            Course_Assessment.clo = clo;
                            // Navigate to the next screen if coming from outline
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCourseBook(isFromOutline: true))); // Replace with your next screen
                          } else {
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
                                errorMessage = widget.isUpdate
                                    ? 'Course Assessment updated successfully'
                                    : 'Course Assessment created successfully';
                              });

                            }
                          }

                        }
                      },
                      BackgroundColor: Color(0xffc19a6b),
                      ForegroundColor: Colors.white,
                      ButtonText: buttonText,
                      ButtonWidth: 120,
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
          ),
        ),
      ),
    );
  }
}
