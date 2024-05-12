import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/University.dart';
import 'package:login_screen/User.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Role.dart';

class Create_Role extends StatefulWidget {
  const Create_Role({super.key});

  @override
  State<Create_Role> createState() => _Create_Role_Page();
}

class _Create_Role_Page extends State<Create_Role> {

  //int departmentid = User.departmentid;

  String?errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors.black12;
  // color of border of text fields when the error is not occurred

  final TextEditingController Role_Controller = TextEditingController();


  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          margin: const EdgeInsets.only(left: 90),
          child: Text(
            "Create Role",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            CustomTextFormField(controller: Role_Controller,
              hintText: 'Enter Role here e.g. Dean',
              label: 'Enter Role',
            ),
            const SizedBox(height: 20,),
            Custom_Button(
              onPressedFunction: () async {
                String RoleName = Role_Controller.text;
                if (RoleName.isEmpty) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });

                  bool created=false;

                  if(User.isSuperUser){
                    created = await Role.createTopLevelRole(RoleName);
                  }
                  else if(User.isUniLevel()){
                    created= await Role.createUniversityLevelRole(RoleName,
                        University.id);
                  }
                  else if(User.iscampusLevel()){
                    created=await Role.createCampusLevelRole(RoleName, Campus.id);
                  }
                  else if(User.isdeptLevel()){
                    created= await Role.createDepartmentLevelRole(RoleName, Department.id);
                  }


                  if (created) {
                    Role_Controller.clear();

                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor =
                          Colors.black12; // Reset errorColor to default value
                      errorMessage = 'Role Created successfully';
                    });
                  }
                }
              },
              ButtonWidth: 160,
              ButtonText: 'Create Role',),
            const SizedBox(height: 20),
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
      ),


    );


  }
}