import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Login_Page.dart';
import 'package:login_screen/University.dart';
import 'Campus.dart';
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




  Future<void> _GetUser() async {
    await User.getUser();
    _setData();
  }

  Future<void> _setData() async {
    if (User.isUniLevel()) {
      headings = [
        'Program Management',
        'Batch Management',
        'Courses',
        'Approval Process',
        'Assessments',
        'User Management',
        'Role Management',
        'University',

      ];
      icons = [
        FontAwesomeIcons.cogs,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.book,
        FontAwesomeIcons.thumbsUp,
        FontAwesomeIcons.poll,
        FontAwesomeIcons.users,
        FontAwesomeIcons.users,
        FontAwesomeIcons.landmark,

      ];

      screenNames = [
        'Program_Management',
        'Batch_Management',
        'Course_Page',
        'Approval_Process',
        'Assessments',
        'User_Management',
        'Role Page',
        'University_Page',


      ];
      _setUniversityData();
    } else if (User.iscampusLevel()) {
      headings = [
        'Program Management',
        'Batch Management',
        'Courses',
        'Approval Process',
        'Assessments',
        'User Management',
        'Role Management',
        'University'
      ];
      icons = [
        FontAwesomeIcons.cogs,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.book,
        FontAwesomeIcons.thumbsUp,
        FontAwesomeIcons.poll,
        FontAwesomeIcons.users,
        FontAwesomeIcons.users,
        FontAwesomeIcons.landmark,
      ];

      screenNames = [
        'Program_Management',
        'Batch_Management',
        'Course_Page',
        'Approval_Process',
        'Assessments',
        'User_Management',
        'Role Page',
        'University_Page'
      ];
      _setUniversityData();
      _setCampusData();
    } else if (User.isdeptLevel()) {
      headings = [
        'PLO',
        'PEO',
        'Batch Management',
        'Role Management'
      ];
      icons = [
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.users,

      ];

      screenNames = [
        'PLO',
        'PEO',
        'Batch_Management',
        'Role Page'
      ];
      _setUniversityData();
      _setCampusData();
      _setDepartmentData();
    } else if (User.isSuperUser) {
      headings = [
        'Program Management',
        'PLO',
        'PEO',
        'Batch Management',
        'Courses',
        'Approval Process',
        'Assessments',
        'User Management',
        'Role Management'
        'University',
      ];
      icons = [
        FontAwesomeIcons.cogs,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.book,
        FontAwesomeIcons.thumbsUp,
        FontAwesomeIcons.poll,
        FontAwesomeIcons.users,
        FontAwesomeIcons.users,
        FontAwesomeIcons.landmark,
      ];

      screenNames = [
        'Program Management',
        'PLO',
        'PEO',
        'Batch_Management',
        'Course_Page',
        'Approval_Process',
        'Assessments',
        'User_Management',
        'Role Page'
        'University_Page',
      ];
    }
  }

  Future<void> _setUniversityData() async {
    try {
      var universityData = await University.getUniversityById(User.universityid);
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
    try{
      var departmentData = await Department.getDepartmentById(User.departmentid);
      if (departmentData != null && departmentData.isNotEmpty) {
        Department.id = departmentData['id'];
        Department.name = departmentData['name'];
        Department.mission = departmentData['mission'];
        Department.vision = departmentData['vision'];
        Department.campus_id = departmentData['campus'];
        Department.campus_name = departmentData['campus_name'];
      }
    }
    catch (e) {
      print("Failed to set department data: $e");
    }

  }

  String _selectedOption = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _GetUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xffc19a6b),
              title: Text(
                'Admin Dashboard',
                style: CustomTextStyles.headingStyle(fontSize: 22),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.power_settings_new_outlined, size: 30,),
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
            body: Column(
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
                            // onTap: () {
                            //   // Navigate to the corresponding location
                            //   // For simplicity, let's print the location for now
                            //   // print(screenNames[index]);
                            //
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> screenNames[index]));
                            //
                            // },
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
      },
    );
  }
}
