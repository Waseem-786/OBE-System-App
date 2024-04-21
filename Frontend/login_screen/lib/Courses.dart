import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Course_Profile.dart';
import 'package:login_screen/Create_Course.dart';
import 'package:http/http.dart' as http;
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'main.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<StatefulWidget> createState() => CoursesState();
}

class CoursesState extends State<Courses> {
  late Future<List<dynamic>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = fetchCourses();
  }

  Future<List<dynamic>> fetchCourses() async {
    final ipAddress = MyApp.ip;
    const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    final accessToken = await storage.read(key: "access_token");
    final url = Uri.parse('$ipAddress:8000/api/course');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to Load Courses');
    }
  }

  Future<Map<String, dynamic>?> getCoursebyCode(String code) async {
    final courses = await coursesFuture;
    for (var course in courses) {
      if (course['code'] == code) {
        print(course);
        return course;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Courses',
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
                                    // call of a function to get the data of that course whose code is passed and code is
                                    // passed by tapping the user
                                    var user = await getCoursebyCode(
                                        courses[index]['code']);
                                    if (user != null) {
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
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Course_Profile()));
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
