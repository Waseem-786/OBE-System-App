import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/University.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/UpdateWidget.dart';

class Create_University extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? UniversityData;

  Create_University({this.isUpdate = false, this.UniversityData});

  @override
  State<Create_University> createState() => _Create_UniversityState();
}

class _Create_UniversityState extends State<Create_University> {
  String? errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading = false; // variable for use the functionality of loading while request is processed to server
  Color errorColor =
      Colors.black12; // color of border of text fields when the error is not occurred

  late TextEditingController UniversityNameController;
  late TextEditingController UniversityMissionController;
  late TextEditingController UniversityVisionController;

  @override
  void initState() {
    UniversityNameController =
        TextEditingController(text: widget.UniversityData?['name'] ?? '');
    UniversityMissionController =
        TextEditingController(text: widget.UniversityData?['mission'] ?? '');
    UniversityVisionController =
        TextEditingController(text: widget.UniversityData?['vision'] ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isUpdate ? 'Update' : 'Create';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'University Form Page',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: UniversityNameController,
              label: 'University Name',
              hintText: 'Enter University Name',
              borderColor: errorColor,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: UniversityMissionController,
              label: 'University Mission',
              hintText: 'Enter University Mission',
              borderColor: errorColor,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              controller: UniversityVisionController,
              label: 'University Vision',
              hintText: 'Enter University Vision',
              borderColor: errorColor,
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
                        content: "Are you sure you want to update University?",
                      ),
                    );
                    if (!confirmUpdate) {
                      return; // Cancel the update if user selects 'No' in the dialog
                    }
                  }

                  String UniversityName = UniversityNameController.text;
                  String UniversityMission = UniversityMissionController.text;
                  String UniversityVision = UniversityVisionController.text;
                  if (UniversityName.isEmpty ||
                      UniversityMission.isEmpty ||
                      UniversityVision.isEmpty) {
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
                      result = await University.updateUniversity(
                          widget.UniversityData?['id'],
                          UniversityName,
                          UniversityMission,
                          UniversityVision);
                    } else {
                      result = await University.createUniversity(
                          UniversityName, UniversityMission, UniversityVision);
                    }
                    if (result) {
                      // Clear all the fields
                      UniversityNameController.clear();
                      UniversityMissionController.clear();
                      UniversityVisionController.clear();

                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorColor =
                            Colors.black12; // Reset errorColor to default value
                        errorMessage = widget.isUpdate
                            ? 'University updated successfully'
                            : 'University created successfully';
                      });
                    }
                  }
                },
                BackgroundColor: Color(0xffc19a6b),
                ForegroundColor: Colors.white,
                ButtonText: buttonText,
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
    );
  }
}
