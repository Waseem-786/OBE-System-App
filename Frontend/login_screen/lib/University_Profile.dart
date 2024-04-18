import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class University_Profile extends StatelessWidget {
  final Map<String, dynamic>
      university_data; // initializing the list to store the university data we get from the university management class
  // and show the data of that university on which tap is pressed

  University_Profile(
      {required this.university_data}); // Constructor to initialize the University_Profile widget with university data.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffc19a6b),
          title: Center(child: Text('University Overview',style: CustomTextStyles.headingStyle(fontSize: 22))),
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
                        // Title for university details section.
                        Text("University Details",
                            style: CustomTextStyles.headingStyle()),
                        const SizedBox(height: 10),

                        // calling of the _buildUniversityInfoCards() for every field of university data that will be stored on the card
                        ..._buildUniversityInfoCards(), // Spread operator (...) to unpack the list of university info cards into children.
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

  List<Widget> _buildUniversityInfoCards() {
    return [
      _buildUniversityDetailCard("University Name", university_data['name']),
      _buildUniversityDetailCard(
          "University Mission", university_data['mission']),
      _buildUniversityDetailCard(
          "University Vision", university_data['vision']),
    ];
  }

  Widget _buildUniversityDetailCard(String label, String? value) {
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
