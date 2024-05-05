import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Weekly_Topics.dart';

import 'Custom_Widgets/Custom_Button.dart';

class WeeklyTopicProfile extends StatefulWidget{
  const WeeklyTopicProfile({super.key});

  @override
  State<StatefulWidget> createState() => WeeklyTopicProfileState();
}

class WeeklyTopicProfileState extends State<WeeklyTopicProfile>{
  final weeklyTopicId = WeeklyTopics.id;

  String?
  errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading =
  false;
  // variable for use the functionality of loading while request is processed to server

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Weekly Topic Profile',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: 450,
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title for Weekly Topic details section.
                      Text("Weekly Topic Details",
                          style: CustomTextStyles.headingStyle()),
                      const SizedBox(height: 10),

                      // calling of the _buildWeeklyTopicInfoCards() for every field of weekly topic data that will be stored on the card
                      ..._buildWeeklyTopicInfoCards(), // Spread operator (...) to unpack the list of weekly topic info cards into children.
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

              },
              BackgroundColor: Colors.green,
              ForegroundColor: Colors.white,
              ButtonText: "Update Weekly Topic",
              ButtonWidth: 250,
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
                        "Are you sure you want to delete this Weekly Topic?",
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
                  bool deleted = await WeeklyTopics.deleteWeeklyTopic(weeklyTopicId!);
                  if (deleted) {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorMessage = 'Weekly Topic is deleted successfully';
                    });

                    // Delay navigation and state update
                    await Future.delayed(const Duration(seconds: 2));

                    // Navigate back to the previous page and update its state
                    Navigator.of(context).pop(true);
                  } else {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.red;
                      errorMessage = 'Failed to delete Weekly Topic';
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
      ),
    );
  }

  List<Widget> _buildWeeklyTopicInfoCards() {
    return [
      _buildWeeklyTopicDetailCard("Week Number", WeeklyTopics.week_number.toString()),
      _buildWeeklyTopicDetailCard("Topic", WeeklyTopics.topic),
      _buildWeeklyTopicDetailCard("Description", WeeklyTopics.description),
      _buildWeeklyTopicDetailCard("CLOs", WeeklyTopics.clo.toString()),
      _buildWeeklyTopicDetailCard("Assessments", WeeklyTopics.assessments),
    ];
  }

  Widget _buildWeeklyTopicDetailCard(String label, String? value) {
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