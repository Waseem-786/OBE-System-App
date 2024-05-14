import 'package:flutter/material.dart';

import 'Custom_Text_Style.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade900, width: 2),
      ),
      child: Text(
        title,
        style: CustomTextStyles.headingStyle(fontSize: 25, color: Colors.blue.shade900),
      ),
    );
  }
}
