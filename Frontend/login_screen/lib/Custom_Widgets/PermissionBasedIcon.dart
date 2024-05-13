import 'package:flutter/material.dart';

class PermissionBasedIcon extends StatelessWidget {
  final IconData iconData;
  final Color enabledColor;
  final Color disabledColor;
  final Future<bool> permissionFuture;
  final VoidCallback onPressed; // Optional onTap callback

  const PermissionBasedIcon({
    Key? key,
    required this.iconData,
    required this.enabledColor,
    required this.disabledColor,
    required this.permissionFuture,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: permissionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Icon(iconData, color: Colors.grey); // Default to grey for error
        } else {
          bool hasPermission = snapshot.data ?? false;
          return InkWell(
            onTap: hasPermission ? onPressed : null, // Disable onTap when no permission
            child: Icon(
              iconData,
              color: hasPermission ? enabledColor : disabledColor,
              size: 35,
            ),
          );
        }
      },
    );
  }
}
