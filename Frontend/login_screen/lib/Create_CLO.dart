import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Create_Weekly_Topic.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/DropDown.dart';
import 'package:login_screen/PLO.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/Multi_Select_Field.dart';

class Create_CLO extends StatefulWidget {
  final bool isFromOutline;

  Create_CLO({this.isFromOutline = false});

  @override
  State<Create_CLO> createState() => _Create_CLOState();
}

class _Create_CLOState extends State<Create_CLO> {
  int Course_id = Course.id;
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  final TextEditingController CLODescription_Controller = TextEditingController();
  String? SelectedBloomTaxonomy;
  int? SelectedBTLevel;
  List<int> _selectedPLOs = [];
  late Future<List<dynamic>> _ploOptions;

  @override
  void initState() {
    super.initState();
    _ploOptions = PLO.fetchPLO();
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isFromOutline ? 'Next' : 'Create CLO';

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
            CustomTextFormField(
              controller: CLODescription_Controller,
              hintText: 'Enter CLO Description',
              label: 'Enter CLO Description',
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: SelectedBloomTaxonomy,
              onChanged: (value) {
                setState(() {
                  SelectedBloomTaxonomy = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Bloom Taxonomy',
                hintText: 'Select Bloom Taxonomy',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12,
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
            const SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: SelectedBTLevel,
              onChanged: (value) {
                setState(() {
                  SelectedBTLevel = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'BT Level',
                hintText: 'Select BT Level',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12,
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
            const SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: _ploOptions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No PLOs available');
                } else {
                  return MultiSelectField(
                    options: snapshot.data!.map((option) => {'id': option['id'], 'name': option['name']}).toList(),
                    selectedOptions: _selectedPLOs,
                    onSelectionChanged: (values) {
                      setState(() {
                        _selectedPLOs = values.cast<int>();
                      });
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Custom_Button(
              onPressedFunction: () async {
                String CLODescription = CLODescription_Controller.text;
                String? BT = SelectedBloomTaxonomy;
                int? BTLevel = SelectedBTLevel;
                if (CLODescription.isEmpty || BT == null || BTLevel == null || _selectedPLOs.isEmpty) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  if (widget.isFromOutline) {
                    CLO.description = CLODescription;
                    CLO.bloom_taxonomy = BT;
                    CLO.level = BTLevel;
                    CLO.PLOs = _selectedPLOs;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateWeeklyTopic(isFromOutline: true,), // Replace with your next screen
                      ),
                    );
                  } else {
                    bool created = await CLO.createCLO(
                        CLODescription, BT, BTLevel, Course_id, _selectedPLOs);
                    if (created) {
                      CLODescription_Controller.clear();
                      SelectedBloomTaxonomy = null;
                      SelectedBTLevel = null;
                      _selectedPLOs = [];

                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorColor = Colors.black12; // Reset errorColor to default value
                        errorMessage = 'CLO Created successfully';
                      });
                    }
                  }
                }
              },
              ButtonWidth: 160,
              ButtonText: buttonText,
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
    );
  }

}
