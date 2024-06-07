import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'Question_Page.dart';

class RefinedQuestionsPage extends StatelessWidget {
  final List<Question> questions;
  final Function onRefineAgain;

  RefinedQuestionsPage({required this.questions, required this.onRefineAgain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Refined Questions',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var question in questions) _buildQuestionCard(question),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Custom_Button(
                      onPressedFunction: () {
                        Navigator.of(context).pop();
                      },
                      ForegroundColor: Colors.white,
                      BackgroundColor: Colors.green,
                      ButtonText: 'OK',
                      ButtonWidth: 170,
                      ButtonHeight: 60,
                    ),
                    Custom_Button(
                        onPressedFunction: () {
                          onRefineAgain();
                        },
                      ForegroundColor: Colors.white,
                      BackgroundColor: Colors.blue,
                      ButtonText: 'Refine Again',
                      ButtonWidth: 170,
                      ButtonHeight: 60,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question:',
              style: CustomTextStyles.headingStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              question.refinedDescription ?? question.descriptionController.text,
              style: CustomTextStyles.bodyStyle(fontSize: 16, color: Colors.black54),
            ),
            const Divider(height: 20, color: Colors.grey),
            for (var part in question.parts) _buildPartCard(part),
          ],
        ),
      ),
    );
  }

  Widget _buildPartCard(QuestionPart part) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Part:',
            style: CustomTextStyles.headingStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            part.refinedDescription ?? part.descriptionController.text,
            style: CustomTextStyles.bodyStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            'Marks: ${part.marksController.text}',
            style: CustomTextStyles.bodyStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
