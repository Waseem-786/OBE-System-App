import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Dashboard.dart';
import 'Custom_Widgets/Custom_Button.dart';

class LoginPage extends StatelessWidget {
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
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 250),
              width: double.infinity,
              height: 600,
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
                      prefixIcon: Icons.account_circle
                        ,),

                    SizedBox(height: 26.0),

                    CustomTextFormField(controller: PasswordController,
                      label: 'Password',
                      prefixIcon: Icons.lock,
                      hintText: 'Enter Password'

                      ,),

                    SizedBox(height: 40.0),

                    // Forget Password
                    GestureDetector(
                      onTap: () {

                      },

                      child: Text('Forget Password?',
                      style:CustomTextStyles.bodyStyle(fontWeight: FontWeight
                          .bold,color: Color(0xFFc19a6b) )

                        ,),
                    ),


                    SizedBox(height: 15.0),

                    Custom_Button(onPressedFunction: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard_Page()));


                    },
                      ButtonText: 'Login',
                    ),


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
