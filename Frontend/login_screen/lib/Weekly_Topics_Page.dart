import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/Weekly_Topics.dart';

import 'Create_Weekly_Topic.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Weekly_Topic_Profile.dart';

class WeeklyTopicsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => WeeklyTopicsPageState();
}

class WeeklyTopicsPageState extends State<WeeklyTopicsPage>{
  late Future<List<dynamic>> weeklyTopicsFuture;
  static final courseOutlineId = Outline.id;

  @override
  void initState() {
    weeklyTopicsFuture = WeeklyTopics.fetchWeeklyTopicsByCourseOutline(courseOutlineId);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        weeklyTopicsFuture = WeeklyTopics.fetchWeeklyTopicsByCourseOutline(courseOutlineId);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text( 'Weekly Topics Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: weeklyTopicsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final weeklyTopics = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: weeklyTopics.length,
                    itemBuilder: (context, index) {
                      final weeklyTopic = weeklyTopics[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('Week - ${weeklyTopic['week_number']}',
                              style: CustomTextStyles.bodyStyle(fontSize: 17),
                            ),
                          ),
                          onTap: () async {
                            // call of a function to get the data of that weekly Topic whose id is passed and id is
                            // passed by tapping the weekly topic
                            var weeklyTopic = await WeeklyTopics.getWeeklyTopicById(weeklyTopics[index]['id']);
                            if (weeklyTopic != {}) {
                              WeeklyTopics.id = weeklyTopic?['id'];
                              WeeklyTopics.week_number = weeklyTopic?['week_number'];
                              WeeklyTopics.topic = weeklyTopic?['topic'];
                              WeeklyTopics.description = weeklyTopic?['description'];
                              WeeklyTopics.clo = weeklyTopic?['clo'];
                              WeeklyTopics.assessments = weeklyTopic?['assessments'];
                              WeeklyTopics.course_outline = weeklyTopic?['course_outline'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (context) => WeeklyTopicProfile(),
                                  )).then((result) {
                                if (result != null && result) {
                                  // Set the state of the page here
                                  setState(() {
                                    weeklyTopicsFuture = WeeklyTopics.fetchWeeklyTopicsByCourseOutline(courseOutlineId);
                                  });
                                }
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, top: 12),
              child: Custom_Button(
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateWeeklyTopic()),
                  );
                },
                ButtonText: 'Add Weekly Topic',
                ButtonWidth: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }
}