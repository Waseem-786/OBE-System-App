import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';
class Create_Campus extends StatelessWidget{

  final TextEditingController UniversityIdController = TextEditingController();
  final TextEditingController CampusNameController = TextEditingController();
  final TextEditingController CampusMissionController = TextEditingController();
  final TextEditingController CampusVisionController = TextEditingController();

  Color errorColor = Colors.black12;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Campus Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),

      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: UniversityIdController,
              label: 'University Id',
              hintText: 'Enter University Id',
              borderColor: errorColor,
            ),
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: CampusNameController,
              label: 'Campus Name',
              hintText: 'Enter Campus Name',
              borderColor: errorColor,
            ),
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: CampusMissionController,
              label: 'Campus Mission',
              hintText: 'Enter Campus Mission',
              borderColor: errorColor,
            ),
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: CampusVisionController,
              label: 'Campus Vision',
              hintText: 'Enter Campus Vision',
              borderColor: errorColor,
            ),
          ],
        ),
      ),
    );
  }
}