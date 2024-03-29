
import 'package:flutter/material.dart';

import 'Custom_Text_Style.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final String? label;
  final String? hintText;
  final Color? borderColor;
  final bool? passField;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.prefixIcon,
    this.label,
    this.hintText,
    this.borderColor,
    this.passField

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: passField ?? false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter ${label}';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        label: label != null
            ? Text(
          label!,
          style: CustomTextStyles.bodyStyle()
        )
            : null,
        hintText: hintText ?? 'Enter Email',
        hintStyle: CustomTextStyles.bodyStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color:  borderColor ??   Colors.black12, // Default border
            // color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor??  Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
