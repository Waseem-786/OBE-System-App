import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Campus_Profile extends StatelessWidget {
  final Map<String, dynamic>
      campus_data; // initializing the list to store the campus data we get from the campus management class
  // and show the data of that campus on which tap is pressed

  Campus_Profile(
      {required this.campus_data}); // Constructor to initialize the Campus_Profile widget with university data.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffc19a6b),
          title:  Center(child: Text('Campus Overview',style: CustomTextStyles.headingStyle(fontSize: 22))),
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
                        // Title for campus details section.
                        Text("Campus Details",
                            style: CustomTextStyles.headingStyle()),
                        const SizedBox(height: 10),

                        // calling of the _buildCampusInfoCards() for every field of campus data that will be stored on the card
                        ..._buildCampusInfoCards(), // Spread operator (...) to unpack the list of campus info cards into children.
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

  List<Widget> _buildCampusInfoCards() {
    return [
      _buildCampusDetailCard("Campus Name", campus_data['name']),
      _buildCampusDetailCard("Campus Mission", campus_data['mission']),
      _buildCampusDetailCard("Campus Vision", campus_data['vision']),
    ];
  }

  Widget _buildCampusDetailCard(String label, String? value) {
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
