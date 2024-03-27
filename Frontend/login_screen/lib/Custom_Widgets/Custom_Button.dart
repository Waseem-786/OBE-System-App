
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';

class Custom_Button extends StatelessWidget{

 final Color? ForegroundColor ;
 final Color? BackgroundColor ;
 final String? ButtonText;
 final VoidCallback onPressedFunction;
 final double ButtonWidth;


 const Custom_Button({
   Key? key,
   this.ForegroundColor,
   this.BackgroundColor,
   this.ButtonText,
   required this.onPressedFunction,
   this.ButtonWidth = double.infinity,
 }):super(key: key);



  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width : ButtonWidth,
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
