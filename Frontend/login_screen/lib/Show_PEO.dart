import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Show_PEO extends StatelessWidget {

  final List<String> PEO_Numbers = [
    "PEO-1",
    "PEO-2",
    "PEO-3",
    "PEO-4",
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
            "PEO's",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: PEO_Numbers.length,
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
                  PEO_Numbers[index],
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
