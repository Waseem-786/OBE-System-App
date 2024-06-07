import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Display_Generated_PEOs extends StatefulWidget {
  final List<String> peoStatements;

  Display_Generated_PEOs({required this.peoStatements});

  @override
  State<Display_Generated_PEOs> createState() => _Display_Generated_PEOsState();
}

class _Display_Generated_PEOsState extends State<Display_Generated_PEOs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          "Generated PEOs",
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: widget.peoStatements.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.peoStatements[index],
                  style: CustomTextStyles.bodyStyle(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
