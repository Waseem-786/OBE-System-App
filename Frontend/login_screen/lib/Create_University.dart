import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'main.dart';

class Create_University extends StatefulWidget {
  @override
  State<Create_University> createState() => _Create_UniversityState();
}

class _Create_UniversityState extends State<Create_University> {
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

  final TextEditingController UniversityNameController =
      TextEditingController();

  final TextEditingController UniversityMissionController =
      TextEditingController();

  final TextEditingController UniversityVisionController =
      TextEditingController();

  Future<void> createUniversity(
      String token, String name, String mission, String vision) async {
    final ipAddress = MyApp.ip;
    setState(() {
      isLoading = true; // Ensure isLoading is set to true before the request
    });
    final url = Uri.parse('$ipAddress:8000/api/university');
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
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful, handle the response
      setState(() {
        isLoading = false;
        colorMessage = Colors.green;
        errorColor = Colors.black12; // Reset errorColor to default value
        errorMessage = 'University Created successfully';

      });
      print('University Created successful');
    } else {
      print('Failed to create university. Status code: ${response.statusCode}');
      throw Exception('Failed to create university ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'University Page',
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
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: UniversityVisionController,
                label: 'University Vision',
                hintText: 'Enter University Vision',
                borderColor: errorColor,
              ),
              SizedBox(
                height: 20,
              ),
              Custom_Button(
                onPressedFunction: () {
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
                    createUniversity(myToken, UniversityName, UniversityMission,
                        UniversityVision);
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
