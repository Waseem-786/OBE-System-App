import 'package:flutter/material.dart';
import 'package:login_screen/Approval_Process.dart';
import 'package:login_screen/Assessments.dart';
import 'package:login_screen/BatchPage.dart';
import 'package:login_screen/Batch_Management.dart';
import 'package:login_screen/CLO_Page.dart';
import 'package:login_screen/Campus_Page.dart';
import 'package:login_screen/CourseBookPage.dart';
import 'package:login_screen/Course_Schedule_Profile.dart';
import 'package:login_screen/CreateCourseBook.dart';
import 'package:login_screen/CreateCourseObjective.dart';
import 'package:login_screen/Create_Course_Assessment_Page.dart';
import 'package:login_screen/Course_Page.dart';
import 'package:login_screen/Create_Course_Schedule.dart';
import 'package:login_screen/Department_Page.dart';
import 'package:login_screen/Program_Management.dart';
import 'package:login_screen/PLO_Page.dart';
import 'package:login_screen/University_Page.dart';
import 'package:login_screen/User_Management.dart';
import 'package:login_screen/Splash_Screen.dart';
import 'package:login_screen/login_page.dart';

import 'CourseObjectivePage.dart';
import 'Course_Assessment_Page.dart';
import 'PEO_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String ip = 'http://192.168.0.108';

  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      routes: {
        '/Program_Management': (context) => Program_Management(),
        '/PLO': (context) => PLO_Page(),
        '/PEO': (context) => PEO_Page(),
        '/Batch_Management': (context) => BatchPage(),
        '/Course_Page': (context) => Course_Page(),
        '/Approval_Process': (context) => Approval_Process(),
        '/Assessments': (context) => Assessments(),
        '/User_Management': (context) => User_Management(),
        '/University_Page': (context) => University_Page(),
        '/Objective_Page': (context) => CourseObjectivePage(),
        '/CLO_Page': (context) => CLO_Page(),
        '/Course_Assessment_Page': (context) => Course_Assessment_Page(),
        '/Course_Schedule_Profile' : (context) => CourseScheduleProfile(),
        '/Create_Course_Schedule': (context) => CreateCourseSchedule(),
        '/Course_Books': (context) => CourseBookPage(),
      },
    );
  }
}