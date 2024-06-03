import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/User.dart';
import 'package:login_screen/Weekly_Topics.dart';

class CreateWeeklyTopic extends StatefulWidget {
  final bool isFromOutline;

  CreateWeeklyTopic({this.isFromOutline = false});

  @override
  State<StatefulWidget> createState() => CreateWeeklyTopicState();
}

class CreateWeeklyTopicState extends State<CreateWeeklyTopic> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  bool isLoading = false;
  Color errorColor = Colors.black12;
  String buttonText = 'Generate Weekly Topics';

  List<dynamic> weeklyTopics = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Create Weekly Topic',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (weeklyTopics.isNotEmpty) ..._buildWeeklyTopicList(),
                const SizedBox(height: 20),
                if (isLoading)
                  const Center(child: CircularProgressIndicator()),
                if (errorMessage != null)
                  Center(
                    child: Text(
                      errorMessage!,
                      style: CustomTextStyles.bodyStyle(color: colorMessage),
                    ),
                  ),
                Custom_Button(
                  onPressedFunction: _showCommentsDialog,
                  ButtonWidth: 280,
                  ButtonHeight: 50,
                  ButtonText: buttonText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCommentsDialog() async {
    String comments = "";
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Comments"),
          content: TextField(
            onChanged: (value) {
              comments = value;
            },
            decoration: InputDecoration(
              hintText: "Enter any additional comments or messages",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _generateWeeklyTopics(comments);
              },
              child: Text("Generate"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generateWeeklyTopics(String comments) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      weeklyTopics.clear();
    });

    try {
      List<dynamic> topics = await WeeklyTopics.generateWeeklyTopics(Course.id, User.id, 2, comments);

      setState(() {
        isLoading = false;
        weeklyTopics = topics;
        buttonText = 'Regenerate Weekly Topics';  // Change button text after topics are generated
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to generate weekly topics';
        colorMessage = Colors.red;
      });
    }
  }

  List<Widget> _buildWeeklyTopicList() {
    return weeklyTopics.map((topic) {
      return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          title: Text(
            topic['topic'],
            style: CustomTextStyles.headingStyle(fontSize: 16),
          ),
          subtitle: Text(
            topic['description'],
            style: CustomTextStyles.bodyStyle(),
          ),
          trailing: Text(
            'Week ${topic['week_number']}',
            style: CustomTextStyles.bodyStyle(),
          ),
        ),
      );
    }).toList();
  }
}
