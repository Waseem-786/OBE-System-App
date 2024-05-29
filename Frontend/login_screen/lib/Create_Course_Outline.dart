import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Create_Course_Schedule.dart';
import 'package:login_screen/Outline.dart';
import 'Batch.dart';
import 'Course.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DropDown.dart';
import 'User.dart';

class Create_Course_Outline extends StatefulWidget {
  @override
  State<Create_Course_Outline> createState() => _Create_Course_Outline();
}

class _Create_Course_Outline extends State<Create_Course_Outline> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  final TextEditingController OutlineBatchController = TextEditingController();
  dynamic? SelectedBatch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Form Page'),
        backgroundColor: const Color(0xffc19a6b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropDown(
              fetchData: () => Batch.getBatchBydeptId(User.departmentid),
              selectedValue: SelectedBatch,
              label: "Batch",
              hintText: "Select Batch",
              controller: OutlineBatchController,
              onValueChanged: (dynamic id) {
                setState(() {
                  SelectedBatch = id;
                });
              },
            ),
            const SizedBox(height: 20),
            Custom_Button(
              onPressedFunction: () async {
                String BatchIdString = OutlineBatchController.text.toString();
                if (BatchIdString.isEmpty) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  int BatchId = int.parse(BatchIdString);
                  Outline.batch = BatchId;
                  Outline.course = Course.id;
                  Outline.teacher = User.id;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateCourseSchedule(isFromOutline: true),
                    ),
                  );
                }
              },
              BackgroundColor: Color(0xffc19a6b),
              ForegroundColor: Colors.white,
              ButtonText: "Next",
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
    );
  }
}
