import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

class Create_Department extends StatelessWidget
{
  final TextEditingController CampusIdController = TextEditingController();
  final TextEditingController DepartmentNameController = TextEditingController();
  final TextEditingController DepartmentMissionController = TextEditingController();
  final TextEditingController DepartmentVisionController = TextEditingController();

  Color errorColor = Colors.black12;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Department Page'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: CampusIdController,
              label: 'Campus Id',
              hintText: 'Enter Campus Id',
              borderColor: errorColor,
            ),
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: DepartmentNameController,
              label: 'Department Name',
              hintText: 'Enter Department Name',
              borderColor: errorColor,
            ),
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: DepartmentMissionController,
              label: 'Department Mission',
              hintText: 'Enter Department Mission',
              borderColor: errorColor,
            ),
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: DepartmentVisionController,
              label: 'Department Vision',
              hintText: 'Enter Department Vision',
              borderColor: errorColor,
            ),
          ],
        ),
      ),
    );
  }
}