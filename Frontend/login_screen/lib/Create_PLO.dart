import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  int departmentId = User.departmentid;
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
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          margin: const EdgeInsets.only(left: 90),
          child: Text(
            "Create PLO",
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
            CustomTextFormField(controller: PLOName_Controller,
              hintText: 'Enter PLO Name',
              label: 'Enter PLO Name',
            ),
             const SizedBox(height: 20,),
            CustomTextFormField(controller: PLODescription_Controller,
              hintText: 'Enter PLO Description',
              label: 'Enter PLO Description',
            ),
            const SizedBox(height: 20,),
            Custom_Button(
              onPressedFunction: () async {
                String PLOName = PLOName_Controller.text;
                String PLODescription = PLODescription_Controller.text;
                if (PLOName.isEmpty || PLODescription.isEmpty) {
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
                    PLOName,PLODescription, departmentId);
                  if (created) {
                    //Clear all the fields
                    PLODescription_Controller.clear();
                    PLOName_Controller.clear();

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
