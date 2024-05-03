import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Login_Page.dart';
import 'package:login_screen/University.dart';
import 'Campus.dart';
import 'Token.dart';
import 'User.dart';

class CourseDashboard extends StatefulWidget {
  const CourseDashboard({super.key});

  @override
  State<CourseDashboard> createState() => _CourseDashboardState();
}

class _CourseDashboardState extends State<CourseDashboard> {


  List<String> headings = [
    'Course Objective',
    'Course Assessment',
    'Course Schedule',
    'Course CLO',
    'Course Books',
    'Mapping PLO',

  ];

  List<IconData> icons = [
    FontAwesomeIcons.bullseye,
    FontAwesomeIcons.pollH,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.fileAlt,
    FontAwesomeIcons.bookOpen,
    FontAwesomeIcons.projectDiagram,
    FontAwesomeIcons.calendarAlt,

  ];

  List<String> screenNames = [
    'Objective_Page',
    'Course_Assessment_Page',
    'Course_Schedule_Profile',
    'CLO_Page',
    'Course_Books',
    'User_Management',
    'Weekly_Assessment'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xffc19a6b),
        title: Text('Course Dashboard',style: CustomTextStyles.headingStyle(fontSize: 22),),
      ),
      body: Column(
        children: [


          const SizedBox(
            height: 50,
          ),

          SingleChildScrollView(
            child: SizedBox(
              height: 700,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/${screenNames[index]}');
                      },

                      child: Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF8B5A2B), // Dark brown
                                Color(0xFFC19A6B), // Light brown
                                Color(0xFF8B5A2B), // Dark brown
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    icons[index],
                                    size: 39,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    headings[index],
                                    style:
                                    CustomTextStyles.headingStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: headings.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}