import 'package:flutter/material.dart';
import 'package:login_screen/Add_Group_Permission.dart';
import 'package:login_screen/Approval_Process.dart';
import 'package:login_screen/Assessments.dart';
import 'package:login_screen/BatchPage.dart';
import 'package:login_screen/CLO_Page.dart';
import 'package:login_screen/Campus_Page.dart';
import 'package:login_screen/Campus_Select.dart';
import 'package:login_screen/CourseBookPage.dart';
import 'package:login_screen/Course_Outline_Page.dart';
import 'package:login_screen/Course_Outline_Profile.dart';
import 'package:login_screen/Course_Schedule_Profile.dart';
import 'package:login_screen/Course_Page.dart';
import 'package:login_screen/Create_Course_Schedule.dart';
import 'package:login_screen/Department_Page.dart';
import 'package:login_screen/Group_Permissions.dart';
import 'package:login_screen/Group_Users.dart';
import 'package:login_screen/Program_Management.dart';
import 'package:login_screen/PLO_Page.dart';
import 'package:login_screen/Role_Page.dart';
import 'package:login_screen/University_Page.dart';
import 'package:login_screen/University_Select.dart';
import 'package:login_screen/User_Management.dart';
import 'package:login_screen/Splash_Screen.dart';
import 'package:login_screen/Weekly_Topics_Page.dart';
import 'Add_Group_User.dart';
import 'Assessment_Page.dart';
import 'CourseObjectivePage.dart';
import 'Course_Assessment_Page.dart';
import 'PEO_Page.dart';
import 'Show_CLO_PLO_Mapping.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String ip = 'http://192.168.0.111';

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
        '/PLO_Page': (context) => PLO_Page(),
        '/PEO_Page': (context) => PEO_Page(),
        '/Batch_Management': (context) => BatchPage(),
        '/Course_Page': (context) => Course_Page(),
        '/Approval_Process': (context) => Approval_Process(),
        '/Assessments': (context) => Assessments(),
        '/User_Management': (context) => User_Management(),
        '/University_Page': (context) => University_Page(),
        '/Campus_Page': (context) => Campus_Page(),
        '/Department_Page': (context) => Department_Page(),
        '/Objective_Page': (context) => CourseObjectivePage(),
        '/CLO_Page': (context) => CLO_Page(),
        '/Course_Assessment_Page': (context) => Course_Assessment_Page(),
        '/Course_Schedule_Profile' : (context) => CourseScheduleProfile(),
        '/Create_Course_Schedule': (context) => CreateCourseSchedule(),
        '/Course_Books': (context) => CourseBookPage(),
        '/Show_CLO_PLO_Mapping': (context) => Show_CLO_PLO_Mapping(),
        '/Weekly_Topics_Page' : (context) => WeeklyTopicsPage(),
        '/Role Page' : (context) => Role_Page(),
        '/Course_Outline_Profile' : (context) => CourseOutlineProfile(),
        '/University_Select' : (context) => University_Select(),
        '/Campus_Select' : (context) => Campus_Select(),
        '/Course_Outline_Page' : (context) => Course_Outline_Page(),
        '/Assessment_Page' : (context) => Assessment_Page(),
        '/Group Users Page' : (context) => Group_Users(),
        '/Group Permissions Page' : (context) => Group_Permissions(),
        '/Add Group Users' : (context) => Add_Group_User(),
        '/Add Group Permissions' : (context) => Add_Group_Permissions(),

      },
    );
  }
}