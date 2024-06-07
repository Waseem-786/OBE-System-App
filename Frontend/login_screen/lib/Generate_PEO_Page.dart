import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Display_Generated_PEOs.dart';
import 'package:login_screen/PEO.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Generate_PEO_Page extends StatefulWidget {
  @override
  State<Generate_PEO_Page> createState() => _Generate_PEO_PageState();
}

class _Generate_PEO_PageState extends State<Generate_PEO_Page> {
  String? errorMessage; // Variable to show the error message
  Color colorMessage = Colors.red; // Color of the error message
  var isLoading = false; // Variable for loading indicator
  Color errorColor = Colors.black12; // Default color of text fields border
  TextEditingController numberofPEOsController = TextEditingController();
  TextEditingController commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          "Generate PEOs",
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: numberofPEOsController,
              label: 'Number of PEOs',
              hintText: '1,2,3...',
              borderColor: errorColor,
              Keyboard_Type: TextInputType.number,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: commentsController,
              label: 'Comments',
              hintText: 'Please refine it...',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20),
            Custom_Button(
              onPressedFunction: () async {
                int? numOfPEOs;
                try {
                  numOfPEOs = int.parse(numberofPEOsController.text);
                } catch (e) {
                  numOfPEOs = null;
                }
                String comments = commentsController.text;
                if (comments.isEmpty || numOfPEOs == null) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields correctly';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  List<String>? peoStatements = await PEO.Generate_PEOs(numOfPEOs, comments, Department.id);
                  if (peoStatements != null) {
                    numberofPEOsController.clear();
                    commentsController.clear();
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor = Colors.black12; // Reset errorColor to default value
                      errorMessage = 'PEO generated successfully';
                    });
                    // Navigate to the new page to display PEO statements
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Display_Generated_PEOs(peoStatements: peoStatements),
                      ),
                    );
                  } else {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.red;
                      errorMessage = 'Failed to generate PEO';
                    });
                  }
                }
              },
              ButtonWidth: 180,
              ButtonText: 'Generate PEOs',
              BackgroundColor: Color(0xffc19a6b),
              ForegroundColor: Colors.white,
            ),
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