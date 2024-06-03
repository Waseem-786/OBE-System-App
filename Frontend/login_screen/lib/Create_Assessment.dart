import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Batch.dart';
import 'Course.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Question_Page.dart';
import 'User.dart';
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
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  late TextEditingController AssessmentNameController;
  late TextEditingController AssessmentBatchController;
  late TextEditingController AssessmentCourseController;
  late TextEditingController AssessmentTotalMarksController;
  late TextEditingController AssessmentInstructionsController;

  @override
  void initState() {
    AssessmentNameController =
        TextEditingController(text: widget.AssessmentData?['name'] ?? '');
    AssessmentBatchController =
        TextEditingController(text: widget.AssessmentData?['batch'] ?? '');
    AssessmentCourseController =
        TextEditingController(text: widget.AssessmentData?['course'] ?? '');
    AssessmentTotalMarksController =
        TextEditingController(text: widget.AssessmentData?['total_marks'] ?? '');
    AssessmentInstructionsController =
        TextEditingController(text: widget.AssessmentData?['instructions'] ?? '');
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: AssessmentNameController,
                    label: 'Assessment Name',
                    hintText: 'Quizzes or Mids...',
                    borderColor: errorColor,
                  ),
                  const SizedBox(height: 20),

                  // Batch DropDown
                  Selector<AssessmentProvider, dynamic>(
                    selector: (_, provider) => provider.selectedBatch,
                    builder: (_, selectedBatch, __) {
                      return DropDown(
                        fetchData: () => Batch.getBatchBydeptId(User.departmentid),
                        selectedValue: selectedBatch,
                        label: "Batch",
                        hintText: "Select Batch",
                        controller: AssessmentBatchController,
                        onValueChanged: (dynamic id) {
                          context.read<AssessmentProvider>().setSelectedBatch(id);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Course DropDown
                  Selector<AssessmentProvider, dynamic>(
                    selector: (_, provider) => provider.selectedCourse,
                    builder: (_, selectedCourse, __) {
                      return DropDown(
                        fetchData: () => Course.fetchCoursesbyCampusId(User.campusid),
                        selectedValue: selectedCourse,
                        label: "Course",
                        hintText: "Select Course",
                        keyName: "title",
                        controller: AssessmentCourseController,
                        onValueChanged: (dynamic id) {
                          context.read<AssessmentProvider>().setSelectedCourse(id);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextFormField(
                    controller: AssessmentTotalMarksController,
                    label: 'Assessment Total Marks',
                    hintText: '10',
                    borderColor: errorColor,
                    Keyboard_Type: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: AssessmentInstructionsController,
                    label: 'Instructions',
                    hintText: 'Paper is open book',
                    borderColor: errorColor,
                  ),
                  const SizedBox(height: 20),

                  // Duration Picker
                  Selector<AssessmentProvider, Duration>(
                    selector: (_, provider) => provider.durationOfAssessment,
                    builder: (_, duration, __) {
                      return Column(
                        children: [
                          Custom_Button(
                            onPressedFunction: () async {
                              final resultingDuration = await showDurationPicker(
                                context: context,
                                initialTime: const Duration(minutes: 30),
                                baseUnit: BaseUnit.minute,
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Chose duration: $resultingDuration'),
                                ),
                              );
                              context.read<AssessmentProvider>().setDurationOfAssessment(
                                  resultingDuration ?? Duration.zero);
                            },
                            ButtonText: "Duration",
                            BackgroundColor: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(19),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Selected Duration: ${duration.inHours} hours ${duration.inMinutes.remainder(60)} minutes',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Custom_Button(
                      onPressedFunction: () async {
                        final provider = Provider.of<AssessmentProvider>(context, listen: false);

                        String AssessmentName = AssessmentNameController.text;
                        int? AssessmentBatch = provider.selectedBatch;
                        int? AssessmentCourse = provider.selectedCourse;
                        int AssessmentTotalMarks = int.parse(AssessmentTotalMarksController.text);
                        String AssessmentInstructions = AssessmentInstructionsController.text;

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

                          // Set the data to Assessment class variables
                          Assessment.name = AssessmentName;
                          Assessment.batch = AssessmentBatch;
                          Assessment.teacher = User.id;
                          Assessment.course = AssessmentCourse;
                          Assessment.total_marks = AssessmentTotalMarks;
                          Assessment.instructions = AssessmentInstructions;
                          Assessment.duration = provider.durationOfAssessment.toString();

                          print(Assessment.name);
                          print(Assessment.batch);
                          print(Assessment.course);
                          print(Assessment.total_marks);
                          print(Assessment.instructions);
                          print(Assessment.duration);

                          // Navigate to the next page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Question_Page(),
                            ),
                          );

                          setState(() {
                            isLoading = false;
                          });
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
      ),
    );
  }
}


class AssessmentProvider extends ChangeNotifier {
  dynamic _selectedBatch;
  dynamic _selectedCourse;
  Duration _durationOfAssessment = Duration.zero;

  dynamic get selectedBatch => _selectedBatch;
  dynamic get selectedCourse => _selectedCourse;
  Duration get durationOfAssessment => _durationOfAssessment;

  void setSelectedBatch(dynamic batch) {
    _selectedBatch = batch;
    notifyListeners();
  }

  void setSelectedCourse(dynamic course) {
    _selectedCourse = course;
    notifyListeners();
  }

  void setDurationOfAssessment(Duration duration) {
    _durationOfAssessment = duration;
    notifyListeners();
  }
}
