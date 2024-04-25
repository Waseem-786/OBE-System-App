import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Create_CLO extends StatefulWidget {
  @override
  State<Create_CLO> createState() => _Create_CLOState();
}

class _Create_CLOState extends State<Create_CLO> {
  int Course_id = Course.id;
  String?
  errorMessage;
 //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
 // color of the message when the error occurs
  var isLoading =
  false;
 // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12;
 // color of border of text fields when the error is not occurred

  final TextEditingController CLODescription_Controller = TextEditingController();
  String? SelectedBloomTaxonomy;
  int? SelectedBTLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          margin: const EdgeInsets.only(left: 90),
          child: Text(
            "Create CLO",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(controller: CLODescription_Controller,
              hintText: 'Enter CLO Description',
              label: 'Enter CLO Description',),
            const SizedBox(height: 20,),
            DropdownButtonFormField<String>(
              value: SelectedBloomTaxonomy,
              onChanged: (value) {
                setState(() {
                  SelectedBloomTaxonomy = value as String;
                });
              },
              decoration: InputDecoration(
                labelText: 'Bloom Taxonomy',
                hintText: 'Select Bloom Taxonomy',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border
                    // color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor),
                ),
              ),
              items: ['Cognitive', 'Affective', 'Psychomotor'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20,),
            DropdownButtonFormField<int>(
              value: SelectedBTLevel,
              onChanged: (value) {
                setState(() {
                  SelectedBTLevel = value as int;
                });
              },
              decoration: InputDecoration(
                labelText: 'BT Level',
                hintText: 'Select T Level',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border
                    // color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor),
                ),
              ),
              items: [1, 2, 3, 4, 5, 6, 7].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
            const SizedBox(height: 20,),
            Custom_Button(
              onPressedFunction: () async {
                String CLODescription = CLODescription_Controller.text;
                String? BT = SelectedBloomTaxonomy;
                int?  BTLevel = SelectedBTLevel;
                if (CLODescription.isEmpty ||
                    BT == null ||
                    BTLevel == null) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  bool created = await CLO.createCLO(
                      CLODescription, BT, BTLevel, Course_id );
                  if (created) {
                    //
                    CLODescription_Controller.clear();
                    SelectedBloomTaxonomy = null;
                    SelectedBTLevel = null;

                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor =
                          Colors.black12; // Reset errorColor to default value
                      errorMessage = 'CLO Created successfully';
                    });
                  }
                }
              },
              ButtonWidth: 160,
              ButtonText: 'Create CLO',),
            const SizedBox(height: 20),
            Visibility(
              visible: isLoading,
              child: const CircularProgressIndicator(),
            ),
            errorMessage != null
                ? Text(
              errorMessage!,
              style: CustomTextStyles.bodyStyle(color: colorMessage),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
