import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Custom_Widgets/OutlineRow.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/University.dart';
import 'Custom_Widgets/SectionHeader.dart';

class CourseOutlineProfile extends StatefulWidget {
  @override
  State<CourseOutlineProfile> createState() => _CourseOutlineProfileState();
}

class _CourseOutlineProfileState extends State<CourseOutlineProfile> {
  Color fillingColor = Colors.blue.shade100;
  Color borderColor = Colors.blue.shade900;

  late Future<Map<String, dynamic>?> courseOutline;
  Map<String, dynamic>? courseOutlineData; // This will hold the course data

  @override
  void initState() {
    super.initState();
    courseOutline = Outline.fetchCompleteOutline(Outline.id).then((data) {
      if (data != null) {
        setState(() {
          courseOutlineData = data; // Set the course data once fetched
        });
      }
    });
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
      body: courseOutlineData == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is null
          : buildCourseContent(),
    );
  }

  Widget buildCourseContent() {
    final courseInfo = courseOutlineData!['course_info'];
    final courseSchedule = courseOutlineData!['schedule'];
    final assessments = courseOutlineData!['assessments'];
    final books = courseOutlineData!['books'];
    final objectives = courseOutlineData!['objectives'];
    final clos = courseOutlineData!['clos'];
    final weeklyTopics = courseOutlineData!['weekly_topics'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              Department.name,
              textAlign: TextAlign.center,
              style: CustomTextStyles.headingStyle(fontSize: 20)
                  .copyWith(decoration: TextDecoration.underline),
            ),
            Text(
              Campus.name,
              textAlign: TextAlign.center,
              style: CustomTextStyles.headingStyle(fontSize: 20)
                  .copyWith(decoration: TextDecoration.underline),
            ),
            Text(
              University.name,
              textAlign: TextAlign.center,
              style: CustomTextStyles.headingStyle(fontSize: 20)
                  .copyWith(decoration: TextDecoration.underline),
            ),
            SizedBox(height: 20),
            _buildCourseInformation(courseInfo),
            SizedBox(height: 20),
            _buildCourseSchedule(courseSchedule),
            SizedBox(height: 20),
            _buildCourseAssessments(assessments),
            SizedBox(height: 20),
            _buildCourseBooks(books),
            SizedBox(height: 20),
            _buildCourseDescription(courseInfo),
            SizedBox(height: 20),
            _buildCourseObjectives(objectives),
            SizedBox(height: 20),
            _buildCourseCLOsMapping(clos), // New section for CLOs mapping
            SizedBox(height: 20),
            _buildWeeklyTopics(weeklyTopics), // New section for Weekly Topics
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseInformation(Map<String, dynamic> courseInfo) {
    List<Widget> infoWidgets = [
      SectionHeader(title: "Course Information"), // Add the header
    ];

    // Add rows for course information dynamically
    infoWidgets.addAll([
      OutlineRow(
        texts: [
          'Course Number and Title:',
          '${courseInfo['code']} ${courseInfo['title']}'
        ],
        isHeader: true,
        backgroundColor: fillingColor,
      ),
      OutlineRow(
        texts: [
          'Credits:',
          '${courseInfo['theory_credits']} + ${courseInfo['lab_credits']} (${courseInfo['theory_credits'] + courseInfo['lab_credits']})'
        ],
        backgroundColor: Colors.transparent,
      ),
      OutlineRow(
        texts: [
          'Instructor-In-Charge:',
          '${courseOutlineData?['teacher_first_name']} ${courseOutlineData?['teacher_last_name']}'
        ],
        backgroundColor: fillingColor,
      ),
      OutlineRow(
        texts: ['Course Type:', courseInfo['course_type']],
        backgroundColor: Colors.transparent,
      ),
      OutlineRow(
        texts: ['Required or Elective:', courseInfo['required_elective']],
        backgroundColor: fillingColor,
      ),
      OutlineRow(
        texts: ['Course Prerequisite:', courseInfo['prerequisite'] ?? 'None'],
        backgroundColor: Colors.transparent,
      ),
      OutlineRow(
        texts: ['Batch:', courseOutlineData?['batch_name']],
        backgroundColor: fillingColor,
      ),
    ]);

    return Column(children: infoWidgets);
  }

  Widget _buildCourseSchedule(Map<String, dynamic> schedule) {
    List<Widget> scheduleWidgets = [
      SectionHeader(title: "Course Schedule"), // Add the header
    ];

    // Extracting each item from the schedule map
    scheduleWidgets.add(OutlineRow(
      texts: [
        'Lecture Hours:',
        '${schedule['lecture_hours_per_week']} hour(s)/week'
      ],
      isHeader: true,
      backgroundColor: Colors.blue.shade100,
    ));
    scheduleWidgets.add(OutlineRow(
      texts: ['Lab Hours:', '${schedule['lab_hours_per_week']} hour(s)/week'],
      backgroundColor: Colors.transparent,
    ));
    scheduleWidgets.add(OutlineRow(
      texts: [
        'Discussion Hours:',
        '${schedule['discussion_hours_per_week']} hour(s)/week'
      ],
      backgroundColor: Colors.blue.shade100,
    ));
    scheduleWidgets.add(OutlineRow(
      texts: [
        'Office Hours:',
        '${schedule['office_hours_per_week']} hour(s)/week'
      ],
      backgroundColor: Colors.transparent,
    ));

    return Column(children: scheduleWidgets);
  }

  Widget _buildCourseAssessments(List<dynamic> assessments) {
    List<Widget> assessmentWidgets = [
      SectionHeader(title: "Course Assessments"), // Add the header
    ];

    for (int i = 0; i < assessments.length; i++) {
      var assessment = assessments[i];
      bool isOdd = i % 2 == 1;
      Color bgColor = isOdd ? Colors.blue.shade100 : Colors.transparent;
      List<String> rowData = [
        assessment['name'],
        assessment['count'].toString(),
        assessment['weight'] +
            "%" // Assuming weight is a string ending with '%'
      ];

      assessmentWidgets.add(OutlineRow(
        texts: rowData,
        isHeader: i == 0, // First item as header
        backgroundColor: bgColor,
      ));
    }

    return Column(children: assessmentWidgets);
  }

  Widget _buildCourseBooks(List<dynamic> books) {
    List<Widget> bookWidgets = [
      SectionHeader(title: "Course Books"), // Add the header
    ];

    // First, group books by type
    Map<String, List<String>> groupedBooks = {};
    for (var book in books) {
      String type = book['book_type'];
      if (!groupedBooks.containsKey(type)) {
        groupedBooks[type] = [];
      }
      groupedBooks[type]?.add(book['title']);
    }

    // Sort or organize the types if necessary
    var sortedTypes = groupedBooks.keys.toList()..sort();

    // Then, create widgets for each type with their books
    for (var type in sortedTypes) {
      List<String> titles = groupedBooks[type]!;
      bool isHeader = true; // First row in each section acts as a header

      for (var title in titles) {
        bookWidgets.add(OutlineRow(
          texts: [type + ":", title],
          isHeader: isHeader,
          backgroundColor: isHeader ? Colors.blue.shade100 : Colors.transparent,
        ));
        // Only the first row after the section header should be marked as header
        if (isHeader)
          type = ""; // Clear the type after using it once to avoid repeating
        isHeader = false;
      }
    }

    return Column(children: bookWidgets);
  }

  Widget _buildCourseDescription(Map<String, dynamic> courseInfo) {
    List<Widget> descriptionWidgets = [
      SectionHeader(title: "Course Description"), // Add the header
    ];

    // Extracting each item from the schedule map
    descriptionWidgets.add(OutlineRow(
      texts: ['${courseInfo['description']}'],
      isHeader: true,
      backgroundColor: Colors.blue.shade100,
    ));

    return Column(children: descriptionWidgets);
  }

  Widget _buildCourseObjectives(List<dynamic> objectives) {
    List<Widget> objectiveWidgets = [
      SectionHeader(title: "Course Objectives"),  // Add the header
    ];

    for (int i = 0; i < objectives.length; i++) {
      var objective = objectives[i];
      bool isOdd = i % 2 == 1;
      Color bgColor = isOdd ? Colors.blue.shade100 : Colors.transparent;

      objectiveWidgets.add(
        OutlineRow(texts: ["${objective['description']}"], backgroundColor: bgColor,),
      );
    }

    return Column(children: objectiveWidgets);
  }

  Widget _buildCourseCLOsMapping(List<dynamic> clos) {
    List<Widget> cloWidgets = [
      SectionHeader(title: "Course CLOs and their Mapping to PLOs"), // Add the header
    ];

    cloWidgets.add(
      OutlineRow(
        texts: ["CLO No.", "Course Learning Outcome (CLOs)", "PLOs", "Learning Level"],
        isHeader: true,
        backgroundColor: Colors.blue.shade100,
        columnWidths: [1, 4, 1, 1],
      ),
    );

    for (int i = 0; i < clos.length; i++) {
      var clo = clos[i];
      bool isOdd = i % 2 == 1;
      Color bgColor = isOdd ? Colors.blue.shade100 : Colors.transparent;
      String learningLevel = _getLearningLevel(clo['bloom_taxonomy'], clo['level']);
      String ploList = clo['plo'].map((plo) => plo).join(", ");

      cloWidgets.add(
        OutlineRow(
          texts: ["CLO ${i + 1}", clo['description'], ploList, learningLevel],
          backgroundColor: bgColor,
          columnWidths: [1, 4, 1, 1],
        ),
      );
    }

    return Column(children: cloWidgets);
  }

  Widget _buildWeeklyTopics(List<dynamic> weeklyTopics) {
    List<Widget> weeklyTopicWidgets = [
      SectionHeader(title: "Weekly Topics"), // Add the header
    ];

    weeklyTopicWidgets.add(
      OutlineRow(
        texts: ["Week", "Topic", "Description/ Lecture Breakdown", "CLO", "Assessment"],
        isHeader: true,
        backgroundColor: Colors.blue.shade100,
        columnWidths: [1, 2, 4, 1, 2],
      ),
    );

    for (int i = 0; i < weeklyTopics.length; i++) {
      var topic = weeklyTopics[i];
      bool isOdd = i % 2 == 1;
      Color bgColor = isOdd ? Colors.blue.shade100 : Colors.transparent;
      String cloList = topic['clo'].map((clo) => clo).join(", ");

      weeklyTopicWidgets.add(
        OutlineRow(
          texts: [
            topic['week_number'].toString(),
            topic['topic'],
            topic['description'].replaceAll('\n', ', '),
            cloList,
            topic['assessments']
          ],
          backgroundColor: bgColor,
          columnWidths: [1, 2, 4, 1, 2],
        ),
      );
    }

    return Column(children: weeklyTopicWidgets);
  }

  String _getLearningLevel(String bloomTaxonomy, int level) {
    String taxonomyLetter;
    switch (bloomTaxonomy) {
      case 'Cognitive':
        taxonomyLetter = 'C';
        break;
      case 'Psychomotor':
        taxonomyLetter = 'P';
        break;
      case 'Affective':
        taxonomyLetter = 'A';
        break;
      default:
        taxonomyLetter = '';
        break;
    }
    return '$taxonomyLetter-$level';
  }

}
