import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CourseDashboard.dart';
import 'package:login_screen/CourseObjective.dart';
import 'package:login_screen/CourseObjectiveProfile.dart';
import 'package:login_screen/CreateCourseObjective.dart';
import 'package:login_screen/Create_Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'Course.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';


class CourseObjectivePage extends StatefulWidget {
  const CourseObjectivePage({super.key});

  @override
  State<CourseObjectivePage> createState() => _CourseObjectivePageState();
}

class _CourseObjectivePageState extends State<CourseObjectivePage> {

  late Future<List<dynamic>> objectiveFuture;

  @override
  void initState() {
    super.initState();
    objectiveFuture = CourseObjective.fetchObjectivesByCourseId(Course.id);
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        objectiveFuture = CourseObjective.fetchObjectivesByCourseId(Course.id);
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
            'Course Objective Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: objectiveFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final objectives = snapshot.data!;
                    return Expanded(
                        child: ListView.builder(
                            itemCount: objectives.length,
                            itemBuilder: (context, index) {
                              final objective = objectives[index];
                              return Card(
                                color: Colors.white,
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Objective ${index+1}',
                                      style: CustomTextStyles.bodyStyle(
                                          fontSize: 17),
                                    ),
                                  ),
                                  onTap: () async {
                                    // call of a function to get the data of that course whose id is passed and id is
                                    // passed by tapping the user
                                    var objective = await CourseObjective.getObjectivebyObjectiveId(objectives[index]['id']);
                                    print(objective);
                                    if (objective != null) {

                                      CourseObjective.id=objective['id'];
                                      CourseObjective.description=objective['description'];



                                      Navigator.push(
                                          context,
                                          MaterialPageRoute<bool>(
                                            builder: (context) =>
                                                CourseObjectiveProfile(),
                                          )).then((result) {
                                        if (result != null && result) {
                                          // Set the state of the page here
                                          setState(() {
                                            objectiveFuture = CourseObjective.fetchObjectivesByCourseId(Course.id)
;
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
                      MaterialPageRoute(builder: (context) => CreateCourseObjective()),
                    );
                  },
                  ButtonText: 'Add Objective',
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
