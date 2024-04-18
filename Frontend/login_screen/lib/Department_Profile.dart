import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Department_Profile extends StatelessWidget {
  final Map<String, dynamic>
      department_data; // initializing the list to store the department data we get from the department management class
  // and show the data of that department on which tap is pressed

  Department_Profile(
      {required this.department_data}); // Constructor to initialize the Department_Profile widget with department data.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Department Overview')),
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
                onPressedFunction: () {
                  // Implement delete functionality.
                },
                BackgroundColor: Colors.red,
                ForegroundColor: Colors.white,
                ButtonText: "Delete",
                ButtonWidth: 120,
              ),
            )
          ],
        ));
  }

  List<Widget> _buildDepartmentInfoCards() {
    return [
      _buildDepartmentDetailCard("Department Name", department_data['name']),
      _buildDepartmentDetailCard(
          "Department Mission", department_data['mission']),
      _buildDepartmentDetailCard(
          "Department Vision", department_data['vision']),
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
