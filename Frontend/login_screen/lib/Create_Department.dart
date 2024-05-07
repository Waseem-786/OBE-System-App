import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/UpdateWidget.dart';
import 'Department.dart';

class Create_Department extends StatefulWidget
{
  final bool isUpdate;
  final Map<String, dynamic>? DeptData;

  Create_Department({this.isUpdate = false, this.DeptData});

  @override
  State<Create_Department> createState() => _Create_DepartmentState();
}

class _Create_DepartmentState extends State<Create_Department> {
  final int campus_id = Campus.id;
  String?
  errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
  false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred

  late TextEditingController DepartmentNameController;
  late TextEditingController DepartmentMissionController;
  late TextEditingController DepartmentVisionController;
  @override
  void initState() {
    DepartmentNameController =
        TextEditingController(text: widget.DeptData?['name'] ?? '');
    DepartmentMissionController =
        TextEditingController(text: widget.DeptData?['mission'] ?? '');
    DepartmentVisionController =
        TextEditingController(text: widget.DeptData?['vision'] ?? '');
  }


  @override
  Widget build(BuildContext context){
    String buttonText = widget.isUpdate ? 'Update' : 'Create';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Form Page'),
        backgroundColor: const Color(0xffc19a6b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: DepartmentNameController,
              label: 'Department Name',
              hintText: 'Enter Department Name',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20,),
            CustomTextFormField(
              controller: DepartmentMissionController,
              label: 'Department Mission',
              hintText: 'Enter Department Mission',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20,),
            CustomTextFormField(
              controller: DepartmentVisionController,
              label: 'Department Vision',
              hintText: 'Enter Department Vision',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20,),
            Custom_Button(
              onPressedFunction: () async {
                if (widget.isUpdate) {
                  // Show confirmation dialog
                  bool confirmUpdate = await showDialog(
                    context: context,
                    builder: (context) => const UpdateWidget(
                      title: "Confirm Update",
                      content: "Are you sure you want to update Department?",
                    ),
                  );
                  if (!confirmUpdate) {
                    return; // Cancel the update if user selects 'No' in the dialog
                  }
                }
                // Continue with update or create logic
                String DepartmentName = DepartmentNameController.text;
                String DepartmentMission = DepartmentMissionController.text;
                String DepartmentVision = DepartmentVisionController.text;
                if (DepartmentName.isEmpty ||
                    DepartmentMission.isEmpty ||
                    DepartmentVision.isEmpty) {
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
                    result = await Department.updateDepartment(widget.DeptData?['id'],
                        DepartmentName, DepartmentMission, DepartmentVision);
                  } else {
                    result = await Department.createDepartment(
                        DepartmentName, DepartmentMission, DepartmentVision, campus_id);
                  }
                  if (result) {
                    // Clear the text fields
                    DepartmentNameController.clear();
                    DepartmentMissionController.clear();
                    DepartmentVisionController.clear();

                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor =
                          Colors.black12; // Reset errorColor to default value
                      errorMessage = widget.isUpdate
                          ? 'Department Updated successfully'
                          : 'Department Created successfully';
                    });
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
    );
  }
}