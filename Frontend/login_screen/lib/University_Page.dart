
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Create_University.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class University_Page extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'University Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),

      ),
      body: Center(
        child: Container(
        child:   Custom_Button(
            onPressedFunction: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Create_University()));
              },
            ButtonText: 'Add University',
          ButtonWidth: 200,
          ),
        ),
      ),
    );
  }
}