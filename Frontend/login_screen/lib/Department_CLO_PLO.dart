import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'PEO_Page.dart';
import 'PLO_Page.dart';

class Department_CLO_PLO extends StatelessWidget {
  const Department_CLO_PLO({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
          title: Container(
            margin: const EdgeInsets.only(left: 30),
            child: Text(
              'Program Management',
              style: CustomTextStyles.headingStyle(fontSize: 20),
            ),
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PLO_Page()));
                  },
                  ButtonText: "Show PLO's ",
                  ButtonWidth: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PEO_Page()));
                  },
                  ButtonText: "Show PEOs",
                  ButtonWidth: 200,
                ),
              ],
            ),
          ),
        ));

  }
}
