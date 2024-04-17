
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
class Create_University extends StatelessWidget
{
  final TextEditingController UniversityNameController = TextEditingController();
  final TextEditingController UniversityMissionController = TextEditingController();
  final TextEditingController UniversityVisionController = TextEditingController();

  Color errorColor = Colors.black12;

  @override
  Widget build(BuildContext context){
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
      body: Container(
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
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: UniversityMissionController,
              label: 'University Mission',
              hintText: 'Enter University Mission',
              borderColor: errorColor,
            ),
            SizedBox(height: 20,),
            CustomTextFormField(
              controller: UniversityVisionController,
              label: 'University Vision',
              hintText: 'Enter University Vision',
              borderColor: errorColor,
            ),
            SizedBox(height: 20,),
            Custom_Button(
              onPressedFunction: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Create_University()));
              },
              ButtonText: 'Create University',
              ButtonWidth: 200,
            ),
          ],
        ),
      ),
    );
  }

}