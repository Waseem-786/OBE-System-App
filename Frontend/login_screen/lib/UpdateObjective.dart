import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CourseObjective.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/UpdateWidget.dart';

class UpdateObjective extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? ObjectiveData;

  UpdateObjective({this.isUpdate = false, this.ObjectiveData});

  @override
  State<UpdateObjective> createState() => _UpdateObjectiveState();
}

class _UpdateObjectiveState extends State<UpdateObjective> {
  late bool result;
  String?
      errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
      false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred

  late TextEditingController ObjectiveDescriptionController;
  @override
  void initState() {
    ObjectiveDescriptionController =
        TextEditingController(text: widget.ObjectiveData?['description'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Objective Page',
            style: CustomTextStyles.headingStyle(fontSize: 20)),
        backgroundColor: const Color(0xffc19a6b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: ObjectiveDescriptionController,
              label: 'Objective',
              hintText: 'Enter Objective Description',
              borderColor: errorColor,
            ),
            SizedBox(
              height: 20,
            ),
            Custom_Button(
              onPressedFunction: () async {
                // Show confirmation dialog
                bool confirmUpdate = await showDialog(
                  context: context,
                  builder: (context) => const UpdateWidget(
                    title: "Confirm Update",
                    content: "Are you sure you want to update Objective?",
                  ),
                );

                // Continue with update only if user selects 'Yes' in the dialog
                // ??: This is the null-aware operator. It returns the expression on its left if that expression is not null, otherwise it returns the expression on its right.
                if (confirmUpdate ?? false) {
                  String ObjectiveDescription =
                      ObjectiveDescriptionController.text;
                  if (ObjectiveDescription.isEmpty) {
                    setState(() {
                      colorMessage = Colors.red;
                      errorColor = Colors.red;
                      errorMessage = 'Please enter Objective Description';
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    result = await CourseObjective.updateObjective(
                        widget.ObjectiveData?['id'], ObjectiveDescription);
                    if (result) {
                      ObjectiveDescriptionController.clear();
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorColor = Colors.black12;
                        errorMessage = 'Objective Updated successfully';
                      });
                    }
                  }
                }
              },
              BackgroundColor: Color(0xffc19a6b),
              ForegroundColor: Colors.white,
              ButtonText: "Update",
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
    );
  }
}
