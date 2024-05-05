import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/University.dart';

class CourseOutlineProfile extends StatefulWidget {
  @override
  State<CourseOutlineProfile> createState() => _CourseOutlineProfileState();
}

class _CourseOutlineProfileState extends State<CourseOutlineProfile> {
  Color blueColor = Colors.blue.shade100;
  Color borderColor = Colors.blue.shade900;

  late Future<Map<String, dynamic>?> courseOutline;

  @override
  void initState() {
    super.initState();
    courseOutline = Outline.fetchCompleteOutline(Outline.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Complete Course Outline',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: courseOutline,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: CustomTextStyles.bodyStyle(),
            ));
          } else {
            final data = snapshot.data;
            if (data == null) {
              return Center(
                  child: Text('No data available',
                      style: CustomTextStyles.bodyStyle()));
            } else {
              final courseInfo = data['course_info'];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Department.name,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.headingStyle(fontSize: 10)
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                        Text(
                          Campus.name,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.headingStyle(fontSize: 15)
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                        Text(
                          University.name,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.headingStyle(fontSize: 20)
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${courseInfo['code']} ${courseInfo['title']}',
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.headingStyle(
                                  color: borderColor, fontSize: 25)
                              .copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: borderColor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: borderColor,
                                  width: 2
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Course Information',
                                      style: CustomTextStyles.headingStyle(
                                          fontSize: 30, color: borderColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: blueColor,
                                border: Border.all(
                                  color: borderColor,
                                  width: 2
                                )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: borderColor,
                                            width: 2,
                                          )
                                        )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Course Number and Title:',
                                          style: CustomTextStyles.bodyStyle(
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${courseInfo['code']} ${courseInfo['title']}',
                                        style: CustomTextStyles.bodyStyle(
                                            fontSize: 20),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  right: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  )
                                )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: borderColor,
                                            width: 2,
                                          )
                                        )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Credits:',
                                          style: CustomTextStyles.bodyStyle(
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${courseInfo['theory_credits'] + courseInfo['lab_credits']} (${courseInfo['theory_credits']} + ${courseInfo['lab_credits']})',
                                        style: CustomTextStyles.bodyStyle(
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: blueColor,
                                border: Border(
                                  right: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  left: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  )
                                )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: borderColor,
                                            width: 2,
                                          )
                                        )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Instructor-In-charge:',
                                          style: CustomTextStyles.bodyStyle(
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${data['teacher_first_name']} ${data['teacher_last_name']}',
                                        style: CustomTextStyles.bodyStyle(
                                            fontSize: 20),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  left: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  )
                                )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: borderColor,
                                            width: 2,
                                          )
                                        )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Course type:',
                                          style: CustomTextStyles.bodyStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${courseInfo['course_type']}',
                                        style: CustomTextStyles.bodyStyle(fontSize: 20),
                                      ),
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: blueColor,
                                border: Border(
                                  right: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  left: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  )
                                )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: borderColor,
                                            width: 2,
                                          )
                                        )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Required or Elective:',
                                          style: CustomTextStyles.bodyStyle(
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${courseInfo['required_elective']}',
                                        style: CustomTextStyles.bodyStyle(
                                            fontSize: 20),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  left: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  )
                                )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: borderColor,
                                            width: 2,
                                          )
                                        )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Course Prerequisite:',
                                          style: CustomTextStyles.bodyStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${courseInfo['prerequisite']}',
                                          style: CustomTextStyles.bodyStyle(fontSize: 20),
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: blueColor,
                                border: Border(
                                  right: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  left: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  bottom: BorderSide(
                                    color: borderColor,
                                    width: 2,
                                  )
                                )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: borderColor,
                                            width: 2,
                                          )
                                        )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Batch:',
                                          style: CustomTextStyles.bodyStyle(
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${data['batch_name']}',
                                        style: CustomTextStyles.bodyStyle(
                                            fontSize: 20),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
