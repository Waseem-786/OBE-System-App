import 'package:flutter/material.dart';
import 'package:login_screen/CourseObjective.dart';
import 'Course.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'View_CLOs.dart';

class CreateCourseObjective extends StatefulWidget {
  final bool isFromOutline;

  CreateCourseObjective({this.isFromOutline = false});

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

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isFromOutline ? 'Next' : 'Create';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: const Text(
          'Create Objective',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Merri'),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.all(16),
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
                          onSuffixIconPressed: () => _removeTextField(i),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  Custom_Button(
                    onPressedFunction: _addTextField,
                    ButtonText: 'Add More',
                  ),
                  const SizedBox(height: 20),
                  Custom_Button(
                    onPressedFunction: () async {
                      List<String> objectiveDescription = objectiveControllers
                          .map((controller) => controller.text)
                          .toList();

                      if (objectiveDescription.isEmpty ||
                          objectiveDescription.any((element) => element.isEmpty)) {
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
                          CourseObjective.description = objectiveDescription;
                          // Navigate to the next screen if coming from outline
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => View_CLOs(isFromOutline: true), // Replace with your next screen
                            ),
                          );
                        } else {
                          bool created = await CourseObjective.createCourseObjective(
                            objectiveDescription,
                            Course.id,
                          );
                          if (created) {
                            // Clear all the fields
                            objectiveControllers.clear();
                            objectiveControllers.add(TextEditingController());

                            setState(() {
                              isLoading = false;
                              colorMessage = Colors.green;
                              errorColor = Colors.black12; // Reset errorColor to default value
                              errorMessage = 'Objective Created successfully';
                            });
                          }
                        }
                      }
                    },
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
                    style: TextStyle(color: colorMessage),
                  )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
