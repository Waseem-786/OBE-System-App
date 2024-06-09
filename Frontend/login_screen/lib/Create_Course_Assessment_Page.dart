import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course_Assessment.dart';
import 'package:login_screen/CreateCourseBook.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/UpdateWidget.dart';
import 'Outline.dart';

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
  late TextEditingController closController;

  List<Map<String, TextEditingController>> assessmentControllers = [];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    countController = TextEditingController();
    weightController = TextEditingController();
    closController = TextEditingController();

    if (widget.isUpdate && widget.courseAssessmentData != null) {
      nameController.text = widget.courseAssessmentData!['name'];
      countController.text = widget.courseAssessmentData!['count'].toString();
      weightController.text = widget.courseAssessmentData!['weight'].toString();
      closController.text = widget.courseAssessmentData!['clo'].join(', ');
    }

    if (widget.isFromOutline) {
      _addAssessment();
    }
  }

  void _addAssessment() {
    setState(() {
      assessmentControllers.add({
        'name': TextEditingController(),
        'count': TextEditingController(),
        'weight': TextEditingController(),
        'course_outline': TextEditingController(),
        'clo': TextEditingController(),
      });
    });
  }

  void _removeAssessment(int index) {
    setState(() {
      assessmentControllers.removeAt(index);
    });
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
              child: Column(
                children: [
                  if (widget.isFromOutline) ...[
                    ...assessmentControllers.map((controllers) {
                      int index = assessmentControllers.indexOf(controllers);
                      return Card(
                        elevation: 4,
                        shadowColor: Colors.black45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: controllers['name']!,
                                hintText: 'Enter Assignment Name',
                                label: 'Enter Assignment Name',
                                borderColor: errorColor,
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                controller: controllers['count']!,
                                hintText: 'Enter Count',
                                label: 'Enter Count',
                                Keyboard_Type: TextInputType.number,
                                borderColor: errorColor,
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                controller: controllers['weight']!,
                                hintText: 'Enter Weightage',
                                label: 'Enter Weightage',
                                Keyboard_Type: TextInputType.number,
                                borderColor: errorColor,
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                controller: controllers['clo']!,
                                hintText: '1,2,3,...',
                                label: 'Enter CLOs number',
                                Keyboard_Type: TextInputType.number,
                                borderColor: errorColor,
                              ),
                              const SizedBox(height: 20),
                              Custom_Button(
                                onPressedFunction: () => _removeAssessment(index),
                                ButtonIcon: Icons.delete,
                                ButtonText: "Remove Assessment",
                                ButtonWidth: 270,
                                ForegroundColor: Colors.white,
                                BackgroundColor: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    Custom_Button(
                      onPressedFunction: _addAssessment,
                      ButtonText: "Add Assessment",
                      ButtonIcon: Icons.add,
                      ForegroundColor: Colors.white,
                      BackgroundColor: Colors.blue,
                      ButtonWidth: 250,
                    ),
                  ] else ...[
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
                  ],
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

                      setState(() {
                        isLoading = true;
                      });

                      bool result = true;

                      if (widget.isFromOutline) {
                        List<Map<String, dynamic>> assessments = assessmentControllers.map((controllers) {
                          return {
                            'name': controllers['name']!.text,
                            'count': int.tryParse(controllers['count']!.text) ?? 0,
                            'weight': double.tryParse(controllers['weight']!.text) ?? 0.0,
                            'course_outline': Outline.id,
                            'clo': controllers['clo']!.text.split(',').map((e) => int.tryParse(e.trim())).toList(),
                          };
                        }).toList();
                        Course_Assessment.assessments = assessments;
                      } else {
                        Map<String, dynamic> assessment = {
                          'name': nameController.text,
                          'count': int.tryParse(countController.text) ?? 0,
                          'weight': double.tryParse(weightController.text) ?? 0.0,
                          'course_outline': Outline.id,
                          'clo': closController.text.split(',').map((e) => int.tryParse(e.trim())).toList(),
                        };

                        if (widget.isUpdate) {
                          result = await Course_Assessment.updateCourseAssessment(
                            widget.courseAssessmentData!['id'],
                            assessment['name'],
                            assessment['count'],
                            assessment['weight'],
                            assessment['course_outline'],
                            assessment['clo'],
                          );
                        } else {
                          result = await Course_Assessment.createCourseAssessment(
                            assessment['name'],
                            assessment['count'],
                            assessment['weight'],
                            assessment['course_outline'],
                            assessment['clo'],
                          );
                        }
                      }

                      setState(() {
                        isLoading = false;
                      });

                      if (result) {
                        if (widget.isFromOutline) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCourseBook(isFromOutline: true)));
                        } else {
                          setState(() {
                            colorMessage = Colors.green;
                            errorColor = Colors.black12; // Reset errorColor to default value
                            errorMessage = widget.isUpdate
                                ? 'Course Assessment updated successfully'
                                : 'Course Assessment created successfully';
                          });
                        }
                      } else {
                        setState(() {
                          colorMessage = Colors.red;
                          errorMessage = 'Failed to save Course Assessments';
                        });
                      }
                    },
                    BackgroundColor: const Color(0xffc19a6b),
                    ForegroundColor: Colors.white,
                    ButtonText: buttonText,
                    ButtonWidth: 140,
                    ButtonIcon: Icons.navigate_next,
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
    );
  }
}
