
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Department.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class CreateBatch extends StatefulWidget {
  @override
  State<CreateBatch> createState() => _CreateBatchState();
}

class _CreateBatchState extends State<CreateBatch> {

  String?errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors.black12;
  // color of border of text fields when the error is not occurred

  final TextEditingController BatchNameController = TextEditingController();
  final List<TextEditingController> SectionControllers = [];

  void initState() {
    super.initState();
    // Add an initial text controller
    SectionControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    // Clean up the text controllers when the widget is disposed
    for (var controller in SectionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTextField() {
    setState(() {
      // Add a new text controller when "Add More" is clicked
      SectionControllers.add(TextEditingController());
    });
  }

  void _removeTextField(int index) {
    setState(() {
      // Remove the text controller and corresponding text field
      if (SectionControllers.length > 1) {
        // Remove the text controller and corresponding text field
        SectionControllers.removeAt(index);
      }
    });
  }

  void _clearFields() {
    setState(() {
      BatchNameController.clear();
      SectionControllers.clear();
      SectionControllers.add(TextEditingController()); // Add one section field
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          margin: const EdgeInsets.only(left: 90),
          child: Text(
            "Create Batch",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 90),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                CustomTextFormField(controller: BatchNameController,
                  hintText: 'Enter Batch Name',
                  label: 'Enter Batch Name',
                ),
                SizedBox(height: 20),
                for (var i = 0; i < SectionControllers.length; i++)
                  Column(
                    children: [
                      CustomTextFormField(
                        controller: SectionControllers[i],
                        label: 'Enter Section',
                        hintText: 'Enter Section Here e.g. A',
                        suffixIcon: Icons.remove,
                        onSuffixIconPressed: ()=>_removeTextField(i),

                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                Custom_Button(
                  onPressedFunction: _addTextField,
                  ButtonText: 'Add More Section',
                  ButtonWidth: 200,
                ),






                const SizedBox(height: 20,),
                Custom_Button(
                  onPressedFunction: () async {
                    String BatchName = BatchNameController.text;

                    List<String> SectionNames = SectionControllers
                        .map((controller) => controller.text)
                        .toList();



                    if (BatchName.isEmpty || SectionNames.isEmpty ||
                        SectionNames.any((element) => element.isEmpty)) {
                      setState(() {
                        colorMessage = Colors.red;
                        errorColor = Colors.red;
                        errorMessage = 'Please enter all fields';
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      bool created = await Batch.createBatch(BatchName,
                          Department.id,SectionNames);
                      if (created) {
                        _clearFields();
                        setState(() {
                          isLoading = false;
                          colorMessage = Colors.green;
                          errorColor = Colors.black12; // Reset errorColor to default value
                          errorMessage = 'Batch Created successfully';
                        });
                      }
                    }
                  },
                  ButtonWidth: 200,
                  ButtonText: 'Create Batch',),
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
      ),


    );
  }
}
