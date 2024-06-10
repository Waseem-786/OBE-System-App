import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/CLO_Update_Report.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/PLO.dart';
import 'Course.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Create_CLO extends StatefulWidget {
  final bool isFromOutline;
  final String? justification;

  Create_CLO({this.isFromOutline = false, this.justification});

  @override
  State<Create_CLO> createState() => _Create_CLOState();
}

class _Create_CLOState extends State<Create_CLO> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  bool showForm = false;
  Color errorColor = Colors.black12;

  List<TextEditingController> cloControllers = [TextEditingController()];
  List<String?> selectedBloomTaxonomies = [null];
  List<String?> selectedBTLevels = [null];
  List<List<int>> selectedPLOs = [[]];
  List<bool> isFieldValid = [true];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchCLODetails(int index) async {
    setState(() {
      isLoading = true;
    });

    try {
      final description = cloControllers[index].text;
      final details = await CLO.fetchCLODetails(description);
      print(details);
      setState(() {
        selectedBloomTaxonomies[index] = details['bloom_taxonomy'];
        selectedBTLevels[index] = details['level'].toString();
        selectedPLOs[index] = List<int>.from(details['plos']);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch CLO details';
      });
    }
  }

  Future<void> _generateCLOs(String userComments) async {
    setState(() {
      isLoading = true;
    });

    try {
      final generatedCLOs = await CLO.generateCLOs(Outline.id, userComments);

      setState(() {
        cloControllers = List<TextEditingController>.from(generatedCLOs
            .map((clo) => TextEditingController(text: clo['description'])));
        selectedBloomTaxonomies = List<String?>.from(
            generatedCLOs.map((clo) => clo['bloom_taxonomy'] as String?), growable: true);
        selectedBTLevels = List<String?>.from(
            generatedCLOs.map((clo) => clo['level'].toString()), growable: true);
        selectedPLOs = List<List<int>>.from(
            generatedCLOs.map((clo) => List<int>.from(clo['plos'])), growable: true);
        isFieldValid = List<bool>.filled(cloControllers.length, true, growable: true);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to generate CLOs';
      });
    }
  }

  void _addNewCLOField() {
    setState(() {
      cloControllers.add(TextEditingController());
      selectedBloomTaxonomies.add(null);
      selectedBTLevels.add(null);
      selectedPLOs.add([]);
      isFieldValid.add(true);
    });
  }

  void _removeCLOField(int index) {
    setState(() {
      cloControllers.removeAt(index);
      selectedBloomTaxonomies.removeAt(index);
      selectedBTLevels.removeAt(index);
      selectedPLOs.removeAt(index);
      isFieldValid.removeAt(index);
    });
  }

  Future<void> _submitCLOs() async {
    bool allFieldsValid = true;

    List<Map<String, dynamic>> closData = [];
    for (int i = 0; i < cloControllers.length; i++) {
      String CLODescription = cloControllers[i].text;
      String? BT = selectedBloomTaxonomies[i];
      String? BTLevel = selectedBTLevels[i];

      if (CLODescription.isEmpty || BT == null || BTLevel == null || selectedPLOs[i].isEmpty) {
        allFieldsValid = false;
        isFieldValid[i] = false;
      } else {
        isFieldValid[i] = true;
        closData.add({
          'description': CLODescription,
          'bloom_taxonomy': BT,
          'level': int.parse(BTLevel!),
          'plos': selectedPLOs[i],
          'course_id': Course.id
        });
      }
    }

    setState(() {});

    if (!allFieldsValid) {
      setState(() {
        colorMessage = Colors.red;
        errorColor = Colors.red;
        errorMessage = 'Please enter all fields';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    if (widget.justification != null && widget.justification!.isNotEmpty) {
      Map<String, dynamic> updateResult = await CLO.updateCLO(Course.id, widget.justification!, closData);

      // Extract previous CLOs, new CLOs, and justification from the update result
      List<Map<String, dynamic>> previousCLOs = (updateResult['previous_clos'] as List<dynamic>).cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> newCLOs = (updateResult['new_clos'] as List<dynamic>).cast<Map<String, dynamic>>();
      String justification = updateResult['justification'];
      Navigator.push(context, MaterialPageRoute(builder: (context) => CLO_Update_Report(previousCLOs: previousCLOs, newCLOs: newCLOs, justification: justification)));

    } else {
      bool success;
      success = await CLO.createCLO(closData);
      if (success) {
        setState(() {
          // Clear fields and reset to default state
          cloControllers = [TextEditingController()];
          selectedBloomTaxonomies = [null];
          selectedBTLevels = [null];
          selectedPLOs = [[]];
          isFieldValid = [true];
          isLoading = false;
          colorMessage = Colors.green;
          errorColor = Colors.black12;
          errorMessage = widget.justification != null ? 'CLOs Updated successfully' : 'CLOs Created successfully';
        });

        Navigator.pop(context);  // Go back to View_CLOs page
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorColor = Colors.red;
          errorMessage = widget.justification != null ? 'Failed to update CLOs' : 'Failed to create CLOs';
        });
      }
    }


  }

  Future<void> _showGenerateCLOPopup() async {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Generate CLOs"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("You can add an optional comment for generating CLOs:"),
              SizedBox(height: 10),
              CustomTextFormField(
                controller: commentController,
                hintText: 'Enter comment (optional)',
                label: 'Comment',
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Generate"),
              onPressed: () {
                Navigator.of(context).pop();
                _generateCLOs(commentController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.justification != null && widget.justification!.isNotEmpty ? 'Update CLO' : 'Create CLO';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          alignment: Alignment.center,
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
                Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(),
                ),
                Visibility(
                  visible: !isLoading,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Add or Update CLOs:",
                        style: CustomTextStyles.headingStyle(fontSize: 18, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      Custom_Button(
                        onPressedFunction: _showGenerateCLOPopup,
                        ButtonWidth: 230,
                        ButtonText: "Generate CLOs",
                        ButtonIcon: Icons.auto_awesome,
                        ForegroundColor: Colors.white,
                        BackgroundColor: Colors.purple,
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(cloControllers.length, (index) {
                        return Card(
                          elevation: 4,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  controller: cloControllers[index],
                                  borderColor: Colors.black,
                                  hintText: 'Enter CLO Description',
                                  label: 'CLO Description',
                                  maxLines: 5,
                                  suffixIcon: Icons.search,
                                  onSuffixIconPressed: () {
                                    _fetchCLODetails(index);
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Bloom\'s Taxonomy',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: isFieldValid[index] ? Colors.black12 : Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: selectedBloomTaxonomies[index],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'BT Level',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: isFieldValid[index] ? Colors.black12 : Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: selectedBTLevels[index],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'PLOs',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: isFieldValid[index] ? Colors.black12 : Colors.red,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: selectedPLOs[index].join(', '),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Custom_Button(
                                  onPressedFunction: () => _removeCLOField(index),
                                  ButtonIcon: Icons.remove_circle,
                                  ButtonText: "Remove CLO",
                                  ButtonWidth: 200,
                                  ForegroundColor: Colors.white,
                                  BackgroundColor: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      Custom_Button(
                        onPressedFunction: _addNewCLOField,
                        ButtonWidth: 230,
                        ButtonText: "Add Another CLO",
                        ButtonIcon: Icons.add,
                        ForegroundColor: Colors.white,
                        BackgroundColor: Colors.green,
                      ),
                      const SizedBox(height: 20),
                      Custom_Button(
                        onPressedFunction: _submitCLOs,
                        ButtonWidth: 200,
                        ButtonText: buttonText,
                        ButtonIcon: Icons.check,
                        ForegroundColor: Colors.white,
                        BackgroundColor: Colors.blue,
                      ),
                      const SizedBox(height: 20),
                      errorMessage != null
                          ? Text(
                        errorMessage!,
                        style: CustomTextStyles.bodyStyle(color: colorMessage),
                      )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
