import 'package:flutter/material.dart';
import 'package:login_screen/Approval.dart';
import 'package:login_screen/Custom_Widgets/DropDown.dart';
import 'package:login_screen/Role.dart';
import 'Campus.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/Multi_Select_Field.dart';
import 'package:provider/provider.dart';

class Create_Approval_Chain extends StatefulWidget {
  @override
  _CreateApprovalChainPageState createState() => _CreateApprovalChainPageState();
}

class _CreateApprovalChainPageState extends State<Create_Approval_Chain> {
  final TextEditingController stepController = TextEditingController();

  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  List<Map<String, TextEditingController>> steps = [];
  List<RoleProvider> roleProviders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Create Approval Chain',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display steps
                  Column(
                    children: steps.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      roleProviders.add(RoleProvider());
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              DropDown(
                                fetchData: () => Role.fetchCampusLevelRoles(Campus.id),
                                label: "Select Role",
                                selectedValue: roleProviders[index].selectedRoleId,
                                onValueChanged: (dynamic id) {
                                  roleProviders[index].setSelectedRoleId(id);
                                },
                                keyName: "group_name",
                              ),
                              SizedBox(height: 20),
                              CustomTextFormField(
                                controller: step['stepController'] ?? TextEditingController(),
                                label: 'Step Number',
                                hintText: '1,2,3...',
                                borderColor: errorColor,
                                Keyboard_Type: TextInputType.number,
                                onChanged: (value) {
                                  _validateForm();
                                },
                              ),
                              SizedBox(height: 20),
                              Custom_Button(
                                onPressedFunction: () => _removeStep(index),
                                ButtonText: "Remove Step",
                                ButtonIcon: Icons.delete,
                                BackgroundColor: Colors.red,
                                ButtonWidth: 200,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Custom_Button(
                    onPressedFunction: _addStep,
                    ButtonText: "Add Step",
                    ButtonWidth: 150,
                    BackgroundColor: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  // Button to create approval chain
                  Custom_Button(
                    onPressedFunction: _submitForm,
                    ButtonText: "Create",
                    ButtonWidth: 120,
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
      ),
    );
  }

  // Function to add a new step
  void _addStep() {
    setState(() {
      steps.add({
        'stepController': TextEditingController(text: stepController.text),
      });
      roleProviders.add(RoleProvider());
      // Clear input fields
      stepController.clear();
    });
  }

  // Function to remove a step
  void _removeStep(int index) {
    setState(() {
      steps.removeAt(index);
      roleProviders.removeAt(index);
      _validateForm();
    });
  }

  void _submitForm() async {
    // Validate form
    if (_validateForm()) {
      setState(() {
        isLoading = true;
      });

      // Prepare data
      List<Map<String, dynamic>> stepData = steps.map((step) {
        return {
          'role_id': roleProviders[steps.indexOf(step)].selectedRoleId,
          'step_number': step['stepController']?.text,
        };
      }).toList();


      // Create approval chain
      final created = await Approval.createApprovalChain(Campus.id, stepData);

      setState(() {
        isLoading = false;
        if (created) {
          colorMessage = Colors.green;
          errorMessage = 'Approval Chain Created successfully';
          // Clear steps
          steps.clear();
        } else {
          colorMessage = Colors.red;
          errorMessage = 'Failed to create Approval Chain';
        }
      });
    }
  }

  // Function to validate the form
  bool _validateForm() {
    // Reset error message
    setState(() {
      errorMessage = null;
    });

    // Check each step's input
    for (int i = 0; i < steps.length; i++) {
      if (steps[i]['stepController']?.text.isEmpty ?? true) {
        setState(() {
          errorMessage = 'Please enter step number for each step';
          colorMessage = Colors.red;
        });
        return false;
      }
      if (roleProviders[i].selectedRoleId == null) {
        setState(() {
          errorMessage = 'Please select a role for each step';
          colorMessage = Colors.red;
        });
        return false;
      }
    }

    return true;
  }
}

class RoleProvider extends ChangeNotifier {
  dynamic _selectedRoleId;

  dynamic get selectedRoleId => _selectedRoleId;

  void setSelectedRoleId(dynamic id) {
    _selectedRoleId = id;
    notifyListeners();
  }
}
