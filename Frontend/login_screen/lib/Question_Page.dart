import 'package:flutter/material.dart';
import 'package:login_screen/Assessment.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/RefinedQuestionsPage.dart';

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
  String? comment;

  TextEditingController commentController = TextEditingController();

  List<Question> questions = [Question()];

  Future<void> _showCommentDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your message'),
          content: TextFormField(
            controller: commentController,
            decoration: const InputDecoration(hintText: "Write your message here"),
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

  Future<List<dynamic>> _CLO_Options = CLO.fetchCLO(4);

  Future<void> _refineAllQuestions() async {
    setState(() {
      isLoading = true;
    });

    // Prepare the questions data
    List<Map<String, dynamic>> questionsData = questions.map((question) {
      return {
        "description": question.descriptionController.text,
        "clo": question.selectedCLOs,
        "parts": question.parts.map((part) {
          return {
            "description": part.descriptionController.text,
            "marks": int.tryParse(part.marksController.text) ?? 0,
          };
        }).toList(),
      };
    }).toList();

    try {
      final refinedData = await Assessment.refineCompleteAssessment(
        Assessment.name!,
        Assessment.teacher,
        Assessment.batch,
        Assessment.course,
        Assessment.total_marks,
        Assessment.duration!,
        Assessment.instructions!,
        questionsData,
      );

      setState(() {
        // Update questions with refined data
        for (var i = 0; i < questions.length; i++) {
          questions[i].descriptionController.text = refinedData[i]['description'];
          for (var j = 0; j < questions[i].parts.length; j++) {
            questions[i].parts[j].descriptionController.text = refinedData[i]['parts'][j]['description'];
          }
        }
      });

      // Navigate to Refined Questions Page
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RefinedQuestionsPage(
          questions: questions,
          onRefineAgain: _refineAllQuestions,
        ),
      ));
    } catch (e) {
      _showErrorSnackBar("Failed to refine assessment: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resetForm() {
    setState(() {
      questions = [Question()];
      errorMessage = null;
      comment = null;
      commentController.clear();
    });
  }

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Your Assessment',
                  style: CustomTextStyles.headingStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < questions.length; i++) _buildQuestionForm(i),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Custom_Button(
                    onPressedFunction: () {
                      setState(() {
                        questions.add(Question());
                      });
                    },
                    BackgroundColor: Color(0xffc19a6b),
                    ForegroundColor: Colors.white,
                    ButtonIcon: Icons.add,
                    ButtonText: "Add Question",
                    ButtonWidth: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Custom_Button(
                    onPressedFunction: () async {
                      await _showCommentDialog();
                      if (comment != null && comment!.isNotEmpty) {
                        await _refineAllQuestions();
                      }
                    },
                    BackgroundColor: Colors.green,
                    ForegroundColor: Colors.white,
                    ButtonIcon: Icons.auto_fix_high,
                    ButtonText: "Refine All Questions",
                    ButtonWidth: 270,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Custom_Button(
                    onPressedFunction: () {
                      _submitForm();
                    },
                    BackgroundColor: Color(0xffc19a6b),
                    ForegroundColor: Colors.white,
                    ButtonIcon: Icons.check,
                    ButtonText: "Create",
                    ButtonWidth: 150,
                  ),
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
    );
  }

  Widget _buildQuestionForm(int questionIndex) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: questions[questionIndex].descriptionController,
              label: 'Question Description',
              hintText: 'Define Encapsulation',
              borderColor: errorColor,
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
                  return Text('No CLOs available');
                } else {
                  return MultiSelectField(
                    options: snapshot.data!
                        .map((option) => {'id': option['id'], 'name': option['description']})
                        .toList(),
                    selectedOptions: questions[questionIndex].selectedCLOs,
                    onSelectionChanged: (values) {
                      setState(() {
                        questions[questionIndex].selectedCLOs = values.cast<int>();
                      });
                    },
                    buttonText: Text('CLOs'),
                    title: Text('Select CLOs'),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            if (questions[questionIndex].refinedDescription != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  questions[questionIndex].refinedDescription!,
                  style: CustomTextStyles.bodyStyle(
                    color: Colors.blue,
                    fontSize: 17,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            for (var j = 0; j < questions[questionIndex].parts.length; j++)
              _buildPartForm(questionIndex, j),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Custom_Button(
                onPressedFunction: () {
                  setState(() {
                    questions[questionIndex].parts.add(QuestionPart());
                  });
                },
                BackgroundColor: Color(0xffc19a6b),
                ForegroundColor: Colors.white,
                ButtonIcon: Icons.add,
                ButtonText: "Add Part",
                ButtonWidth: 160,
              ),
            ),
            const SizedBox(height: 20),
            if (questions.length > 1)
              Align(
                alignment: Alignment.centerRight,
                child: Custom_Button(
                  onPressedFunction: () {
                    setState(() {
                      questions.removeAt(questionIndex);
                    });
                  },
                  BackgroundColor: Colors.red,
                  ForegroundColor: Colors.white,
                  ButtonIcon: Icons.delete,
                  ButtonText: "Remove Question",
                  ButtonWidth: 240,
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPartForm(int questionIndex, int partIndex) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: questions[questionIndex].parts[partIndex].descriptionController,
                label: 'Part Description',
                hintText: 'Enter Description',
                borderColor: errorColor,
              ),
            ),
            if (questions[questionIndex].parts.length > 1)
              IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  setState(() {
                    questions[questionIndex].parts.removeAt(partIndex);
                  });
                },
              ),
          ],
        ),
        if (questions[questionIndex].parts[partIndex].refinedDescription != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              questions[questionIndex].parts[partIndex].refinedDescription!,
              style: CustomTextStyles.bodyStyle(
                color: Colors.blue,
                fontSize: 17,
              ),
            ),
          ),
        const SizedBox(height: 20),
        CustomTextFormField(
          controller: questions[questionIndex].parts[partIndex].marksController,
          label: 'Marks',
          hintText: 'Enter Marks',
          borderColor: errorColor,
          Keyboard_Type: TextInputType.number,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _submitForm() {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    List<Map<String, dynamic>> formattedQuestions = [];
    for (var question in questions) {
      if (question.descriptionController.text.isEmpty || question.selectedCLOs.isEmpty) {
        setState(() {
          errorMessage = 'Please fill in all fields for each question';
          colorMessage = Colors.red;
          isLoading = false;
        });
        return;
      }
      List<Map<String, dynamic>> parts = [];
      for (var part in question.parts) {
        if (part.descriptionController.text.isEmpty || part.marksController.text.isEmpty) {
          setState(() {
            errorMessage = 'Please fill in all fields for each part';
            colorMessage = Colors.red;
            isLoading = false;
          });
          return;
        }
        parts.add({
          "description": part.descriptionController.text,
          "marks": int.tryParse(part.marksController.text) ?? 0,
        });
      }
      formattedQuestions.add({
        "description": question.descriptionController.text,
        "clo": question.selectedCLOs,
        "parts": parts,
      });
    }

    Assessment.questions = formattedQuestions;

    Assessment.createCompleteAssessment(
      Assessment.name!,
      Assessment.teacher,
      Assessment.batch,
      Assessment.course,
      Assessment.total_marks,
      Assessment.duration!,
      Assessment.instructions!,
      Assessment.questions!,
    ).then((success) {
      setState(() {
        isLoading = false;
        if (success) {
          errorMessage = 'Assessment created successfully';
          colorMessage = Colors.green;
          _resetForm(); // Reset the form after successful creation
        } else {
          errorMessage = 'Failed to create assessment';
          colorMessage = Colors.red;
        }
      });
    });
  }
}

class Question {
  TextEditingController descriptionController = TextEditingController();
  List<int> selectedCLOs = [];
  List<QuestionPart> parts = [QuestionPart()];
  String? refinedDescription;
}

class QuestionPart {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController marksController = TextEditingController();
  String? refinedDescription;
}
