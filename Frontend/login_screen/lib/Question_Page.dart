import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_screen/Assessment.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';

import 'Course.dart';
import 'Custom_Widgets/Multi_Select_Field.dart';

class Question_Page extends StatefulWidget {
  @override
  State<Question_Page> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<Question_Page> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  bool isLoading = false;
  Color errorColor = Colors.black12;
  String? refinedQuestionDescription;
  String? comment;

  TextEditingController questionDescController = TextEditingController();
  TextEditingController questionCLOController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  List<TextEditingController> partDescriptionControllers = [];
  List<TextEditingController> partMarksControllers = [];
  List<String?> refinedPartDescriptions = [];

  Future<void> _showCommentDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your message'),
          content: TextFormField(
            controller: commentController,
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
                  comment = commentController.text;
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


  List<int> _selectedCLOS = [];
  Future<List<dynamic>> _CLO_Options = CLO.fetchCLO(4);

  @override
  void initState() {
    super.initState();
    // fetchCLOs().then((clo) {
    //   setState(() {
    //     _CLO_Options = clo;
    //   });
    // }).catchError((error) {
    //   setState(() {
    //     errorMessage = 'Failed to load CLOs: $error';
    //   });
    // });
  }

  // Future<List<Map<String, dynamic>>> fetchCLOs() async {
  //   List<dynamic> permissions = await CLO.fetchCLO(4);
  //   return permissions.map((clo) => {'id': clo['id'], 'name':
  //   clo['name']}).toList();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Question Form Page',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: questionDescController,
                    label: 'Question Description',
                    hintText: 'Define Encapsulation',
                    borderColor: errorColor,
                  ),
                  const SizedBox(height: 20),
                  if (refinedQuestionDescription != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        refinedQuestionDescription!,
                        style: CustomTextStyles.bodyStyle(
                          color: Colors.blue,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Custom_Button(
                        onPressedFunction: () async {
                          if (questionDescController.text.isEmpty) {
                            _showErrorSnackBar(
                                "Please enter the Question Description field");
                            return;
                          }
                          await _showCommentDialog();
                          if (comment != null && comment!.isNotEmpty) {
                            try {
                              refinedQuestionDescription =
                                  await Assessment.fetchRefinedDescription(
                                questionDescController.text,
                                comment!,
                              );
                              setState(() {});
                            } catch (e) {
                              _showErrorSnackBar(
                                  "Failed to fetch refined description");
                            }
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
                  const SizedBox(height: 20),
                  FutureBuilder<List<dynamic>>(
                    future: _CLO_Options,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No PLOs available');
                      } else {
                        print(snapshot.data!);
                        return MultiSelectField(
                          options: snapshot.data!.map((option) => {'id':
                          option['id'], 'name': option['description']})
                              .toList(),
                          selectedOptions: _selectedCLOS,
                          onSelectionChanged: (values) {
                            setState(() {
                              _selectedCLOS = values.cast<int>();
                            });
                          },
                          buttonText: Text('CLOs'),
                          title: Text('Select CLOs'),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  for (var i = 0; i < partDescriptionControllers.length; i++)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: partDescriptionControllers[i],
                                label: 'Part Description',
                                hintText: 'Enter Description',
                                borderColor: errorColor,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Custom_Button(
                              onPressedFunction: () async {
                                if (partDescriptionControllers[i]
                                    .text
                                    .isEmpty) {
                                  _showErrorSnackBar(
                                      "Please enter the Part Description field");
                                  return;
                                }
                                await _showCommentDialog();
                                if (comment != null && comment!.isNotEmpty) {
                                  try {
                                    refinedPartDescriptions[i] =
                                        await Assessment
                                            .fetchRefinedDescription(
                                      partDescriptionControllers[i].text,
                                      comment!,
                                    );
                                    setState(() {});
                                  } catch (e) {
                                    _showErrorSnackBar(
                                        "Failed to fetch refined description");
                                  }
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
                        if (refinedPartDescriptions[i] != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              refinedPartDescriptions[i]!,
                              style: CustomTextStyles.bodyStyle(
                                color: Colors.blue,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: partMarksControllers[i],
                                label: 'Marks',
                                hintText: 'Enter Marks',
                                borderColor: errorColor,
                                Keyboard_Type: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  Custom_Button(
                    onPressedFunction: () {
                      setState(() {
                        partDescriptionControllers.add(TextEditingController());
                        partMarksControllers.add(TextEditingController());
                        refinedPartDescriptions.add(null);
                      });
                    },
                    BackgroundColor: Color(0xffc19a6b),
                    ForegroundColor: Colors.white,
                    ButtonText: "Add Part",
                    ButtonWidth: 130,
                  ),
                  const SizedBox(height: 20),
                  Custom_Button(
                    onPressedFunction: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                      });
                      if (questionDescController.text.isEmpty ||
                          questionCLOController.text.isEmpty ||
                          partDescriptionControllers
                              .any((controller) => controller.text.isEmpty) ||
                          partMarksControllers
                              .any((controller) => controller.text.isEmpty)) {
                        setState(() {
                          errorMessage = 'Please fill in all fields';
                          colorMessage = Colors.red;
                          isLoading = false;
                        });
                      } else {
                        List<Map<String, dynamic>> questions = [];
                        for (int i = 0;
                            i < partDescriptionControllers.length;
                            i++) {
                          String partDescription =
                              partDescriptionControllers[i].text;
                          int partMarks =
                              int.tryParse(partMarksControllers[i].text) ?? 0;
                          List<int> questionCLO = questionCLOController.text
                              .split(',')
                              .map((e) => int.tryParse(e.trim()) ?? 0)
                              .toList();

                          if (partDescription.isNotEmpty && partMarks > 0) {
                            // For part of the question
                            Map<String, dynamic> part = {
                              "description": partDescription,
                              "marks": partMarks,
                            };

                            // For the whole question including parts
                            Map<String, dynamic> question = {
                              "description": questionDescController.text,
                              "clo": questionCLO,
                              "parts": [part],
                            };
                            questions.add(question);
                          }
                        }

                        Assessment.createCompleteAssessment(
                          Assessment.name!,
                          Assessment.teacher,
                          Assessment.batch,
                          Assessment.course,
                          Assessment.total_marks,
                          Assessment.duration!,
                          Assessment.instructions!,
                          questions,
                        ).then((success) {
                          setState(() {
                            isLoading = false;
                            if (success) {
                              errorMessage = 'Assessment created successfully';
                              colorMessage = Colors.green;
                            } else {
                              errorMessage = 'Failed to create assessment';
                              colorMessage = Colors.red;
                            }
                          });
                        });
                      }
                    },
                    BackgroundColor: Color(0xffc19a6b),
                    ForegroundColor: Colors.white,
                    ButtonText: "Create",
                    ButtonWidth: 110,
                  ),
                  const SizedBox(height: 20),
                  if (isLoading) const CircularProgressIndicator(),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: CustomTextStyles.bodyStyle(color: colorMessage),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
