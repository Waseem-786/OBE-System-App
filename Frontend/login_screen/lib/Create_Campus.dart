import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'Campus.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'University.dart';
import 'main.dart';

class Create_Campus extends StatefulWidget {
  @override
  State<Create_Campus> createState() => _Create_CampusState();
}

class _Create_CampusState extends State<Create_Campus> {
  int University_id = University.id;
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

  final TextEditingController CampusNameController = TextEditingController();

  final TextEditingController CampusMissionController = TextEditingController();

  final TextEditingController CampusVisionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextFormField(
                controller: CampusNameController,
                label: 'Campus Name',
                hintText: 'Enter Campus Name',
                borderColor: errorColor,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CampusMissionController,
                label: 'Campus Mission',
                hintText: 'Enter Campus Mission',
                borderColor: errorColor,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: CampusVisionController,
                label: 'Campus Vision',
                hintText: 'Enter Campus Vision',
                borderColor: errorColor,
              ),
              SizedBox(
                height: 20,
              ),
              Custom_Button(
                onPressedFunction: () async {
                  String CampusName = CampusNameController.text;
                  String CampusMission = CampusMissionController.text;
                  String CampusVision = CampusVisionController.text;
                  if (CampusName.isEmpty ||
                      CampusMission.isEmpty ||
                      CampusVision.isEmpty) {
                    setState(() {
                      colorMessage = Colors.red;
                      errorColor = Colors.red;
                      errorMessage = 'Please enter all fields';
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    bool created = await Campus.createCampus(
                        CampusName, CampusMission, CampusVision, University_id);
                    if (created) {
                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorColor =
                            Colors.black12; // Reset errorColor to default value
                        errorMessage = 'Campus Created successfully';
                      });
                    }
                  }
                },
                ButtonText: 'Create Campus',
                ButtonWidth: 200,
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
