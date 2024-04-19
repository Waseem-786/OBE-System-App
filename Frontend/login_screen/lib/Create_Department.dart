import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'main.dart';

class Create_Department extends StatefulWidget
{
  @override
  State<Create_Department> createState() => _Create_DepartmentState();
}

class _Create_DepartmentState extends State<Create_Department> {
  final int campus_id = Campus.id;
  var myToken;
  String?
  errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
  false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred

  // for Encryption purpose
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  @override
  void initState() {
    storage.read(key: "access_token").then((accessToken) {
      // show the users of that person(authority) who is logged in
      myToken = accessToken;
    });
  }
  final TextEditingController DepartmentNameController = TextEditingController();

  final TextEditingController DepartmentMissionController = TextEditingController();

  final TextEditingController DepartmentVisionController = TextEditingController();

  Future<void> createDepartment(
      String token, String name, String mission, String vision) async {
    final ipAddress = MyApp.ip;
    setState(() {
      isLoading = true; // Ensure isLoading is set to true before the request
    });
    final url = Uri.parse('$ipAddress:8000/api/department');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'mission': mission,
        'vision': vision,
        'campus' : campus_id,
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful, handle the response
      setState(() {
        isLoading = false;
        colorMessage = Colors.green;
        errorColor = Colors.black12; // Reset errorColor to default value
        errorMessage = 'Department Created successfully';

      });
      print('Department Created successful');
    } else {
      print('Failed to create Department. Status code: ${response.statusCode}');
      throw Exception('Failed to create Department ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Department Page'),
        backgroundColor: Color(0xffc19a6b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              SizedBox(height: 20,),
              Custom_Button(
                onPressedFunction: () {
                  String DepartmentName = DepartmentNameController.text;
                  String DepartmentMission = DepartmentMissionController.text;
                  String DepartmentVision = DepartmentVisionController.text;
                  if (DepartmentName.isEmpty ||
                      DepartmentMission.isEmpty ||
                      DepartmentVision.isEmpty) {
                    setState(() {
                      colorMessage = Colors.red;
                      errorColor = Colors.red;
                      errorMessage = 'Please enter all fields';

                    });
                  } else {
                    createDepartment(myToken, DepartmentName, DepartmentMission,
                        DepartmentVision);
                  }
                },
                ButtonText: 'Create Department',
                ButtonWidth: 220,
              ),
              SizedBox(height: 20),
              Visibility(
                visible: isLoading,
                child: CircularProgressIndicator(),
              ),
              errorMessage != null
                  ? Text(
                errorMessage!,
                style: CustomTextStyles.bodyStyle(color: colorMessage),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}