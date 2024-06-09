import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/User.dart';
import 'package:login_screen/Weekly_Topics.dart';
import 'package:login_screen/View_CLOs.dart';

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

  List<Map<String, dynamic>> weeklyTopics = [];

  @override
  Widget build(BuildContext context) {
    String nextButtonText = widget.isFromOutline ? 'Next' : 'Create';
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
                  ButtonWidth: 300,
                  ButtonText: buttonText,
                  ButtonIcon: Icons.generating_tokens,
                  BackgroundColor: Colors.blue,
                ),
                const SizedBox(height: 20),
                Custom_Button(
                  onPressedFunction: () {
                    if (widget.isFromOutline && weeklyTopics.isEmpty) {
                      setState(() {
                        errorMessage = 'Please generate weekly topics first';
                        colorMessage = Colors.red;
                      });
                    } else {
                      widget.isFromOutline ? _storeWeeklyTopicsAndNavigate() : _createWeeklyTopics();
                    }
                  },
                  ButtonWidth: 140,
                  ButtonText: nextButtonText,
                  ButtonIcon: Icons.navigate_next,
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
      List<dynamic> topics = await WeeklyTopics.generateWeeklyTopics(Outline.id, comments);
      setState(() {
        isLoading = false;
        weeklyTopics = topics.map((topic) {
          return {
            'week_number': topic['week_number'] ?? '',
            'topic': topic['topic'] ?? 'No Topic',
            'description': topic['description'] ?? 'No Description',
            'course_outline': Outline.id,
          } as Map<String, dynamic>;
        }).toList();
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

  Future<void> _createWeeklyTopics() async {
    if (weeklyTopics.isEmpty) {
      setState(() {
        errorMessage = 'Please generate weekly topics first';
        colorMessage = Colors.red;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      bool success = await WeeklyTopics.createWeeklyTopics(Outline.id, weeklyTopics);

      setState(() {
        isLoading = false;
        if (success) {
          errorMessage = 'Weekly topics created successfully';
          colorMessage = Colors.green;
          weeklyTopics.clear(); // Clear the list after creation
        } else {
          errorMessage = 'Failed to create weekly topics';
          colorMessage = Colors.red;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to create weekly topics';
        colorMessage = Colors.red;
      });
    }
  }

  void _storeWeeklyTopicsAndNavigate() {
    if (weeklyTopics.isEmpty) {
      setState(() {
        errorMessage = 'Please generate weekly topics first';
        colorMessage = Colors.red;
      });
      return;
    }

    // Store weekly topics data in a static or singleton class
    WeeklyTopics.weeklyTopics = weeklyTopics;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => View_CLOs(isFromOutline: true)),
    );
  }

  List<Widget> _buildWeeklyTopicList() {
    return weeklyTopics.map((topic) {
      return Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          title: Text(
            topic['topic'] ?? 'No Topic',
            style: CustomTextStyles.headingStyle(fontSize: 16),
          ),
          subtitle: Text(
            topic['description'] ?? 'No Description',
            style: CustomTextStyles.bodyStyle(),
          ),
          trailing: Text(
            'Week ${topic['week_number'] ?? ''}',
            style: CustomTextStyles.bodyStyle(),
          ),
        ),
      );
    }).toList();
  }
}
