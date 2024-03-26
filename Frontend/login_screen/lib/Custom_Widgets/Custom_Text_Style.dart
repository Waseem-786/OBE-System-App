import 'package:flutter/material.dart';

class CustomTextStyles {
  static TextStyle headingStyle({double? fontSize, Color? color, FontWeight? fontWeight,}) {
    return TextStyle(
      fontSize: fontSize ?? 30,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Colors.black,
      fontFamily: 'Merri'
    );
  }

  static TextStyle bodyStyle({double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.black,
      fontFamily: 'Merri'
    );
  }
}
