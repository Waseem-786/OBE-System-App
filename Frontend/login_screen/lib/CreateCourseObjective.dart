import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_screen/CourseObjective.dart';
import 'Course.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';

class CreateCourseObjective extends StatefulWidget {
  @override
  State<CreateCourseObjective> createState() => _CreateObjectiveState();
}

class _CreateObjectiveState extends State<CreateCourseObjective> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;
  final List<TextEditingController> objectiveControllers = [];

  @override
  void initState() {
    super.initState();
    // Add an initial text controller
    objectiveControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    // Clean up the text controllers when the widget is disposed
    for (var controller in objectiveControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTextField() {
    setState(() {
      // Add a new text controller when "Add More" is clicked
      objectiveControllers.add(TextEditingController());
    });
  }

  void _removeTextField(int index) {
    setState(() {
      // Remove the text controller and corresponding text field
      objectiveControllers.removeAt(index);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 25),
          child: Text(
            'Create Objective',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Merri'),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < objectiveControllers.length; i++)
                    Column(
                      children: [
                        CustomTextFormField(
                          controller: objectiveControllers[i],
                          label: 'Enter Objective',
                          hintText: 'Enter Objective Here',
                          suffixIcon: Icons.remove,
                          onSuffixIconPressed: ()=>_removeTextField(i),

                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  Custom_Button(
                    onPressedFunction: _addTextField,
                    ButtonText: 'Add More',
                  ),
                  SizedBox(height: 20),
                  Custom_Button(
                    onPressedFunction: () async {



                      List<String> objectiveDescription = objectiveControllers
                          .map((controller) => controller.text)
                          .toList();

                      print(objectiveDescription);
                      if (objectiveDescription.isEmpty ||
                          objectiveDescription.any((element) =>
                          element.isEmpty)) {
                        setState(() {
                          colorMessage = Colors.red;
                          errorColor = Colors.red;
                          errorMessage = 'Please enter all fields';
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        // Your logic to create course objective
                        bool created = await CourseObjective.createCourseObjective(
                          objectiveDescription,Course.id);
                        if (created) {
                          //Clear all the fields
                         objectiveControllers.clear();

                          setState(() {
                            isLoading = false;
                            colorMessage = Colors.green;
                            errorColor =
                                Colors.black12; // Reset errorColor to default value
                            errorMessage = 'Objective Created successfully';
                          });
                        }

                      }
                    },
                    ButtonText: 'Create Objective',
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: isLoading,
                    child: const CircularProgressIndicator(),
                  ),
                  errorMessage != null
                      ? Text(
                    errorMessage!,
                    style: TextStyle(color: colorMessage),
                  )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
