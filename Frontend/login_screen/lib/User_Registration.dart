

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';

import 'Custom_Widgets/Custom_Text_Field.dart';

class User_Registration extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final TextEditingController FirstNameController = TextEditingController();
    final TextEditingController LastNameController = TextEditingController();
    final TextEditingController EmailController = TextEditingController();
    final TextEditingController PasswordController = TextEditingController();
    final TextEditingController ConfirmPasswordController = TextEditingController();

    return Scaffold(

      // resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
        margin: EdgeInsets.only(left: 25),
        child: Text('User Registration',style: TextStyle(fontWeight: FontWeight
            .bold, fontFamily: 'Merri' ),),
      ),),

      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,

        child: ListView(
          children:[
            Container(
              margin:EdgeInsets.only(top: 150) ,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [


                CustomTextFormField(controller: FirstNameController,
                  label: 'First Name',
                  hintText: 'Enter First Name',),

                SizedBox(height: 20,),

                CustomTextFormField(controller: LastNameController,
                  label: 'Last Name',
                  hintText: 'Enter Last Name',),



                SizedBox(height: 20,),

                CustomTextFormField(controller: EmailController,
                  label: 'Email',
                  hintText: 'Enter Email',),

                SizedBox(height: 20,),

                CustomTextFormField(controller: PasswordController,
                  label: 'Password',
                  hintText: 'Enter Password',),

                SizedBox(height: 20,),

                CustomTextFormField(controller: ConfirmPasswordController,

                  label: 'Confirm Password',
                  hintText: 'Enter Password Again',),

                SizedBox(height: 20,),

                Custom_Button(onPressedFunction: (){},
                ButtonText: 'Register',
                )

              ],
            ),
          )],
        ),
      ),


    );
  }


}
