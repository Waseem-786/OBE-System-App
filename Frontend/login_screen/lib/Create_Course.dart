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
  String? errorMessage;
  Color colorMessage = Colors.red;
  bool isLoading = false;
  Color errorColor = Colors.black12;

  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController courseTitleController = TextEditingController();
  final TextEditingController courseTheoryCreditsController = TextEditingController();
  final TextEditingController courseLabCreditsController = TextEditingController();
  final TextEditingController courseDescriptionController = TextEditingController();
  final TextEditingController courseContentController = TextEditingController();
  final TextEditingController preReqController = TextEditingController();

  String? selectedCourseReqElec;
  String? selectedCourseType;
  dynamic selectedCoursePrerequisite;

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              controller: courseCodeController,
              label: 'Course Code',
              hintText: 'MGT-271',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: courseTitleController,
              label: 'Course Title',
              hintText: 'Machine Learning',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: courseTheoryCreditsController,
              label: 'Theory Credits',
              hintText: '2',
              borderColor: errorColor,
              Keyboard_Type: TextInputType.number,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: courseLabCreditsController,
              label: 'Lab Credits',
              hintText: '1',
              borderColor: errorColor,
              Keyboard_Type: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildCourseTypeRadioButtons(),
            const SizedBox(height: 20),
            _buildCourseRequirementRadioButtons(),
            const SizedBox(height: 20),
            DropDown(
                fetchData: () => Course.fetchCoursesbyCampusId(Campus.id),
                selectedValue: selectedCoursePrerequisite,
                keyName: 'title',
                controller: preReqController,
                hintText: 'Select Requisite',
                label: "Pre Requisite",
                onValueChanged: (dynamic id) {
                  setState(() {
                    selectedCoursePrerequisite = id;
                  });
                }
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: courseDescriptionController,
              label: 'Course Description',
              hintText: 'Enter Course Description',
              borderColor: errorColor,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: courseContentController,
              label: 'Course Content',
              hintText: 'Enter Course Content',
              borderColor: errorColor,
              maxLines: 10,
            ),
            const SizedBox(height: 20),
            Center(
              child: Custom_Button(
                onPressedFunction: _createCourse,
                ButtonText: 'Create Course',
                ButtonWidth: 200,
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
            if (errorMessage != null)
              Center(
                child: Text(
                  errorMessage!,
                  style: CustomTextStyles.bodyStyle(color: colorMessage),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseTypeRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Course Type', style: CustomTextStyles.bodyStyle()),
        Row(
          children: [
            Radio<String>(
              value: 'Lecture',
              groupValue: selectedCourseType,
              onChanged: (value) {
                setState(() {
                  selectedCourseType = value;
                });
              },
            ),
            Text('Lecture', style: CustomTextStyles.bodyStyle()),
            Radio<String>(
              value: 'Lab',
              groupValue: selectedCourseType,
              onChanged: (value) {
                setState(() {
                  selectedCourseType = value;
                });
              },
            ),
            Text('Lab', style: CustomTextStyles.bodyStyle())
          ],
        ),
      ],
    );
  }

  Widget _buildCourseRequirementRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Course Requirement', style: CustomTextStyles.bodyStyle()),
        Row(
          children: [
            Radio<String>(
              value: 'Required',
              groupValue: selectedCourseReqElec,
              onChanged: (value) {
                setState(() {
                  selectedCourseReqElec = value;
                });
              },
            ),
            Text('Required', style: CustomTextStyles.bodyStyle()),
            Radio<String>(
              value: 'Elective',
              groupValue: selectedCourseReqElec,
              onChanged: (value) {
                setState(() {
                  selectedCourseReqElec = value;
                });
              },
            ),
            Text('Elective', style: CustomTextStyles.bodyStyle())
          ],
        ),
      ],
    );
  }

  Future<void> _createCourse() async {
    String courseCode = courseCodeController.text;
    String courseTitle = courseTitleController.text;
    int? theoryCredits = int.tryParse(courseTheoryCreditsController.text);
    int? labCredits = int.tryParse(courseLabCreditsController.text);
    String? courseType = selectedCourseType;
    String? reqElec = selectedCourseReqElec;
    int? preReq = selectedCoursePrerequisite;
    String description = courseDescriptionController.text;
    String content = courseContentController.text;
    labCredits ??= 0;

    if (courseCode.isEmpty ||
        courseTitle.isEmpty ||
        theoryCredits == null ||
        courseType == null ||
        reqElec == null ||
        description.isEmpty ||
        content.isEmpty) {
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
          courseCode,
          courseTitle,
          theoryCredits,
          labCredits,
          courseType,
          reqElec,
          preReq,
          description,
          content,
          Campus.id
      );
      if (created) {
        // Clear all the fields and deselect the radio button and dropdown
        courseCodeController.clear();
        courseTitleController.clear();
        courseTheoryCreditsController.clear();
        courseLabCreditsController.clear();
        courseDescriptionController.clear();
        courseContentController.clear();
        selectedCourseType = null;
        selectedCourseReqElec = null;
        selectedCoursePrerequisite = null;

        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorColor = Colors.black12;
          errorMessage = 'Course Created successfully';
        });
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to create course';
        });
      }
    }
  }
}
