import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Program_Management extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
return  Scaffold(
  appBar: AppBar(
    backgroundColor: Color(0xffc19a6b),
    title: Center(
      child: Text(
        'Program Management',
        style: CustomTextStyles.headingStyle(fontSize: 20),
      ),
    ),

  ),  body: Center(child: Text("This is Program Management page",style: TextStyle(color: Colors.red),)),
);
  }
  
}