
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Create_Role.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Dashboard.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var loggedin;

  // For encryption of tokens
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  void initState() {
    super.initState();

    // when the app iniatializes. it checks the tokens, if it is stored then
    // it directly ,moves to the dashboard instead of login screen
    storage.read(key: "access_token").then((accessToken) {
      print("access token is $accessToken");
      loggedin = accessToken;
      if (loggedin != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard_Page()));
      }
    });
    storage.read(key: "refresh_token").then((refreshToken) {
      print("refresh token is $refreshToken");
    });
  }

  // function to store tokens when login is performed
  Future<void> storeTokens(Map<String, dynamic> tokens) async {
    await storage.write(key: "access_token", value: tokens['access']);
    await storage.write(key: "refresh_token", value: tokens['refresh']);
  }

  //variable to show the error when the wrong credentials are entered or the
  // fields are empty
  String? errorMessage;

  // color of text fields when the error is not occurred
  Color errorColor = Colors.black12;

  // function to post the request to the server to get tokens by passing
  // username and password
  Future<String?> getToken(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.112:8000/auth/jwt/create'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);

      // function call to store tokens
      await storeTokens(responseData);
    } else {
      setState(() {
        if (username == '' && password == '') {
          errorColor = Colors.red;
          errorMessage = 'Please Enter Credentials';
        } else {
          errorMessage = '*Incorrect Username & Password';
          errorColor = Colors.red;
        }
      });
      throw Exception('Failed to load token');
    }
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
                      passField: true,
                    ),

                    SizedBox(height: 40.0),
                    // Forget Password
                    GestureDetector(
                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Create_Role()));

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

                        getToken(username, password).then((token) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard_Page()));
                          print('Token: $token');
                          // Use the token for further requests or save it for later use
                        }).catchError((error) {
                          print('Error: $error');
                        });
                      },
                      ButtonText: 'Login',
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    errorMessage != null
                        ? Text(
                            errorMessage!,
                            style:
                                CustomTextStyles.bodyStyle(color: Colors.red),
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
