import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  String? errorMessage;
  Color errorColor = Colors.black12;

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
      return responseData['access'];
    } else {

      setState(() {

        if(username=='' && password==''){
          errorColor=Colors.red;
          errorMessage='Please Enter Credentials';
        }
        else{

          errorMessage = '*Incorrect Username & Password';
          errorColor=Colors.red;

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
              height: MediaQuery.of(context).size.height*0.7,
              padding: EdgeInsets.all(16.0),
              // margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                   SizedBox(height: 50,),

                    Text(
                      'Login',
                      style: CustomTextStyles.headingStyle(color: Color(0xFFc19a6b))),

                    SizedBox(height: 70,),

                    CustomTextFormField(controller: EmailController,
                      label: 'Email',
                      prefixIcon: Icons.account_circle,
                        borderColor: errorColor,
                        ),

                    SizedBox(height: 26.0),

                    CustomTextFormField(controller: PasswordController,
                      label: 'Password',
                      prefixIcon: Icons.lock,
                      hintText: 'Enter Password',
                      borderColor: errorColor,

                      ),

                    SizedBox(height: 40.0),


                    // Error message for wrong credentials


                    // Forget Password
                    GestureDetector(
                      onTap: () {

                      },

                      child: Text('Forget Password?',
                      style:CustomTextStyles.bodyStyle(
                          fontSize: 14,
                          fontWeight: FontWeight
                          .bold,color: Color(0xFFc19a6b) )

                        ,),
                    ),


                    SizedBox(height: 15.0),

                    Custom_Button(onPressedFunction: (){


                      String username = EmailController.text;
                      String password = PasswordController.text;

                      getToken(username, password).then((token) {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard_Page()));
                        print('Token: $token');
                        // Use the token for further requests or save it for later use
                      }).catchError((error) {
                        print('Error: $error');
                      });


                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard_Page()));


                    },
                      ButtonText: 'Login',
                    ),

                    SizedBox(height: 10,),


                    errorMessage != null
                        ?

                    Text(
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
