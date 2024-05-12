import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Login_Page.dart';
import 'package:login_screen/University.dart';
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

      List<dynamic> userPermissions = await Permission.getUserPermissions(User.id);
      for (Map<String, dynamic> permission in userPermissions) {
        switch (permission["codename"]) {
          case "add_customuser":
            headings.add('User Management');
            icons.add(Icons.add);
            screenNames.add('User_Management');
            break;
          case 'add_customgroup':
            headings.add('Add Custom Group');
            icons.add(Icons.add);
            screenNames.add('AddCustomGroupPage');
            break;
          case 'add_group':
            headings.add('Add Group');
            icons.add(Icons.add);
            screenNames.add('AddGroupPage');
            break;
          case "add_university":
            headings.add("University");
            icons.add(FontAwesomeIcons.landmark);
            screenNames.add("University_Page");
            break;
          case "add_campus":
            headings.add("Campus");
            icons.add(FontAwesomeIcons.landmark);
            screenNames.add("Campus_Page");
            break;
          case "add_department":
            headings.add("Department");
            icons.add(FontAwesomeIcons.landmark);
            screenNames.add("Department_Page");
            break;
          case "add_batch":
            headings.add("Batch");
            icons.add(FontAwesomeIcons.landmark);
            screenNames.add("Batch_Page");
            break;
          case "add_section":
            headings.add("Section");
            icons.add(FontAwesomeIcons.landmark);
            screenNames.add("Section_Page");
            break;
          case "add_peo":
            headings.add("PEO");
            icons.add(FontAwesomeIcons.landmark);
            screenNames.add("PEO_Page");
            break;
          case "add_plo":
            headings.add("PLO");
            icons.add(FontAwesomeIcons.landmark);
            screenNames.add("PLO_Page");
            break;
          case "add_courseinformation":
            headings.add("Courses");
            icons.add(
              FontAwesomeIcons.book,
            );
            screenNames.add("Course_Page");
            break;
        }
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
          : Column(
        children: [
          const SizedBox(
            height: 23,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 8),
                child: CircleAvatar(
                  radius: 35,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.asset(
                      "assets/images/MyProfile.jpeg",
                    ),
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
                        style: CustomTextStyles.bodyStyle(fontSize: 27)),
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
          const SizedBox(
            height: 15,
          ),
          const Divider(thickness: 1, color: Colors.black),
          SingleChildScrollView(
            child: SizedBox(
              height: 575,
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
          ),
        ],
      ),
    );
  }
}
