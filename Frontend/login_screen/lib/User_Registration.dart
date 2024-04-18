import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/main.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DropDown.dart';

class User_Registration extends StatefulWidget {
  @override
  State<User_Registration> createState() => _User_RegistrationState();
}

class _User_RegistrationState extends State<User_Registration> {
  String?
  errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
  false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred

  final TextEditingController FirstNameController = TextEditingController();
  final TextEditingController LastNameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final TextEditingController ConfirmPasswordController =
  TextEditingController();
  final TextEditingController UserName = TextEditingController();
  final TextEditingController Campus = TextEditingController();
  final TextEditingController Role = TextEditingController();
  final TextEditingController Department = TextEditingController();

  late String token;

  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    storage.read(key: "access_token").then((accessToken) {
      setState(() {
        token = accessToken!;
      });
    });
  }

  // function to send the post request to the server to create a user by passing user fields
  Future<void> registerUser(String firstName, String lastName, String email,
      String password, String confirmPassword, String userName) async {

    final ipAddress = MyApp.ip;
    setState(() {
      isLoading = true; // Ensure isLoading is set to true before the request
    });

    // Create a map containing the user registration data
    Map<String, String> userData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      're_password': confirmPassword,
      'username': userName,
    };

    // Convert the map to a JSON string
    String requestBody = jsonEncode(userData);

    // Send the POST request
    try {
      http.Response response = await http.post(
        Uri.parse('$ipAddress:8000/auth/users/'),
        body: requestBody,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // Registration successful, handle the response
        setState(() {
          colorMessage = Colors.green;
          errorMessage = 'Registration successful';
        });
        print('Registration successful');
        // You can navigate to another screen or show a success message here
      } else {
        setState(() {
          if (firstName == '' &&
              lastName == '' &&
              email == '' &&
              password == '' &&
              confirmPassword == '' &&
              userName == '') {
            errorColor = Colors.red;
            errorMessage = 'Please Enter all Fields';
          }
        });
        throw Exception('Failed create user ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error sending request to server: $e');
      setState(() {
        errorColor = Colors.red;
        errorMessage =
        'Failed to connect to the server. Please try again later.$e';
      });
    } finally {
      setState(() {
        isLoading =
        false; // Ensure isLoading is set back to false after request completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ipAddress = MyApp.ip;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 25),
          child: Text(
            'User Registration',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Merri'),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 70),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormField(
                      controller: FirstNameController,
                      label: 'First Name',
                      hintText: 'Enter First Name',
                      borderColor: errorColor),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: LastNameController,
                    label: 'Last Name',
                    hintText: 'Enter Last Name',
                    borderColor: errorColor,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: EmailController,
                    label: 'Email',
                    hintText: 'Enter Email',
                    borderColor: errorColor,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: PasswordController,
                    label: 'Password',
                    hintText: 'Enter Password',
                    borderColor: errorColor,
                    passField: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: ConfirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'Enter Password Again',
                    borderColor: errorColor,
                    passField: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: UserName,
                    label: 'User Name',
                    hintText: 'Enter Username',
                    borderColor: errorColor,
                  ),
                  SizedBox(height: 20),
                  DropDown(
                    token: token,
                    endpoint: '$ipAddress:8000/api/university',
                    hintText: "Select University",
                    label: "University",
                  ),
                  SizedBox(height: 20),
                  DropDown(
                    token: token,
                    endpoint: '$ipAddress:8000/api/campus',
                    hintText: "Select Campus",
                    label: "Campus",
                  ),
                  SizedBox(height: 20),
                  DropDown(
                    token: token,
                    endpoint: '$ipAddress:8000/api/department',
                    hintText: "Select department",
                    label: "department",
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: Role,
                    label: 'User Role',
                    hintText: 'Enter Role',
                    borderColor: errorColor,
                  ),
                  SizedBox(height: 20),
                  Custom_Button(
                    onPressedFunction: () {
                      String firstName = FirstNameController.text;
                      String lastName = LastNameController.text;
                      String email = EmailController.text;
                      String password = PasswordController.text;
                      String confirmPassword = ConfirmPasswordController.text;
                      String userName = UserName.text;

                      // calling of function to create user by pressing button
                      registerUser(firstName, lastName, email, password,
                          confirmPassword, userName);
                    },
                    ButtonText: 'Register',
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: isLoading,
                    child: CircularProgressIndicator(),
                  ),
                  errorMessage != null
                      ? Text(
                    errorMessage!,
                    style:
                    CustomTextStyles.bodyStyle(color: colorMessage),
                  )
                      : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
