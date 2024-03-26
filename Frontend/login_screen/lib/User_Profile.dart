import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class User_Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'User Management',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text("User Details",style: CustomTextStyles.headingStyle(),),
             SizedBox(height: 10,),
             SizedBox(
               width: double.infinity,
               height: 90,
               child: Card(
                 color: Colors.white,
                 elevation: 5,
                 margin: EdgeInsets.all(10),
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Text(
                     "First Name: Hashir",
                     style: CustomTextStyles.bodyStyle(fontSize: 21),
                   ),
                 ),
               ),
             ),
             SizedBox(
               width: double.infinity,
               height: 90,
               child: Card(
                 color: Colors.white,
                 elevation: 5,
                 margin: EdgeInsets.all(10),
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Text(
                     "Last Name: Iqbal",
                     style: CustomTextStyles.bodyStyle(fontSize: 21),
                   ),
                 ),
               ),
             ),
             SizedBox(
               width: double.infinity,
               height: 90,
               child: Card(
                 color: Colors.white,
                 elevation: 5,
                 margin: EdgeInsets.all(10),
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Text(
                     "University: NUST",
                     style: CustomTextStyles.bodyStyle(fontSize: 21),
                   ),
                 ),
               ),
             ),
             SizedBox(
               width: double.infinity,
               height: 90,
               child: Card(
                 color: Colors.white,
                 elevation: 5,
                 margin: EdgeInsets.all(10),
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Text(
                     "Campus: MCS",
                     style: CustomTextStyles.bodyStyle(fontSize: 21),
                   ),
                 ),
               ),
             ),
             SizedBox(
               width: double.infinity,
               height: 90,
               child: Card(
                 color: Colors.white,
                 elevation: 5,
                 margin: EdgeInsets.all(10),
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Text(
                     "Username: 123",
                     style: CustomTextStyles.bodyStyle(fontSize: 21),
                   ),
                 ),
               ),
             ),
             SizedBox(
               width: double.infinity,
               height: 90,
               child: Card(
                 color: Colors.white,
                 elevation: 5,
                 margin: EdgeInsets.all(10),
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Text(
                     "Email: hasir4825@gmail.com",
                     style: CustomTextStyles.bodyStyle(fontSize: 18),
                   ),
                 ),
               ),
             ),
             SizedBox(height: 20,),
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: Custom_Button(onPressedFunction: (){

               },BackgroundColor: Colors.red,ForegroundColor: Colors.white,ButtonText: "Delete",ButtonWidth: 120,),
             )
           ],
         ),
        ),
      ),
    );
  }
}
