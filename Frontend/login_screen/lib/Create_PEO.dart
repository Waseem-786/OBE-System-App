


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Create_PEO extends StatelessWidget {

  final TextEditingController PEO_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 90),
          child: Text(
            "Create PEO",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(controller: PEO_Controller,
              hintText: 'Enter PEO Description',
              label: 'Enter PEO Description',),
            SizedBox(height: 20,),
            Custom_Button(onPressedFunction: (){},ButtonWidth: 160,
              ButtonText: 'Create PEO',)
          ],
        ),
      ),
    );
  }
}
