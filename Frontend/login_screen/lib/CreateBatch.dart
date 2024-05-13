import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Department.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/UpdateWidget.dart';

class CreateBatch extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? batchData;

  CreateBatch({this.isUpdate = false, this.batchData});

  @override
  State<CreateBatch> createState() => _CreateBatchState();
}

class _CreateBatchState extends State<CreateBatch> {
  late TextEditingController batchNameController;
  final List<TextEditingController> sectionControllers = [];

  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  @override
  void initState() {
    super.initState();
    batchNameController = TextEditingController(text: widget.batchData?['name'] ?? '');
    if (widget.isUpdate) {
      // Initialize section controllers with existing data
      List<dynamic> sections = widget.batchData?['sections'] ?? [];
      sections.forEach((section) {
        sectionControllers.add(TextEditingController(text: section));
      });
    } else {
      // Add an initial section controller
      sectionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose all text controllers
    batchNameController.dispose();
    for (var controller in sectionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addTextField() {
    setState(() {
      sectionControllers.add(TextEditingController());
    });
  }

  void _removeTextField(int index) {
    setState(() {
      if (sectionControllers.length > 1) {
        sectionControllers.removeAt(index);
      }
    });
  }

  void _clearFields() {
    setState(() {
      batchNameController.clear();
      sectionControllers.clear();
      sectionControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isUpdate ? 'Update' : 'Create';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          widget.isUpdate ? 'Update Batch' : 'Create Batch',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: batchNameController,
              hintText: 'Enter Batch Name',
              label: 'Enter Batch Name',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20),
            for (var i = 0; i < sectionControllers.length; i++)
              Column(
                children: [
                  CustomTextFormField(
                    controller: sectionControllers[i],
                    label: 'Enter Section',
                    hintText: 'Enter Section Here e.g. A',
                    suffixIcon: Icons.remove,
                    onSuffixIconPressed: () => _removeTextField(i),
                    borderColor: errorColor,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            Custom_Button(
              onPressedFunction: _addTextField,
              ButtonText: 'Add More Section',
              ButtonWidth: 200,
            ),
            const SizedBox(height: 20),
            Custom_Button(
              onPressedFunction: () async {
                if (widget.isUpdate) {
                  // Show confirmation dialog
                  bool confirmUpdate = await showDialog(
                    context: context,
                    builder: (context) => const UpdateWidget(
                      title: "Confirm Update",
                      content: "Are you sure you want to update Batch?",
                    ),
                  );
                  if (!confirmUpdate) {
                    return; // Cancel the update if user selects 'No' in the dialog
                  }
                }
                String batchName = batchNameController.text;
                List<String> sectionNames =
                sectionControllers.map((controller) => controller.text).toList();

                if (batchName.isEmpty ||
                    sectionNames.isEmpty ||
                    sectionNames.any((element) => element.isEmpty)) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  bool result;
                  if (widget.isUpdate) {
                    result = await Batch.updateBatch(
                        widget.batchData?['id'], batchName, sectionNames);
                  } else {
                    result = await Batch.createBatch(
                        batchName, Department.id, sectionNames);
                  }
                  if (result) {
                    _clearFields();
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor = Colors.black12;
                      errorMessage = widget.isUpdate
                          ? 'Batch Updated successfully'
                          : 'Batch Created successfully';
                    });
                  }
                }
              },
              ButtonWidth: 200,
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
