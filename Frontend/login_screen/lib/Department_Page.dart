import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Create_Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Custom_Widgets/Custom_Button.dart';

class Department_Page extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Department Page'),
      ),
      body: Center(
    child: Container(
    child:   Custom_Button(
    onPressedFunction: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Create_Campus()));
    },
    ButtonText: 'Add Department',
    ButtonWidth: 200,
    ),
    ),
    ),
    );
  }
}