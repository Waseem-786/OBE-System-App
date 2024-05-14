import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';

class OutlineRow extends StatelessWidget {
  final List<String> texts;
  final bool isHeader;
  final Color backgroundColor;

  const OutlineRow({
    Key? key,
    required this.texts,
    this.isHeader = false,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Border border = isHeader
        ? Border.all(color: Colors.blue.shade900, width: 2) // All sides when header
        : Border(
      left: BorderSide(color: Colors.blue.shade900, width: 2),
      right: BorderSide(color: Colors.blue.shade900, width: 2),
      bottom: BorderSide(color: Colors.blue.shade900, width: 2),
    ); // Omit top border for non-header

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
      ),
      child: IntrinsicHeight(  // Ensures the row takes full height
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the rows vertically
          children: texts.asMap().map((index, text) {
            return MapEntry(index, Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: index < texts.length - 1
                      ? Border(right: BorderSide(color: Colors.blue.shade900, width: 2))
                      : null,  // No right border on the last column
                ),
                alignment: Alignment.centerLeft,  // Align text to the left, centered vertically
                padding: const EdgeInsets.all(8),
                child: Text(
                  text,
                  style: CustomTextStyles.bodyStyle(fontSize: 20),
                ),
              ),
            ));
          }).values.toList(),
        ),
      ),
    );
  }
}
