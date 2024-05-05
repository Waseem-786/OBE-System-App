import 'package:flutter/material.dart';

class UpdateWidget extends StatelessWidget {
  final String title;
  final String content;

  const UpdateWidget({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green,
      title: Row(
        children: [
          Icon(Icons.info, color: Colors.white),
          SizedBox(width: 10),
          Text(title, style: TextStyle(color: Colors.white)),
        ],
      ),
      content: Text(content, style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text("Yes", style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("No", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
