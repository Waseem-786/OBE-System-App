import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';

class Custom_Button extends StatelessWidget {
  final Color? ForegroundColor;
  final Color? BackgroundColor;
  final String? ButtonText;
  final VoidCallback onPressedFunction;
  final double ButtonWidth;
  final double ButtonHeight;
  final IconData? ButtonIcon;

  const Custom_Button({
    Key? key,
    this.ForegroundColor,
    this.BackgroundColor,
    this.ButtonText,
    this.ButtonIcon,
    required this.onPressedFunction,
    this.ButtonWidth = double.infinity,
    this.ButtonHeight = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ButtonHeight,
      width: ButtonWidth,
      child: ElevatedButton(
        onPressed: onPressedFunction,
        style: ElevatedButton.styleFrom(
          backgroundColor: BackgroundColor ?? Color(0xFFc19a6b),
          foregroundColor: ForegroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Border radius
          ),
        ),
        child: ButtonIcon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ButtonIcon,
              color: ForegroundColor ?? Colors.white,
            ),
            SizedBox(width: 8), // spacing between icon and text
            Flexible(
              child: Text(
                '$ButtonText',
                style: CustomTextStyles.bodyStyle(
                  fontSize: 18,
                  color: ForegroundColor ?? Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
            : Text(
          '$ButtonText',
          style: CustomTextStyles.bodyStyle(
            fontSize: 18,
            color: ForegroundColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
