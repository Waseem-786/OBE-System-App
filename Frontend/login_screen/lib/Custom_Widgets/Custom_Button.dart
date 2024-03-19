
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';

class Custom_Button extends StatelessWidget{

 final Color? ForegroundColor ;
 final Color? BackgroundColor ;
 final String? ButtonText;
 final VoidCallback onPressedFunction;


 const Custom_Button({
   Key? key,
   this.ForegroundColor,
   this.BackgroundColor,
   this.ButtonText,
   required this.onPressedFunction
 }):super(key: key);



  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressedFunction,
        style: ElevatedButton.styleFrom(
          backgroundColor: BackgroundColor ?? Color(0xFFc19a6b),
          foregroundColor: ForegroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Border radius
          ),
        ),
        child: Text('$ButtonText', style: CustomTextStyles.bodyStyle
          (fontSize: 18,color: Colors.white)
        ),
      ),
    );
  }}
