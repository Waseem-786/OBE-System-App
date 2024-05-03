

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CourseDashboard.dart';
import 'package:login_screen/CourseObjective.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';

class CreateCourseObjective extends StatefulWidget {

  @override
  State<CreateCourseObjective> createState() => _CreateObjectiveState();
}

class _CreateObjectiveState extends State<CreateCourseObjective> {

  String? errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors.black12;
  // color of border of text fields when the error is not occurred

  final TextEditingController ObjectiveController = TextEditingController();



  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 25),
          child: Text('Create Objective',style: TextStyle(fontWeight: FontWeight
              .bold, fontFamily: 'Merri' ),),
        ),),

      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,

        child: ListView(
          children:[
            Container(
              margin:EdgeInsets.only(top: 250) ,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [


                  CustomTextFormField(controller: ObjectiveController,
                    label: 'Enter Objective',
                    hintText: 'Enter Objective Here',),

                  SizedBox(height: 20,),

                  Custom_Button(
                    onPressedFunction: () async {
                      List<String> objectiveDescription = ObjectiveController.text.split(',');
                      if (objectiveDescription.isEmpty || objectiveDescription.any((element) => element.isEmpty)) {
                        setState(() {
                          colorMessage = Colors.red;
                          errorColor = Colors.red;
                          errorMessage = 'Please enter all fields';
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        bool created = await CourseObjective.createCourseObjective(objectiveDescription, 4);
                        if (created) {
                          ObjectiveController.clear();
                          setState(() {
                            isLoading = false;
                            colorMessage = Colors.green;
                            errorColor = Colors.black12;
                            errorMessage = 'Objective Created successfully';
                          });
                        }
                      }
                    },
                    ButtonText: 'Create Objective',
                  ),



                  SizedBox(height: 20,),

                  Visibility(
                    visible: isLoading,
                    child: const CircularProgressIndicator(),
                  ),
                  errorMessage != null
                      ? Text(
                    errorMessage!,
                    style: CustomTextStyles.bodyStyle(color: colorMessage),
                  )
                      : const SizedBox(),




                ],
              ),
            )],
        ),
      ),


    );


  }
}
