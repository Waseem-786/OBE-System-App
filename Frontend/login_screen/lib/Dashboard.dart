import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_screen/Campus_Select.dart';
import 'package:login_screen/Course_Select.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Department_Select.dart';
import 'package:login_screen/Login_Page.dart';
import 'package:login_screen/University.dart';
import 'package:login_screen/University_Select.dart';
import 'Batch_Select.dart';
import 'Campus.dart';
import 'Permission.dart';
import 'Token.dart';
import 'User.dart';

class Dashboard_Page extends StatefulWidget {
  @override
  State<Dashboard_Page> createState() => _Dashboard_PageState();
}

class _Dashboard_PageState extends State<Dashboard_Page> {
  List<String> headings = [];
  List<IconData> icons = [];
  List<String> screenNames = [];
  bool isLoading = false; // Set initial loading state to true
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await User.getUser();
      _setData();
    }
  }

  Future<void> _setData() async {
    try {
      if (User.isUniLevel()) {
        await _setUniversityData();
      } else if (User.iscampusLevel()) {
        await _setUniversityData();
        await _setCampusData();
      } else if (User.isdeptLevel()) {
        await _setUniversityData();
        await _setCampusData();
        await _setDepartmentData();
      } else if (User.isSuperUser) {
        // Handle superuser case
      }

      bool hasUniversity = false;
      bool hasCampus = false;
      bool hasDepartment = false;
      bool hasBatch = false;

      List<dynamic> userPermissions =
          await Permission.getUserPermissions(User.id);
      for (Map<String, dynamic> permission in userPermissions) {
        if (permission["codename"] == "view_customuser") {
          headings.add('User Management');
          icons.add(Icons.person);
          screenNames.add('User_Management');
        } else if (permission["codename"] == "view_customgroup") {
          headings.add('Group Management');
          icons.add(Icons.group);
          screenNames.add('Role Page');
        } else if (permission["codename"] == "view_university") {
          hasUniversity = true;
        } else if (permission["codename"] == "view_campus") {
          hasCampus = true;
        } else if (permission["codename"] == "view_department") {
          hasDepartment = true;
        } else if (permission["codename"] == "view_batch") {
          hasBatch = true;
        } else if (permission["codename"] == "view_peo") {
          headings.add("PEO");
          icons.add(FontAwesomeIcons.landmark);
          if (User.isUniLevel()) {
            screenNames.add("Campus_Select");
          } else if (User.iscampusLevel()) {
            screenNames.add("Department_Select");
          } else if (User.isdeptLevel()) {
            screenNames.add("PEO_Page");
          } else if (User.isSuperUser) {
            screenNames.add("University_Select");
          }
        } else if (permission["codename"] == "view_plo") {
          headings.add("PLO");
          icons.add(FontAwesomeIcons.schoolLock);
          screenNames.add("PLO_Page");
        } else if (permission["codename"] == "view_courseinformation") {
          headings.add("Courses");
          icons.add(FontAwesomeIcons.book);
          if (User.isUniLevel()) {
            screenNames.add("Campus_Select");
          } else if (User.iscampusLevel()) {
            screenNames.add("Course_Page");
          } else if (User.isdeptLevel()) {
            screenNames.add("Course_Outline_Page");
          } else if (User.isSuperUser) {
            screenNames.add("University_Select");
          }
        } else if (permission['codename'] == "view_assessment") {
          headings.add("Assessment");
          icons.add(FontAwesomeIcons.pencil);
          if (User.isUniLevel()) {
            screenNames.add("Campus_Select");
          } else if (User.iscampusLevel()) {
            screenNames.add("Department_Select");
          } else if (User.isdeptLevel()) {
            screenNames.add("Batch_Select");
          } else if (User.isSuperUser) {
            screenNames.add("University_Select");
          }
        }
      }

      if (hasUniversity) {
        headings.add("University");
        icons.add(FontAwesomeIcons.landmark);
        screenNames.add("University_Page");
      } else if (hasCampus) {
        headings.add("Campus");
        icons.add(FontAwesomeIcons.landmark);
        screenNames.add("Campus_Page");
      } else if (hasDepartment) {
        headings.add("Department");
        icons.add(FontAwesomeIcons.landmark);
        screenNames.add("Department_Page");
      } else if (hasBatch) {
        headings.add("Batch Management");
        icons.add(FontAwesomeIcons.calendarAlt);
        screenNames.add("Batch_Management");
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        errorMessage = "Error fetching data: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _setUniversityData() async {
    try {
      var universityData =
          await University.getUniversityById(User.universityid);
      if (universityData != null && universityData.isNotEmpty) {
        University.id = universityData['id'];
        University.name = universityData['name'];
        University.mission = universityData['mission'];
        University.vision = universityData['vision'];
      }
    } catch (e) {
      print("Failed to set university data: $e");
    }
  }

  Future<void> _setCampusData() async {
    try {
      var campusData = await Campus.getCampusById(User.campusid);
      if (campusData != null && campusData.isNotEmpty) {
        Campus.id = campusData['id'];
        Campus.name = campusData['name'];
        Campus.mission = campusData['mission'];
        Campus.vision = campusData['vision'];
        Campus.university_id = campusData['university'];
        Campus.university_name = campusData['university_name'];
      }
    } catch (e) {
      print("Failed to set campus data: $e");
    }
  }

  Future<void> _setDepartmentData() async {
    try {
      var departmentData =
          await Department.getDepartmentById(User.departmentid);
      if (departmentData != null && departmentData.isNotEmpty) {
        Department.id = departmentData['id'];
        Department.name = departmentData['name'];
        Department.mission = departmentData['mission'];
        Department.vision = departmentData['vision'];
        Department.campus_id = departmentData['campus'];
        Department.campus_name = departmentData['campus_name'];
      }
    } catch (e) {
      print("Failed to set department data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Admin Dashboard',
          style: CustomTextStyles.headingStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.power_settings_new_outlined,
              size: 30,
            ),
            onPressed: () {
              Token.deleteTokens();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 10, right: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.asset(
                              "assets/images/MyProfile.jpeg",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(User.username,
                                  style:
                                      CustomTextStyles.bodyStyle(fontSize: 27)),
                              Text(
                                User.email,
                                style: CustomTextStyles.bodyStyle(),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.notifications, size: 35),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, color: Colors.black),
                  SizedBox(
                    height: MediaQuery.of(context).size.height -
                        220, // Adjust height as needed
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
                              if (headings[index] == 'PEO') {
                                University_Select.isForPEO = true;
                                Campus_Select.isForPEO = true;
                                Department_Select.isForPEO = true;
                              } else {
                                University_Select.isForPEO = false;
                                Campus_Select.isForPEO = false;
                                Department_Select.isForPEO = false;
                              }
                              if (headings[index] == 'Assessment') {
                                University_Select.isForAssessment = true;
                                Campus_Select.isForAssessment = true;
                                Department_Select.isForAssessment = true;
                                Batch_Select.isForAssessment = true;
                                Course_Select.isForAssessment = true;
                              } else {
                                University_Select.isForAssessment = false;
                                Campus_Select.isForAssessment = false;
                                Department_Select.isForAssessment = false;
                                Batch_Select.isForAssessment = false;
                                Course_Select.isForAssessment = false;
                              }
                              Navigator.pushNamed(context, '/${screenNames[index]}');
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
                                          style: CustomTextStyles.headingStyle(
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
                ],
              ),
            ),
    );
  }
}
