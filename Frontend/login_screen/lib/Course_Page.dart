import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Course_Profile.dart';
import 'package:login_screen/Create_Course.dart';
import 'package:login_screen/Custom_Widgets/PermissionBasedButton.dart';
import 'package:login_screen/Permission.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Course_Page extends StatefulWidget {
  const Course_Page({super.key});

  @override
  State<StatefulWidget> createState() => Course_PageState();
}

class Course_PageState extends State<Course_Page> {
  late Future<List<dynamic>> coursesFuture;
  late Future<bool> hasEditCoursePermissionFuture;
  late Future<bool> hasAddCoursePermissionFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = Course.fetchCoursesbyCampusId(Campus.id);
    hasEditCoursePermissionFuture = Permission.searchPermissionByCodename("change_courseinformation");
    hasAddCoursePermissionFuture = Permission.searchPermissionByCodename("add_courseinformation");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        coursesFuture = Course.fetchCoursesbyCampusId(Campus.id);
      });
    }
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
                    if (courses.length == 0) {
                      return Center(
                        child: Text('No Courses to Show'),
                      );
                    } else {
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
                                      var course = await Course.getCoursebyId(
                                          courses[index]['id']);
                                      if (course != null) {
                                        Course.id = course['id'];
                                        Course.code = course['code'];
                                        Course.title = course['title'];
                                        Course.theory_credits =
                                            course['theory_credits'];
                                        Course.lab_credits =
                                            course['lab_credits'];
                                        Course.course_type =
                                            course['course_type'];
                                        Course.required_elective =
                                            course['required_elective'];
                                        Course.prerequisite =
                                            course['prerequisite'];
                                        Course.description =
                                            course['description'];
                                        Course.campus = course['campus'];

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<bool>(
                                              builder: (context) =>
                                                  Course_Profile(),
                                            )).then((result) {
                                          if (result != null && result) {
                                            // Set the state of the page here
                                            setState(() {
                                              coursesFuture =
                                                  Course.fetchCoursesbyCampusId(
                                                      Campus.id);
                                            });
                                          }
                                        });
                                      }
                                    },
                                  ),
                                );
                              }));
                    }
                  }
                }),
            PermissionBasedButton(
                buttonText: "Add Course",
                buttonWidth: 200,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Create_Course()));
                },
                permissionFuture: hasAddCoursePermissionFuture,
            ),
          ],
        ),
      ),
    );
  }
}
