
import 'package:flutter/material.dart';

import 'Custom_Text_Style.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? prefixIcon;
  final String? label;
  final String? hintText;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.prefixIcon,
    this.label,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
