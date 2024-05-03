
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class CourseBookProfile extends StatefulWidget {
  const CourseBookProfile({super.key});

  @override
  State<CourseBookProfile> createState() => _CourseBookProfileState();
}

class _CourseBookProfileState extends State<CourseBookProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
            child: Text('Course Book Profile',
                style: CustomTextStyles.headingStyle(fontSize: 22))),
      ),

    );
  }
}
