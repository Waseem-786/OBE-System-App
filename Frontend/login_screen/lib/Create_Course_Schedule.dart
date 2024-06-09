import 'package:flutter/material.dart';
import 'package:login_screen/Course_Schedule.dart';
import 'package:login_screen/Create_Course_Assessment_Page.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Outline.dart';

class CreateCourseSchedule extends StatefulWidget {
  final bool isFromOutline;

  const CreateCourseSchedule({Key? key, this.isFromOutline = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateCourseScheduleState();
}

class CreateCourseScheduleState extends State<CreateCourseSchedule> {
  final TextEditingController lectureHoursController = TextEditingController();
  final TextEditingController labHoursController = TextEditingController();
  final TextEditingController discussionHoursController = TextEditingController();
  final TextEditingController officeHoursController = TextEditingController();

  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Create Course Schedule',
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
                  CustomTextFormField(
                    controller: lectureHoursController,
                    label: 'Lecture Hours Per Week',
                    hintText: 'Enter lecture hours per week',
                    borderColor: errorColor,
                    Keyboard_Type: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: labHoursController,
                    label: 'Lab Hours Per Week',
                    hintText: 'Enter lab hours per week',
                    borderColor: errorColor,
                    Keyboard_Type: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: discussionHoursController,
                    label: 'Discussion Hours Per Week',
                    hintText: 'Enter discussion hours per week',
                    borderColor: errorColor,
                    Keyboard_Type: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: officeHoursController,
                    label: 'Office Hours Per Week',
                    hintText: 'Enter office hours per week',
                    borderColor: errorColor,
                    Keyboard_Type: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Custom_Button(
                    onPressedFunction: () async {
                      int? lectureHours = int.tryParse(lectureHoursController.text);
                      int? labHours = int.tryParse(labHoursController.text);
                      int? discussionHours = int.tryParse(discussionHoursController.text);
                      int? officeHours = int.tryParse(officeHoursController.text);

                      if (lectureHours == null || labHours == null || discussionHours == null || officeHours == null) {
                        setState(() {
                          colorMessage = Colors.red;
                          errorColor = Colors.red;
                          errorMessage = 'Please Enter all Fields';
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });

                        if (widget.isFromOutline){
                          Course_Schedule.lecture_hours_per_week = lectureHours;
                          Course_Schedule.lab_hours_per_week = labHours;
                          Course_Schedule.discusion_hours_per_week = discussionHours;
                          Course_Schedule.office_hours_per_week = officeHours;
                          Course_Schedule.course_outline = Outline.id;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Create_Course_Assessment_Page(isFromOutline: true)));
                        } else {
                          bool created = await Course_Schedule.createCourseSchedule(3, lectureHours!, labHours!, discussionHours!, officeHours!);
                          if (created) {
                            //Clear all the fields after creation
                            lectureHoursController.clear();
                            labHoursController.clear();
                            discussionHoursController.clear();
                            officeHoursController.clear();

                            setState(() {
                              isLoading = false;
                              colorMessage = Colors.green;
                              errorColor = Colors.black12;
                              errorMessage = 'Course Schedule Created successfully';
                            });
                          }
                        }
                      }


                    },
                    ButtonText: widget.isFromOutline ? 'Next' : 'Create',
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
