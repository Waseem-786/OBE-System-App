import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Outline.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Batch_Management extends StatefulWidget{
  @override
  State<Batch_Management> createState() => _Batch_ManagementState();
}

class _Batch_ManagementState extends State<Batch_Management> {
  @override
  void initState() {
    // TODO: implement initState
    // var w = Outline.createOutline(2, 3, 4);
    var a =Outline.fetchOutlineByCourse(4);
    var b =Outline.fetchOutlineByBatch(2);
    var c =Outline.fetchOutlineByTeacher(2);
    var d = Outline.fetchSingleOutline(3);
    
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Batch Management',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),

      ),      body: Center(child: Text("This is Batch Management page",style: TextStyle(color: Colors.red),)),
    );
  }
}