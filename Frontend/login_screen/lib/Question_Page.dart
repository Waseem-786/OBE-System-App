import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_screen/Assessment.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';

class Question_Page extends StatefulWidget {
  @override
  State<Question_Page> createState() => _Question_PageState();
}

class _Question_PageState extends State<Question_Page> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  bool isLoading = false;
  Color errorColor = Colors.black12;

  TextEditingController QuestionDescController = TextEditingController();
  TextEditingController QuestionCLOController = TextEditingController();
  List<TextEditingController> partDescriptionControllers = [];
  List<TextEditingController> partMarksControllers = [];

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
                    controller: QuestionDescController,
                    label: 'Question Description',
                    hintText: 'Define Encapsulation',
                    borderColor: errorColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    controller: QuestionCLOController,
                    label: 'Question CLOs',
                    hintText: '1,2,...',
                    borderColor: errorColor,
                    Keyboard_Type: TextInputType.number,

                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  for (var i = 0; i < partDescriptionControllers.length; i++)
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Remove",style: CustomTextStyles.bodyStyle(),),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  partDescriptionControllers.removeAt(i);
                                  partMarksControllers.removeAt(i);
                                });
                              },
                            ),
                          ],
                        ),
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
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
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
                      if (QuestionDescController.text.isEmpty ||
                          QuestionCLOController.text.isEmpty ||
                          partDescriptionControllers.any((controller) => controller.text.isEmpty) ||
                          partMarksControllers.any((controller) => controller.text.isEmpty)) {
                        setState(() {
                          errorMessage = 'Please fill in all fields';
                          colorMessage = Colors.red;
                          isLoading = false;
                        });
                      } else {
                        List<Map<String, dynamic>> questions = [];
                        for (int i = 0; i < partDescriptionControllers.length; i++) {
                          String partdescription = partDescriptionControllers[i].text;
                          int partmarks = int.tryParse(partMarksControllers[i].text) ?? 0;
                          String QuestionDesc = QuestionDescController.text;
                          List<int> QuestionCLO = QuestionCLOController.text.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();

                          if (partdescription.isNotEmpty && partmarks > 0) {
                            // for part of the question
                            Map<String, dynamic> part = {
                              "description": partdescription,
                              "marks": partmarks,
                            };

                            // for whole of the question including parts
                            Map<String, dynamic> question = {
                              "description": QuestionDesc,
                              "clo": QuestionCLO,
                              "parts": [part],
                            };
                            questions.add(question);
                            print("SAaaaffhghD");
                            print(questions);
                          }
                        }

                        // Assessment.questions = questions;
                        // print("object");
                        // print(Assessment.questions);

                        Assessment.createCompleteAssessment(
                          Assessment.name!,
                          Assessment.teacher,
                          Assessment.batch,
                          Assessment.course,
                          Assessment.total_marks,
                          Assessment.duration!,
                          Assessment.instructions!,
                          questions ,
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
