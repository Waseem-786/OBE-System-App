import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course_Schedule.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';


class CourseScheduleProfile extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => CourseScheduleProfileState();
}

class CourseScheduleProfileState extends State<CourseScheduleProfile>{

  String?
  errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading =
  false;
  // variable for use the functionality of loading while request is processed to server

  @override
  void initState() {
    super.initState();
  }

  Future setCourseScheduleData() async {
    var courseScheduleFuture = await Course_Schedule.fetchCourseScheduleByCourseOutline(3);
    if(courseScheduleFuture.isNotEmpty){
        Course_Schedule.id = courseScheduleFuture[0]['id'];
        Course_Schedule.lecture_hours_per_week = courseScheduleFuture[0]['lecture_hours_per_week'];
        Course_Schedule.lab_hours_per_week = courseScheduleFuture[0]['lab_hours_per_week'];
        Course_Schedule.discusion_hours_per_week = courseScheduleFuture[0]['discussion_hours_per_week'];
        Course_Schedule.office_hours_per_week = courseScheduleFuture[0]['office_hours_per_week'];
    }
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Course Schedule Profile',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
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
                        // Title for course schedule section.
                        Text("Course Schedule",
                            style: CustomTextStyles.headingStyle()),
                        const SizedBox(height: 10),
                        // calling of the _buildCourseScheduleInfoCards() for every field of course schedule data that will be stored on the card
                        ..._buildCourseScheduleInfoCards(), // Spread operator (...) to unpack the list of course schedule info cards into children.
                      ],
                    ),
                  ),
                ),
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

  List<Widget> _buildCourseScheduleInfoCards() {
    setCourseScheduleData();
    return [
      _buildCourseScheduleDetailCard("Lecture Hours per Week", Course_Schedule.lecture_hours_per_week.toString()),
      _buildCourseScheduleDetailCard("Lab Hours per Week", Course_Schedule.lab_hours_per_week.toString()),
      _buildCourseScheduleDetailCard("Discussion Hours per Week", Course_Schedule.discussion_hours_per_week.toString()),
      _buildCourseScheduleDetailCard("Office Hours per Week", Course_Schedule.office_hours_per_week.toString()),
    ];
  }

  Widget _buildCourseScheduleDetailCard(String label, String? value) {
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