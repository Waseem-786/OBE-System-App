
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CourseObjective.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';




class CourseObjectiveProfile extends StatefulWidget {
  const CourseObjectiveProfile({super.key});

  @override
  State<CourseObjectiveProfile> createState() => _CourseObjectiveProfileState();
}

class _CourseObjectiveProfileState extends State<CourseObjectiveProfile> {


  // final peoId = PEO.id;
  final objectiveId=CourseObjective.id;

  String? errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Course Objective Profile',
            style: CustomTextStyles.headingStyle(fontSize: 22)),
      ),
      body: Column(
        children: [

          SingleChildScrollView(
            child: Container(
              height: 600,
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title for course details section.
                      Text("Objective Details",
                          style: CustomTextStyles.headingStyle()),

                      const SizedBox(height: 10),

                      // calling of the _buildCLOInfoCards() for every field of clo data that will be stored on the card
                      ..._buildObjectiveInfoCards(), // Spread operator (...) to
                      // unpack the list of clo info cards into children.
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),

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
                        "Are you sure you want to delete this PEO?",
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

                //If user confirms deletion, proceed with deletion
                if (confirmDelete) {
                  isLoading = true;
                  bool deleted = await CourseObjective.deleteObjective(objectiveId);
                  if (deleted) {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorMessage = 'Objective deleted successfully';
                    });

                    // Delay navigation and state update
                    await Future.delayed(const Duration(seconds: 0));

                    // Navigate back to the previous page and update its state
                    Navigator.of(context).pop(true);
                  } else {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.red;
                      errorMessage = 'Failed to delete Objective';
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

    List<Widget> _buildObjectiveInfoCards() {
      return [
        _buildObjectiveDetailCard("Objective Description", CourseObjective.description as String?),

      ];
    }

    Widget _buildObjectiveDetailCard(String label, String? value) {
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

