import 'package:flutter/material.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Course_Profile.dart';
import 'package:login_screen/Create_Course.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Course_Page extends StatefulWidget {
  const Course_Page({super.key});

  @override
  State<StatefulWidget> createState() => Course_PageState();
}

class Course_PageState extends State<Course_Page> {
  late Future<List<dynamic>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = Course.fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Course Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final courses = snapshot.data!;
                    return Expanded(
                        child: ListView.builder(
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final course = courses[index];
                              return Card(
                                color: Colors.white,
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      course['title'],
                                      style: CustomTextStyles.bodyStyle(
                                          fontSize: 17),
                                    ),
                                  ),
                                  onTap: () async {
                                    // call of a function to get the data of that course whose id is passed and id is
                                    // passed by tapping the user
                                    var user = await Course.getCoursebyId(courses[index]['id']);
                                    if (user != null) {
                                      Course.id = user['id'];
                                      Course.code = user['code'];
                                      Course.title = user['title'];
                                      Course.theory_credits =
                                          user['theory_credits'];
                                      Course.lab_credits = user['lab_credits'];
                                      Course.course_type = user['course_type'];
                                      Course.required_elective =
                                          user['required_elective'];
                                      Course.prerequisite =
                                          user['prerequisite'];
                                      Course.description = user['description'];

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute<bool>(
                                            builder: (context) => Course_Profile(),
                                          )).then((result) {
                                        if (result != null && result) {
                                          // Set the state of the page here
                                          setState(() {
                                            coursesFuture = Course.fetchCourses();
                                          });
                                        }
                                      });
                                    }
                                  },
                                ),
                              );
                            }));
                  }
                }),
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 12),
                child: Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Create_Course()),
                    );
                  },
                  ButtonText: 'Add Course',
                  ButtonWidth: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
