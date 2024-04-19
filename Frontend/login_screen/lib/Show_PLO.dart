import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Show_PLO extends StatelessWidget {

  final List<String> PLO_Numbers = [
    "PLO-1",
    "PLO-2",
    "PLO-3",
    "PLO-4",
    "PLO-5",
    "PLO-6",
    "PLO-7",
    "PLO-8",
    "PLO-9",
    "PLO-10",
    "PLO-11",
    "PLO-12",
    // Add more PLOs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 90),
          child: Text(
            "PLO's",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: PLO_Numbers.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFFECECEC),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  PLO_Numbers[index],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.info,
                  color: Colors.green,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
