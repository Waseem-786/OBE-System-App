import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Department.dart';

class Department_Profile extends StatefulWidget {
  @override
  State<Department_Profile> createState() => _Department_ProfileState();
}

class _Department_ProfileState extends State<Department_Profile> {
  String?
  errorMessage;
 //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
 // color of the message when the error occurs
  var isLoading =
  false;
 // variable for use the functionality of loading while request is processed to server
  final departmentId = Department.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Department Profile')),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                height: 550,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title for department details section.
                        Text("Department Details",
                            style: CustomTextStyles.headingStyle()),
                        const SizedBox(height: 10),

                        // calling of the _buildDepartmentInfoCards() for every field of department data that will be stored on the card
                        ..._buildDepartmentInfoCards(), // Spread operator (...) to unpack the list of department info cards into children.
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Button for delete functionality.
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Custom_Button(
                onPressedFunction: () async {
                  // Show confirmation dialog
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor:
                      Colors.red, // Set background color to red for danger
                      title: const Row(
                        children: [
                          Icon(Icons.warning,
                              color: Colors.yellow), // Add warning icon
                          SizedBox(width: 10),
                          Text("Confirm Deletion",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      content: const Text(
                          "Are you sure you want to delete this Department?",
                          style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Dismiss the dialog and confirm deletion
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Yes",
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {
                            // Dismiss the dialog and cancel deletion
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("No",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );

                  // If user confirms deletion, proceed with deletion
                  if (confirmDelete) {
                    isLoading = true;
                    bool deleted = await Department.deleteDepartment(departmentId);
                    if (deleted) {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorMessage = 'Department deleted successfully';
                      });

                      // Delay navigation and state update
                      await Future.delayed(const Duration(seconds: 2));

                      // Navigate back to the previous page and update its state
                      Navigator.of(context).pop(true);
                    } else {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.red;
                        errorMessage = 'Failed to delete Department';
                      });
                    }
                  }
                },
                BackgroundColor: Colors.red,
                ForegroundColor: Colors.white,
                ButtonText: "Delete",
                ButtonWidth: 120,
              ),
            ),
            Visibility(
              visible: isLoading,
              child: const CircularProgressIndicator(),
            ),
            errorMessage != null
                ? Text(
              errorMessage!,
              style: CustomTextStyles.bodyStyle(color: colorMessage),
            )
                : const SizedBox()
          ],
        ));
  }

  List<Widget> _buildDepartmentInfoCards() {
    return [
      _buildDepartmentDetailCard("Department Name", Department.name),
      _buildDepartmentDetailCard(
          "Department Mission", Department.mission),
      _buildDepartmentDetailCard(
          "Department Vision",Department.vision),
    ];
  }

  Widget _buildDepartmentDetailCard(String label, String? value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "$label: ${value ?? 'Not provided'}",
            style: CustomTextStyles.bodyStyle(fontSize: 19),
          ),
        ),
      ),
    );
  }
}
