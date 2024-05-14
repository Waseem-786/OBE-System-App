import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/CourseDashboard.dart';
import 'package:login_screen/Custom_Widgets/PermissionBasedButton.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/Permission.dart';
import 'package:login_screen/User.dart';
import 'Create_University.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Course_Outline_Page extends StatefulWidget
{
  @override
  State<Course_Outline_Page> createState() => _Course_Outline_PageState();
}

class _Course_Outline_PageState extends State<Course_Outline_Page> {
  late Future<List<dynamic>> CourseOutlines;
  late Future<bool> hasEditOutlinePermissionFuture;
  late Future<bool> hasAddOutlinePermissionFuture;

  @override
  void initState() {
    if(User.isdeptLevel()) {
      CourseOutlines = Outline.fetchOutlineByTeacher(User.id);
    } else {
      CourseOutlines = Outline.fetchOutlineByCourse(Course.id);
    }
    hasAddOutlinePermissionFuture = Permission.searchPermissionByCodename("add_courseoutline");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        if(User.isdeptLevel()) {
          CourseOutlines = Outline.fetchOutlineByTeacher(User.id);
        } else {
          CourseOutlines = Outline.fetchOutlineByCourse(Course.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
            'Course Outline Page',style: CustomTextStyles.headingStyle(fontSize: 22)
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: CourseOutlines,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final CourseOutline = snapshot.data!;
                if(CourseOutline.length == 0) {
                  return Center(child: Text('No Course Outline to Show'));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: CourseOutline.length,
                      itemBuilder: (context, index) {
                        final item = CourseOutline[index];
                        return Card(
                          color: Colors.white,
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                item['batch_name'] ?? '',
                                style: CustomTextStyles.bodyStyle(fontSize: 17),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
                              child: Text(
                                item['course_name'] ?? '',
                                style: CustomTextStyles.bodyStyle(fontSize: 14),
                              ),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                              child: Text(
                                "By: "+item['teacher_name'] ?? '',
                                style: CustomTextStyles.bodyStyle(fontSize: 17),
                              ),
                            ),
                            onTap: () async {
                              // call of a function to get the data of that user whose id is passed and id is
                              // passed by tapping the user
                              var Singleoutline = await Outline.fetchSingleOutline(
                                  CourseOutline[index]['id']);
                              if (Singleoutline != null) {
                                Outline.id = Singleoutline['id'];
                                Outline.course = Singleoutline['course'];
                                Outline.batch = Singleoutline['batch'];
                                Outline.teacher = Singleoutline['teacher'];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<bool>(
                                      builder: (context) => CourseDashboard(),
                                    )).then((result) {
                                  if (result != null && result) {
                                    // Set the state of the page here
                                    setState(() {
                                      if(User.isdeptLevel()) {
                                        CourseOutlines = Outline.fetchOutlineByTeacher(User.id);
                                      } else {
                                        CourseOutlines = Outline.fetchOutlineByCourse(Course.id);
                                      }
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
              }
            },
          ),
          PermissionBasedButton(
              buttonText: "Add Course Outline",
              buttonWidth: 300,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Create_University()));
              },
              permissionFuture: hasAddOutlinePermissionFuture,
          ),
        ],
      ),

    );
  }
}