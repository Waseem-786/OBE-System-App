import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus_Page.dart';
import 'package:login_screen/University.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class University_Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //storing the id of the university to pass in the campus page because only the campuses of that
    // university should be shown in the campus page whose id is passed
    final university_id = University.id;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffc19a6b),
          title: Center(child: Text('University Profile',style: CustomTextStyles.headingStyle(fontSize: 22))),
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Custom_Button(
                onPressedFunction: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => Campus_Page()));
                },
                BackgroundColor: Colors.green,
                ForegroundColor: Colors.white,
                ButtonText: "Show Campus",
                ButtonWidth: 170,
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
      _buildUniversityDetailCard("University Name", University.name),
      _buildUniversityDetailCard(
          "University Mission", University.mission),
      _buildUniversityDetailCard(
          "University Vision", University.vision),
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
