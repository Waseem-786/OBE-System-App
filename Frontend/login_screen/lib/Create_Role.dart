
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';

class Create_Role extends StatefulWidget {
  const Create_Role({super.key});

  @override
  State<Create_Role> createState() => _Create_Role_Page();
}

class _Create_Role_Page extends State<Create_Role> {

  final TextEditingController RoleController = TextEditingController();
  String Create_success='';


  Future<void> _Create_Role() async{
  {

  String role= RoleController.text;

  print(role);
  print('hi');
  if(role.isNotEmpty){

  String apiUrl = 'http://192.168.0.112:8000/api/role';


  try{

  var response = await http.post(
  Uri.parse(apiUrl),
  body: {'name': role},
  );
  print(response);
  if (response.statusCode == 200) {
    // Role created successfully
    print('Role created successfully');
    // You can add further actions here, such as navigating to another screen
  } else {
    print(response.body);
    // Handle other status codes appropriately
    print('Failed to create role. Status code: ${response.statusCode}');
  }

  }
  catch (e) {
    // Handle any exceptions
    print('Error creating role: $e');
  }
  } else {
    // Handle case where role is empty
    print('Role name cannot be empty');
  }
  }


  }




  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 25),
          child: Text('Create Roles',style: TextStyle(fontWeight: FontWeight
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


                  CustomTextFormField(controller: RoleController,
                    label: 'Enter Role',
                    hintText: 'Enter Role Here',),

                  SizedBox(height: 20,),

                  Custom_Button(onPressedFunction:_Create_Role,
                    ButtonText: 'Create Role',
                  ),

                  SizedBox(height: 20,),

                  Text(Create_success,style: CustomTextStyles.bodyStyle(),)

                ],
              ),
            )],
        ),
      ),


    );


  }
}
