import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Question_Page.dart';
import 'package:login_screen/User.dart';
import 'Assessment.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DropDown.dart';
import 'Custom_Widgets/UpdateWidget.dart';

class Create_Assessment extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? AssessmentData;

  Create_Assessment({this.isUpdate = false, this.AssessmentData});

  @override
  State<Create_Assessment> createState() => _Create_AssessmentState();
}

class _Create_AssessmentState extends State<Create_Assessment> {
  String?
      errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
      false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred

  late TextEditingController AssessmentNameController;
  late TextEditingController AssessmentBatchController;
  late TextEditingController AssessmentCourseController;
  late TextEditingController AssessmentTotalMarksController;
  late TextEditingController AssessmentInstructionsController;
  Duration _DurationofAssessment = Duration.zero;

  dynamic? SelectedBatch;
  dynamic? SelectedCourse;

  @override
  void initState() {
    AssessmentNameController =
        TextEditingController(text: widget.AssessmentData?['name'] ?? '');
    AssessmentBatchController =
        TextEditingController(text: widget.AssessmentData?['batch'] ?? '');
    AssessmentCourseController =
        TextEditingController(text: widget.AssessmentData?['course'] ?? '');
    AssessmentTotalMarksController = TextEditingController(
        text: widget.AssessmentData?['total_marks'] ?? '');
    AssessmentInstructionsController = TextEditingController(
        text: widget.AssessmentData?['instructions'] ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isUpdate ? 'Update' : 'Create';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Assessment Form Page',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(
                  controller: AssessmentNameController,
                  label: 'Assessment Name',
                  hintText: 'Quizzes or Mids...',
                  borderColor: errorColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDown(
                  fetchData: () => Batch.getBatchBydeptId(User.departmentid),
                  selectedValue: SelectedBatch,
                  label: "Batch",
                  hintText: "Select Batch",
                  controller: AssessmentBatchController,
                  onValueChanged: (dynamic id) {
                    setState(() {
                      SelectedBatch = id;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDown(
                  fetchData: () => Course.fetchCoursesbyCampusId(User.campusid),
                  selectedValue: SelectedCourse,
                  label: "Course",
                  hintText: "Select Course",
                  keyName: "title",
                  controller: AssessmentCourseController,
                  onValueChanged: (dynamic id) {
                    setState(() {
                      SelectedCourse = id;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  controller: AssessmentTotalMarksController,
                  label: 'Assessment Total Marks',
                  hintText: '10',
                  borderColor: errorColor,
                  Keyboard_Type: TextInputType.number,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  controller: AssessmentInstructionsController,
                  label: 'Instructions',
                  hintText: 'Paper is open book',
                  borderColor: errorColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Builder(
                  builder: (BuildContext context) => Custom_Button(
                    onPressedFunction: () async {
                      final resultingDuration = await showDurationPicker(
                        context: context,
                        initialTime: const Duration(seconds: 30),
                        baseUnit: BaseUnit.second,
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chose duration: $resultingDuration'),

                        ),
                      );
                    },
                    ButtonText: "Duration",
                    BackgroundColor: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Custom_Button(
                    onPressedFunction: () async {
                      if (widget.isUpdate) {
                        // Show confirmation dialog
                        bool confirmUpdate = await showDialog(
                          context: context,
                          builder: (context) => const UpdateWidget(
                            title: "Confirm Update",
                            content:
                                "Are you sure you want to update Assessment?",
                          ),
                        );
                        if (!confirmUpdate) {
                          return; // Cancel the update if user selects 'No' in the dialog
                        }
                      }

                      String AssessmentName = AssessmentNameController.text;
                      int? AssessmentBatch = SelectedBatch;
                      int? AssessmentCourse = SelectedCourse;
                      int AssessmentTotalMarks =
                          int.parse(AssessmentTotalMarksController.text);
                      String AssessmentInstructions =
                          AssessmentInstructionsController.text;
                      if (AssessmentName.isEmpty ||
                          AssessmentInstructions.isEmpty ||
                          AssessmentBatch == null ||
                          AssessmentCourse == null ||
                          AssessmentTotalMarks == null) {
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
                          result = await Assessment.updateAssessment(
                              widget.AssessmentData?['id'],
                              AssessmentName,
                              User.id,
                              AssessmentBatch,
                              AssessmentCourse,
                              AssessmentTotalMarks);
                        } else {
                          result = await Assessment.createAssessment(
                              AssessmentName,
                              User.id,
                              AssessmentBatch,
                              AssessmentCourse,
                              AssessmentTotalMarks);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Question_Page(),
                              ));
                        }
                        if (result) {
                          // Clear all the fields
                          AssessmentNameController.clear();
                          SelectedBatch = null;
                          SelectedCourse = null;
                          AssessmentTotalMarksController.clear();

                          setState(() {
                            isLoading = false;
                            colorMessage = Colors.green;
                            errorColor = Colors
                                .black12; // Reset errorColor to default value
                            errorMessage = widget.isUpdate
                                ? 'Assessment updated successfully'
                                : 'Assessment created successfully';
                          });
                        }
                      }
                    },
                    BackgroundColor: Color(0xffc19a6b),
                    ForegroundColor: Colors.white,
                    ButtonText: "Next",
                    ButtonWidth: 120,
                  ),
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
    );
  }
}
