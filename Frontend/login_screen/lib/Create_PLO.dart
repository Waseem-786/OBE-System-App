
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/User.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';
import 'PLO.dart';

class Create_PLO extends StatefulWidget {
  @override
  State<Create_PLO> createState() => _Create_PLOState();
}

class _Create_PLOState extends State<Create_PLO> {
  int departmentid = User.departmentid;
  String?
  errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading =
  false;
  // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12;
  // color of border of text fields when the error is not occurred

  final TextEditingController PLODescription_Controller = TextEditingController();

  final TextEditingController PLOName_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 90),
          child: Text(
            "Create PLO",
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

            CustomTextFormField(controller: PLOName_Controller,
              hintText: 'Enter PLO Name',
              label: 'Enter PLO Name',),
             SizedBox(height: 20,),
            CustomTextFormField(controller: PLODescription_Controller,
              hintText: 'Enter PLO Description',
              label: 'Enter PLO Description',),

            SizedBox(height: 20,),


            Custom_Button(
              onPressedFunction: () async {
                String PLODescription = PLODescription_Controller.text;
                String PLOName = PLOName_Controller.text;
                if (PLODescription.isEmpty || PLOName.isEmpty) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  bool created = await PLO.createPLO(
                    PLOName,PLODescription, departmentid);
                  if (created) {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor =
                          Colors.black12; // Reset errorColor to default value
                      errorMessage = 'PLO Created successfully';
                    });
                  }
                }
              },
              ButtonWidth: 160,
              ButtonText: 'Create PLO',),
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
    );
  }
}
