import 'package:flutter/material.dart';
import 'package:login_screen/Approval_Process.dart';
import 'package:login_screen/Assessments.dart';
import 'package:login_screen/Batch_Management.dart';
import 'package:login_screen/Campus_Page.dart';
import 'package:login_screen/Course_Page.dart';
import 'package:login_screen/Department_Page.dart';
import 'package:login_screen/Program_Management.dart';
import 'package:login_screen/PLO_Page.dart';
import 'package:login_screen/University_Page.dart';
import 'package:login_screen/User_Management.dart';
import 'package:login_screen/Splash_Screen.dart';
import 'package:login_screen/login_page.dart';

import 'PEO_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String ip = 'http://192.168.0.105';

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
        '/Batch_Management': (context) => Batch_Management(),
        '/Course_Page': (context) => Course_Page(),
        '/Approval_Process': (context) => Approval_Process(),
        '/Assessments': (context) => Assessments(),
        '/User_Management': (context) => User_Management(),
        '/University_Page': (context) => University_Page(),
      },
    );
  }
}
