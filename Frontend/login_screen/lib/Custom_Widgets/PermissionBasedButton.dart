import 'package:flutter/material.dart';
import 'Custom_Button.dart';

class PermissionBasedButton extends StatelessWidget {
  final String buttonText;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double buttonWidth;
  final VoidCallback onPressed;
  final Future<bool> permissionFuture;

  const PermissionBasedButton({
    Key? key,
    required this.buttonText,
    this.backgroundColor,
    this.foregroundColor,
    required this.buttonWidth,
    required this.onPressed,
    required this.permissionFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: permissionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          bool hasPermission = snapshot.data ?? false;
          return Visibility(
            visible: hasPermission,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Custom_Button(
                onPressedFunction: onPressed,
                BackgroundColor: backgroundColor,
                ForegroundColor: foregroundColor,
                ButtonText: buttonText,
                ButtonWidth: buttonWidth,
              ),
            ),
          );
        }
      },
    );
  }
}
