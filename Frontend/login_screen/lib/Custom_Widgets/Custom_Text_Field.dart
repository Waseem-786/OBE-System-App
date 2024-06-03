import 'package:flutter/material.dart';
import 'Custom_Text_Style.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? label;
  final String? hintText;
  final Color? borderColor;
  final bool? passField;
  final TextInputType? Keyboard_Type;
  final VoidCallback? onSuffixIconPressed;
  final int? maxLines; // Added maxLines property

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.label,
    this.hintText,
    this.borderColor,
    this.passField,
    this.Keyboard_Type,
    this.onSuffixIconPressed,
    this.maxLines, // Added maxLines parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: passField ?? false,
      maxLines: maxLines ?? 1, // Default to 1 line if maxLines is not provided
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter ${label}';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: Icon(suffixIcon, color: Colors.black),
          onPressed: onSuffixIconPressed,
        )
            : null,
        label: label != null
            ? Text(
          label!,
          style: CustomTextStyles.bodyStyle(),
        )
            : null,
        hintText: hintText ?? 'Enter Email',
        hintStyle: CustomTextStyles.bodyStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: Keyboard_Type,
    );
  }
}
