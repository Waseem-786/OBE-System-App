import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/UpdateWidget.dart';
import 'Campus.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'University.dart';

class Create_Campus extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? CampusData;

  Create_Campus({this.isUpdate = false, this.CampusData});

  @override
  State<Create_Campus> createState() => _Create_CampusState();
}

class _Create_CampusState extends State<Create_Campus> {
  int University_id = University.id;
  var myToken;
  String?
      errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading =
      false; // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors
      .black12; // color of border of text fields when the error is not occurred
  String? RefinedMissionStatement;
  String? RefinedVisionStatement;
  String? comment;

  late TextEditingController CampusNameController;
  late TextEditingController CampusMissionController;
  late TextEditingController CampusVisionController;
  late TextEditingController CommentController;

  @override
  void initState() {
    CampusNameController =
        TextEditingController(text: widget.CampusData?['name'] ?? '');
    CampusMissionController =
        TextEditingController(text: widget.CampusData?['mission'] ?? '');
    CampusVisionController =
        TextEditingController(text: widget.CampusData?['vision'] ?? '');
    CommentController = TextEditingController();

  }

  Future<void> _showCommentDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your message'),
          content: TextFormField(
            controller: CommentController,
            decoration:
            const InputDecoration(hintText: "Write your message here"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                setState(() {
                  comment = CommentController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Center(child: Text(message)),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isUpdate ? 'Update' : 'Create';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Campus Form Page',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    controller: CampusNameController,
                    label: 'Campus Name',
                    hintText: 'Enter Campus Name',
                    borderColor: errorColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    controller: CampusMissionController,
                    label: 'Campus Mission',
                    hintText: 'Enter Campus Mission',
                    borderColor: errorColor,
                  ),
                  SizedBox(height: 20,),
                  const SizedBox(
                    height: 20,
                  ),
                  if (RefinedMissionStatement != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        RefinedMissionStatement.toString()!,
                        style: CustomTextStyles.bodyStyle(
                            color: Colors.blue, fontSize: 17),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Custom_Button(
                        onPressedFunction: () async {
                          if (CampusMissionController.text.isEmpty) {
                            _showErrorSnackBar("Please enter the University Mission field");
                            return;
                          }
                          await _showCommentDialog();
                          if (comment != null && comment!.isNotEmpty) {
                            var response = await Campus.fetchMissionData(
                                CampusMissionController.text.toString(),
                                "mission",
                                comment!);
                            RefinedMissionStatement =   response['refined_statement'];
                            setState(() {});
                          }
                        },
                        BackgroundColor: Colors.green,
                        ForegroundColor: Colors.white,
                        ButtonIcon: Icons.generating_tokens,
                        ButtonHeight: 35,
                        ButtonWidth: 50,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    controller: CampusVisionController,
                    label: 'Campus Vision',
                    hintText: 'Enter Campus Vision',
                    borderColor: errorColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (RefinedVisionStatement != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        RefinedVisionStatement.toString()!,
                        style: CustomTextStyles.bodyStyle(
                            color: Colors.blue, fontSize: 17),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Custom_Button(
                        onPressedFunction: () async {
                          if (CampusVisionController.text.isEmpty) {
                            _showErrorSnackBar("Please enter the University Vision field");
                            return;
                          }
                          await _showCommentDialog();
                          if (comment != null && comment!.isNotEmpty) {
                            var response = await Campus.fetchMissionData(
                                CampusVisionController.text.toString(),
                                "vision",
                                comment!);
                            RefinedVisionStatement =   response['refined_statement'];
                            setState(() {});
                          }
                        },
                        BackgroundColor: Colors.green,
                        ForegroundColor: Colors.white,
                        ButtonIcon: Icons.generating_tokens,
                        ButtonHeight: 35,
                        ButtonWidth: 50,
                      ),
                    ],
                  ),
                  Custom_Button(
                    onPressedFunction: () async {
                      if (widget.isUpdate) {
                        // Show confirmation dialog
                        bool confirmUpdate = await showDialog(
                          context: context,
                          builder: (context) => const UpdateWidget(
                            title: "Confirm Update",
                            content: "Are you sure you want to update Campus?",
                          ),
                        );
                        if (!confirmUpdate) {
                          return; // Cancel the update if user selects 'No' in the dialog
                        }
                      }
                      // Continue with update or create logic
                      String CampusName = CampusNameController.text;
                      String CampusMission = RefinedMissionStatement != null ? RefinedMissionStatement.toString()
                          : CampusMissionController.text;
                      String CampusVision = RefinedVisionStatement !=null ? RefinedVisionStatement.toString()
                          : CampusVisionController.text;
                      if (CampusName.isEmpty ||
                          CampusMission.isEmpty ||
                          CampusVision.isEmpty) {
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
                          result = await Campus.updateCampus(widget.CampusData?['id'],
                              CampusName, CampusMission, CampusVision);
                        } else {
                          result = await Campus.createCampus(
                              CampusName, CampusMission, CampusVision, University_id);
                        }
                        if (result) {
                          // Clear the text fields
                          CampusNameController.clear();
                          CampusMissionController.clear();
                          CampusVisionController.clear();

                          setState(() {
                            isLoading = false;
                            colorMessage = Colors.green;
                            errorColor =
                                Colors.black12; // Reset errorColor to default value
                            errorMessage = widget.isUpdate
                                ? 'Campus Updated successfully'
                                : 'Campus Created successfully';
                          });
                        }
                      }
                    },
                    BackgroundColor: Color(0xffc19a6b),
                    ForegroundColor: Colors.white,
                    ButtonText: buttonText,
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
}
