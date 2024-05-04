import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/Weekly_Topics.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateWeeklyTopic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateWeeklyTopicState();
}

class CreateWeeklyTopicState extends State<CreateWeeklyTopic> {
  String?
      errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
      false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred

  late Future<List<dynamic>> cloFuture = CLO.fetchCLO(Course.id);

  final TextEditingController weekNumberController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<dynamic> selectedCLOs = [];
  final assessmentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Create Weekly Topic',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(
                  controller: weekNumberController,
                  label: 'Week Number',
                  hintText: 'Enter Week Number',
                  borderColor: errorColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  controller: topicController,
                  label: 'Weekly Topic',
                  hintText: 'Enter Weekly Topic',
                  borderColor: errorColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  controller: descriptionController,
                  label: 'Topic Description',
                  hintText: 'Enter Topic Description',
                  borderColor: errorColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: cloFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                              color:
                                  errorColor), // Set text color to errorColor
                        ),
                      );
                    } else {
                      final clos = snapshot.data as List<dynamic>;
                      final List<MultiSelectItem<dynamic>> multiSelectItems =
                          List.generate(clos.length, (index) {
                        return MultiSelectItem<dynamic>(
                          clos[index]['id'],
                          'CLO-${index + 1}',
                        );
                      });
                      return MultiSelectDialogField(
                        items: multiSelectItems,
                        listType: MultiSelectListType.CHIP,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: errorColor, // Set border color to errorColor
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                        ),
                        onConfirm: (values) {
                          setState(() {
                            selectedCLOs = values;
                          });
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  controller: assessmentsController,
                  label: 'Weekly Assessments',
                  hintText: 'Enter Weekly Assessments',
                  borderColor: errorColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Custom_Button(
                  onPressedFunction: () async {
                    final weekNumber = weekNumberController.text;
                    final topic = topicController.text;
                    final description = descriptionController.text;
                    final assessments = assessmentsController.text;
                    final courseOutlineId = Outline.id;

                    if (weekNumber.isEmpty ||
                        topic.isEmpty ||
                        description.isEmpty ||
                        selectedCLOs.isEmpty ||
                        assessments.isEmpty) {
                      setState(() {
                        colorMessage = Colors.red;
                        errorColor = Colors.red;
                        errorMessage = 'Please enter all fields';
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });

                      final bool added = await WeeklyTopics.addWeeklyTopics(
                          int.parse(weekNumber),
                          topic,
                          description,
                          selectedCLOs,
                          assessments,
                          courseOutlineId);

                      if (added) {
                        weekNumberController.clear();
                        topicController.clear();
                        descriptionController.clear();
                        selectedCLOs.clear();
                        assessmentsController.clear();

                        setState(() {
                          isLoading = false;
                          colorMessage = Colors.green;
                          errorColor = Colors
                              .black12; // Reset errorColor to default value
                          errorMessage = 'Weekly Topic Added Successfully';
                        });
                      }
                    }
                  },
                  ButtonWidth: 180,
                  ButtonText: 'Add Weekly Topic',
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
