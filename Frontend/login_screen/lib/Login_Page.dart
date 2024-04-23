
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Create_Role.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Dashboard.dart';
import 'package:login_screen/Token.dart';
import 'Custom_Widgets/Custom_Button.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var isLoading = false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors.black12; // color of border of text fields when the error is not occurred
  String? errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty





  void initState(){
    super.initState();
    // _handleTokenVerification();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController EmailController = TextEditingController();
    final TextEditingController PasswordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/bg6.jpg', // Replace with your
            // background image asset
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          // White Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 250),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.all(16.0),
              // margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),

                    Text('Login',
                        style: CustomTextStyles.headingStyle(
                            color: Color(0xFFc19a6b))),

                    SizedBox(
                      height: 70,
                    ),

                    CustomTextFormField(
                      controller: EmailController,
                      label: 'Email',
                      prefixIcon: Icons.account_circle,
                      borderColor: errorColor,
                    ),

                    SizedBox(height: 26.0),

                    CustomTextFormField(
                      controller: PasswordController,
                      label: 'Password',
                      prefixIcon: Icons.lock,
                      hintText: 'Enter Password',
                      borderColor: errorColor,
                      passField: true, // for obscure text of password
                    ),

                    SizedBox(height: 40.0),
                    // Forget Password
                    GestureDetector(
                      onTap: () {

                      },
                      child: Text(
                        'Forget Password?',
                        style: CustomTextStyles.bodyStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFc19a6b)),
                      ),
                    ),

                    SizedBox(height: 15.0),

                    Custom_Button(
                      onPressedFunction: () {
                        String username = EmailController.text;
                        String password = PasswordController.text;

                        setState(() {
                          isLoading = true; // Ensure isLoading is set to true before the request
                        });

                        // function call to get a token by passing username and password to the server to get token
                        Future<String?> message = Token.getToken(username, password) ;
                        message.then((result) {
                          print(result);
                          if (result=="ok") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard_Page()));
                          }
                          else{
                            setState(() {
                              errorMessage = result;
                              errorColor = Colors.red;
                            });
                          }
                        // Use the token for further requests or save it for later use
                        }).catchError((Error) {
                          errorMessage = Error;
                        }).whenComplete(() {
                          setState(() {
                            isLoading = false; // Ensure isLoading is set back to false after request completes
                          });
                        });
                      },
                      ButtonText: 'Login',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: isLoading,
                      child: CircularProgressIndicator(),
                    ),

                    errorMessage != null
                        ? Text(
                      errorMessage!,
                      style: CustomTextStyles.bodyStyle(color: Colors.red),
                    )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
