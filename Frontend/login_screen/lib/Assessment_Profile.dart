import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus_Page.dart';
import 'package:login_screen/Custom_Widgets/DetailCard.dart';
import 'package:login_screen/Permission.dart';
import 'package:login_screen/University.dart';
import 'Assessment.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DeleteAlert.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';

class Assessment_Profile extends StatefulWidget {
  final List<dynamic> Data;

  Assessment_Profile({ required this.Data});
  @override
  State<Assessment_Profile> createState() => _Assessment_ProfileState();
}

class _Assessment_ProfileState extends State<Assessment_Profile> {


  final assessment_id = Assessment.id; // Assuming University is a class with static members
  late Future<bool> hasDeleteAssessmentPermissionFuture;
  late Future<bool> hasViewAssessmentPermissionFuture;

  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    print("ME");

    print(widget.Data);
    print("ME");
    hasDeleteAssessmentPermissionFuture = Permission.searchPermissionByCodename("delete_assessment");
    hasViewAssessmentPermissionFuture = Permission.searchPermissionByCodename("view_assessment");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Assessment Profile', style: CustomTextStyles.headingStyle(fontSize: 22)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade200,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text("Assessment Details", style: CustomTextStyles.headingStyle())),
              const SizedBox(height: 20),
              ..._buildUniversityInfoCards(),
              SizedBox(height: 20),
              Center(child: _actionButtons()),
              SizedBox(height: 10),
              Center(
                child: Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(),
                ),
              ),
              if (errorMessage != null)
                Center(
                  child: Text(errorMessage!,
                      style: CustomTextStyles.bodyStyle(color: colorMessage)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildUniversityInfoCards() {
    List<Widget> cards = [
      DetailCard(label: "Assessment Name", value: widget.Data[0]['name'], icon: Icons.school),
      DetailCard(label: "Assessment Total Marks", value: widget.Data[0]['total_marks'].toString(), icon: Icons.numbers),
      DetailCard(label: "Assessment Duration", value: "${widget.Data[0]['duration']} minutes", icon: Icons.timer),
    ];

    // Add cards for questions
    List<dynamic> questions = widget.Data[0]['questions'];
    for (int i = 0; i < questions.length; i++) {
      List<dynamic> parts = questions[i]['parts'];
      String partsString = '';
      for (int j = 0; j < parts.length; j++) {
        partsString += "Part ${j + 1}: ${parts[j]['description']} - ${parts[j]['marks']} marks\n";
      }
      partsString += "\nCLOs: ";
      List<dynamic> clos = questions[i]['clo'];
      partsString += clos.join(', '); // Join CLOs with commas
      cards.add(DetailCard(label: "Question ${i + 1} Description", value: questions[i]['description'], icon: Icons.question_answer));
      cards.add(DetailCard(label: "Question ${i + 1} Parts", value: partsString, icon: Icons.question_answer));
    }

    return cards;
  }


  Widget _actionButtons() {
    return Column(
      children: [
        PermissionBasedButton(
          buttonText: "Show Assessments",
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          buttonWidth: 250,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Campus_Page())),
          permissionFuture: hasViewAssessmentPermissionFuture,
        ),
        SizedBox(height: 20),
        PermissionBasedButton(
          buttonText: "Delete",
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          buttonWidth: 120,
          onPressed: () => _confirmDelete(context),
          permissionFuture: hasDeleteAssessmentPermissionFuture,
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: "Confirm Deletion",
        content: "Are you sure you want to delete this Assessment?",
      ),
    );
    if (confirmDelete) {
      setState(() => isLoading = true);
      bool deleted = await Assessment.deleteAssessment(assessment_id);
      if (deleted) {
        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorMessage = 'Assessment deleted successfully';
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to delete Assessment';
        });
      }
    }
  }
}
