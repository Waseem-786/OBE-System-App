import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus_Page.dart';
import 'package:login_screen/University.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class University_Profile extends StatefulWidget {

  @override
  State<University_Profile> createState() => _University_ProfileState();
}

class _University_ProfileState extends State<University_Profile> {
  final university_id = University.id;

  String?
  errorMessage;
 //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
 // color of the message when the error occurs
  var isLoading =
  false;
 // variable for use the functionality of loading while request is processed to server
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Campus_Page()));
                },
                BackgroundColor: Colors.green,
                ForegroundColor: Colors.white,
                ButtonText: "Show Campuses",
                ButtonWidth: 200,
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
                          "Are you sure you want to delete this University?",
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
                    bool deleted = await University.deleteUniversity(university_id);
                    if (deleted) {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorMessage = 'University is deleted successfully';
                      });

                      // Delay navigation and state update
                      await Future.delayed(const Duration(seconds: 2));

                      // Navigate back to the previous page and update its state
                      Navigator.of(context).pop(true);
                    } else {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.red;
                        errorMessage = 'Failed to delete University';
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
