import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Department_Page.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Campus_Profile extends StatefulWidget {
  @override
  State<Campus_Profile> createState() => _Campus_ProfileState();
}

class _Campus_ProfileState extends State<Campus_Profile> {
  final campus_id = Campus.id;
  String?
      errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
      false; // variable for use the functionality of loading while request is processed to server

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
          title: Center(
              child: Text('Campus Profile',
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
            //
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Custom_Button(
                onPressedFunction: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Department_Page()));
                },
                BackgroundColor: Colors.green,
                ForegroundColor: Colors.white,
                ButtonText: "Show Department",
                ButtonWidth: 215,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Custom_Button(
                onPressedFunction: () async {
                  // Show confirmation dialog
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.red, // Set background color to red for danger
                      title: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.yellow), // Add warning icon
                          SizedBox(width: 10),
                          Text("Confirm Deletion", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      content: const Text("Are you sure you want to delete this campus?", style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Dismiss the dialog and confirm deletion
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Yes", style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {
                            // Dismiss the dialog and cancel deletion
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("No", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );

                  // If user confirms deletion, proceed with deletion
                  if (confirmDelete) {
                    isLoading = true;
                    bool deleted = await Campus.deleteCampus(campus_id);
                    if (deleted) {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorMessage = 'Campus is deleted successfully';
                      });

                      // Delay navigation and state update
                      await Future.delayed(const Duration(seconds: 2));

                      // Navigate back to the previous page and update its state
                      Navigator.of(context).pop(true);
                    } else {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.red;
                        errorMessage = 'Failed to delete Campus';
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

  List<Widget> _buildCampusInfoCards() {
    return [
      _buildCampusDetailCard("Campus Name", Campus.name),
      _buildCampusDetailCard("Campus Mission", Campus.mission),
      _buildCampusDetailCard("Campus Vision", Campus.vision),
    ];
  }

  Widget _buildCampusDetailCard(String label, String? value) {
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
