import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/University.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Create_University extends StatefulWidget {
  @override
  State<Create_University> createState() => _Create_UniversityState();
}

class _Create_UniversityState extends State<Create_University> {
  String?
      errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
      false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred

  final TextEditingController UniversityNameController =
      TextEditingController();

  final TextEditingController UniversityMissionController =
      TextEditingController();

  final TextEditingController UniversityVisionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Create University',
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
                controller: UniversityNameController,
                label: 'University Name',
                hintText: 'Enter University Name',
                borderColor: errorColor,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: UniversityMissionController,
                label: 'University Mission',
                hintText: 'Enter University Mission',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: UniversityVisionController,
                label: 'University Vision',
                hintText: 'Enter University Vision',
                borderColor: errorColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Custom_Button(
                onPressedFunction: () async {
                  String UniversityName = UniversityNameController.text;
                  String UniversityMission = UniversityMissionController.text;
                  String UniversityVision = UniversityVisionController.text;
                  if (UniversityName.isEmpty ||
                      UniversityMission.isEmpty ||
                      UniversityVision.isEmpty) {
                    setState(() {
                      colorMessage = Colors.red;
                      errorColor = Colors.red;
                      errorMessage = 'Please enter all fields';
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    bool created = await University.createUniversity(
                        UniversityName, UniversityMission, UniversityVision);
                    if (created) {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor =
                          Colors.black12; // Reset errorColor to default value
                      errorMessage = 'University Created successfully';
                    });
                    }
                  }
                },
                ButtonText: 'Create University',
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
