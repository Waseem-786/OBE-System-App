

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_screen/Role.dart';

import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
class RoleProfile extends StatefulWidget {

  @override
  State<RoleProfile> createState() => _RoleProfileState();
}

class _RoleProfileState extends State<RoleProfile> {

  String? errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
            child: Text('Role Profile',
                style: CustomTextStyles.headingStyle(fontSize: 22))),
      ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                height: 500,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title for course details section.
                        Text("Role Details",
                            style: CustomTextStyles.headingStyle()),
                        const SizedBox(height: 10),

                        // calling of the _buildCourseInfoCards() for every field of course data that will be stored on the card
                        ..._buildRoleInfoCards(), // Spread operator (...) to
                        // unpack the list of course info cards into children.
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Custom_Button(
                onPressedFunction: () {
                //   Navigator.push(context, MaterialPageRoute(builder:
                //       (context)=>Course_Outline_Page()));
                },
                BackgroundColor: Colors.green,
                ForegroundColor: Colors.white,
                ButtonText: "Show Users",
                ButtonWidth: 190,
              ),
            ),
            // Button for delete functionality.
            Padding(
              padding: const EdgeInsets.only(bottom:  20.0),
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
                          "Are you sure you want to delete this Role?",
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
                    bool deleted = await Role.deleteCourse(Role.id);
                    if (deleted) {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorMessage = 'Role deleted successfully';
                      });

                      // Delay navigation and state update
                      await Future.delayed(const Duration(seconds: 2));

                      // Navigate back to the previous page and update its state
                      Navigator.of(context).pop(true);
                    } else {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.red;
                        errorMessage = 'Failed to delete Role';
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

  List<Widget> _buildRoleInfoCards() {
    return [
      _buildRoleDetailCard("Role Name", Role.name),
      _buildRoleDetailCard("University Name", Role.university_name),
      _buildRoleDetailCard("Campus Name", Role.campus_name),
      _buildRoleDetailCard("Department Name", Role.department_name),

    ];
  }

  Widget _buildRoleDetailCard(String label, String? value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "$label: ${value ?? 'Null'}",
            style: CustomTextStyles.bodyStyle(fontSize: 19),
          ),
        ),
      ),
    );
  }

}
