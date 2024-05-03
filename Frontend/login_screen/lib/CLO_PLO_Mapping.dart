import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Custom_Widgets/DropDown.dart';

import 'Course.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'PLO.dart';

class CLO_PLO_Mapping extends StatefulWidget {
  @override
  State<CLO_PLO_Mapping> createState() => _CLO_PLO_MappingState();
}

class _CLO_PLO_MappingState extends State<CLO_PLO_Mapping> {
  String? errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors.black12;
  // color of border of text fields when the error is not occurred
  dynamic selectedCLOId;
  TextEditingController CLOController = TextEditingController();
  dynamic selectedPLOId;
  TextEditingController PLOController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('CLO PLO Mapping Page',
            style: CustomTextStyles.headingStyle(fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropDown(
                  controller: CLOController,
                  fetchData: () => CLO.fetchCLO(Course.id),
                  hintText: "Select CLO",
                  label: "CLO",
                  selectedValue: selectedCLOId,
                  keyName: "description",
                  onValueChanged: (dynamic id) {
                    setState(() {
                      selectedCLOId = id;
                    });
                  }),
              SizedBox(
                height: 20,
              ),
              DropDown(
                  controller: PLOController,
                  fetchData: () => PLO.fetchPLO(),
                  hintText: "Select PLO",
                  label: "PLO",
                  selectedValue: selectedPLOId,
                  onValueChanged: (dynamic id) {
                    setState(() {
                      selectedPLOId = id;
                    });
                  }),
              SizedBox(
                height: 20,
              ),
              Custom_Button(
                onPressedFunction: () async {
                  setState(() {
                    isLoading = true;
                  });
                  bool created =
                  await CLO.mapCLOwithPLO(selectedCLOId, selectedPLOId);
                  if (created) {
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor =
                          Colors.black12; // Reset errorColor to default value
                      errorMessage = 'CLO Mapped to PLO successfully';
                    });
                  }
                },
                ButtonText: 'Map',
                ButtonWidth: 100,
              ),
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
      ),
    );
  }
}