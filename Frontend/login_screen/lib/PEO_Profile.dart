
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'PEO.dart';
import 'PLO.dart';

class PEO_Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
          title: Center(
              child: Text('PEO Profile',
                  style: CustomTextStyles.headingStyle(fontSize: 22))),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                height: 600,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title for course details section.
                        Text("PEO Details",
                            style: CustomTextStyles.headingStyle()),
                        const SizedBox(height: 10),

                        // calling of the _buildCLOInfoCards() for every field of clo data that will be stored on the card
                        ..._buildPEOInfoCards(), // Spread operator (...) to
                        // unpack the list of clo info cards into children.
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),

            // Button for delete functionality.
            Padding(
              padding: const EdgeInsets.only(bottom:  20.0),
              child: Custom_Button(
                onPressedFunction: () {
                  // Implement delete functionality.
                },
                BackgroundColor: Colors.red,
                ForegroundColor: Colors.white,
                ButtonText: "Delete",
                ButtonWidth: 120,
              ),
            )
          ],
        ));
  }

  List<Widget> _buildPEOInfoCards() {
    return [
      _buildPEODetailCard("PEO Description", PEO.description),

    ];
  }

  Widget _buildPEODetailCard(String label, String? value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "$label: ${value ?? 'Not provided'}",
            style: CustomTextStyles.bodyStyle(fontSize: 19),
          ),
        ),
      ),
    );
  }
}
