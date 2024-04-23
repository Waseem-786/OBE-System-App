
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/User.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';
import 'PEO.dart';

class Create_PEO extends StatefulWidget {
  @override
  State<Create_PEO> createState() => _Create_PEOState();
}

class _Create_PEOState extends State<Create_PEO> {
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

  final TextEditingController PEODescription_Controller =
  TextEditingController();

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

            SizedBox(height: 20,),
            CustomTextFormField(controller: PEODescription_Controller,
              hintText: 'Enter PEO Description',
              label: 'Enter PEO Description',),

            SizedBox(height: 20,),


            Custom_Button(
              onPressedFunction: () async {
                String PEODescription = PEODescription_Controller.text;
                if (PEODescription.isEmpty) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  bool created = await PEO.createPEO(PEODescription,
                      departmentid);
                  if (created) {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor =
                          Colors.black12; // Reset errorColor to default value
                      errorMessage = 'PEO Created successfully';
                    });
                  }
                }
              },
              ButtonWidth: 160,
              ButtonText: 'Create PEO',),
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
