import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'User.dart';

// User_Profile widget displays user details received as a Map<String, dynamic> from the user management class
class User_Profile extends StatefulWidget {
  final Map<String, dynamic>
      user_data;
  User_Profile({required this.user_data});
  @override
  State<User_Profile> createState() => _User_ProfileState();
}

class _User_ProfileState extends State<User_Profile> {
 // initializing the list to store the user's data we get from the user management class
  String?
  errorMessage;
 //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
 // color of the message when the error occurs
  var isLoading =
  false;
 // Constructor to initialize the User_Profile widget with user's data.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
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
                      const SizedBox(height: 10),

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
                        "Are you sure you want to delete this user?",
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
                  bool deleted = await User.deleteUser(widget.user_data['id']);
                  if (deleted) {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorMessage = 'User is deleted successfully';
                    });

                    // Delay navigation and state update
                    await Future.delayed(const Duration(seconds: 2));

                    // Navigate back to the previous page and update its state
                    Navigator.of(context).pop(true);
                  } else {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.red;
                      errorMessage = 'Failed to delete User';
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
      )
    );
  }

  // Method to build a list of data of user on cards.
  List<Widget> _buildUserInfoCards() {
    return [
      _buildUserDetailCard("First Name", widget.user_data['first_name']),
      _buildUserDetailCard("Last Name", widget.user_data['last_name']),
      _buildUserDetailCard("University", widget.user_data['university_name']),
      _buildUserDetailCard("Campus", widget.user_data['campus_name']),
      _buildUserDetailCard("Username", widget.user_data['username']),
      _buildUserDetailCard("Email", widget.user_data['email']),
    ];
  }

  // Method to build a single user info card.
  Widget _buildUserDetailCard(String label, String? value) {
    return SizedBox(
      width: double.infinity,

      child: Card(
        color: Colors.white,
        elevation: 5,
        margin: const EdgeInsets.all(10),
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
