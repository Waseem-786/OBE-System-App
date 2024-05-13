import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double? fontSize;

  const DetailCard({
    Key? key,
    required this.label,
    this.value,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Colors.white,
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for a modern look
      ),
      child: InkWell(
        onTap: () {
          // Optionally define what happens when you tap the card
        },
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1), // Subtle splash effect
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Consistent padding throughout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: iconColor ?? Theme.of(context).primaryColor.withOpacity(0.2), // Lighter background for icon
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor ?? Theme.of(context).primaryColor, size: 24), // Consistent icon size
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize ?? 20,
                        color: textColor ?? Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Spacing between elements
              Text(
                value ?? 'Not provided',
                style: TextStyle(fontSize: 16, color: textColor ?? Colors.black54), // Consistent body text style
              ),
            ],
          ),
        ),
      ),
    );
  }
}
