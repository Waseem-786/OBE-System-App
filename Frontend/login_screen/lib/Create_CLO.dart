import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Create_Weekly_Topic.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
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

  final TextEditingController CLODescriptionController = TextEditingController();
  String? selectedBloomTaxonomy;
  String? selectedBTLevel;
  List<int> _selectedPLOs = [];
  late Future<List<dynamic>> _ploOptions;

  @override
  void initState() {
    super.initState();
    _ploOptions = PLO.fetchPLO();
  }

  Future<void> _fetchCLODetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final description = CLODescriptionController.text;
      final details = await CLO.fetchCLODetails(description);
      print(details);
      setState(() {
        selectedBloomTaxonomy = details['domain'];
        selectedBTLevel = details['level'];
        _selectedPLOs = List<int>.from(details['related_plos']);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch CLO details';
      });
    }
  }

  int _convertBTLevel(String level) {
    switch (level.toLowerCase()) {
      case 'remember':
        return 1;
      case 'understand':
        return 2;
      case 'apply':
        return 3;
      case 'analyze':
        return 4;
      case 'evaluate':
        return 5;
      case 'create':
        return 6;
      default:
        return 1;
    }
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextFormField(
                      controller: CLODescriptionController,
                      hintText: 'Enter CLO Description',
                      label: 'Enter CLO Description',
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _fetchCLODetails,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedBloomTaxonomy,
                  onChanged: (value) {
                    setState(() {
                      selectedBloomTaxonomy = value;
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'BT Level',
                    hintText: 'Bloom Taxonomy Level',
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
                  readOnly: true,
                  controller: TextEditingController(text: selectedBTLevel),
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
                        title: Text("Add PLOs"),
                        buttonText: Text("Add PLOs"),
                        options: snapshot.data!.map((option) => {'id': option['id'], 'name': option['name']}).toList(),
                        selectedOptions: _selectedPLOs,
                        onSelectionChanged: (values) {
                          setState(() {
                            _selectedPLOs = values.cast<int>();
                          });
                        },
                        displayKey: 'name',
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                Custom_Button(
                  onPressedFunction: () async {
                    String CLODescription = CLODescriptionController.text;
                    String? BT = selectedBloomTaxonomy;
                    String? BTLevel = selectedBTLevel;
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
                        CLO.level = _convertBTLevel(BTLevel);
                        CLO.PLOs = _selectedPLOs;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateWeeklyTopic(isFromOutline: true,), // Replace with your next screen
                          ),
                        );
                      } else {
                        bool created = await CLO.createCLO(
                            CLODescription, BT, _convertBTLevel(BTLevel), Course_id, _selectedPLOs);
                        if (created) {
                          CLODescriptionController.clear();
                          selectedBloomTaxonomy = null;
                          selectedBTLevel = null;
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
        ),
      ),
    );
  }
}