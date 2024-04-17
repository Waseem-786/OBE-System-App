import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

// User_Profile widget displays user details received as a Map<String, dynamic> from the user management class
class User_Profile extends StatelessWidget {
  final Map<String, dynamic>
      user_data; // initializing the list to store the user's data we get from the user management class
                  // and show the data of that user on which tap is pressed

  User_Profile({required this.user_data}); // Constructor to initialize the User_Profile widget with user's data.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'User Profile',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
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
                      // Title for user details section.
                      Text("User Details", style: CustomTextStyles.headingStyle()),
                      SizedBox(height: 10),
            
                      // calling of the _buildUserInfoCards() for every field of user data that will be stored on the card
                      ..._buildUserInfoCards(),// Spread operator (...) to unpack the list of user info cards into children.
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
      )
    );
  }

  // Method to build a list of data of user on cards.
  List<Widget> _buildUserInfoCards() {
    return [
      _buildUserDetailCard("First Name", user_data['first_name']),
      _buildUserDetailCard("Last Name", user_data['last_name']),
      _buildUserDetailCard("University", user_data['university_name']),
      _buildUserDetailCard("Campus", user_data['campus_name']),
      _buildUserDetailCard("Username", user_data['username']),
      _buildUserDetailCard("Email", user_data['email']),
    ];
  }

  // Method to build a single user info card.
  Widget _buildUserDetailCard(String label, String? value) {
    return SizedBox(
      width: double.infinity,
      height: 90,
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
