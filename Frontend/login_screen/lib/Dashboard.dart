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
        'University',
      ];
      icons = [
        FontAwesomeIcons.cogs,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.book,
        FontAwesomeIcons.thumbsUp,
        FontAwesomeIcons.poll,
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
        'University',
      ];
      icons = [
        FontAwesomeIcons.cogs,
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.book,
        FontAwesomeIcons.thumbsUp,
        FontAwesomeIcons.poll,
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
        'University_Page',
      ];
      _setUniversityData();
      _setCampusData();
    } else if (User.isdeptLevel()) {
      headings = [
        'PLO',
        'PEO',
      ];
      icons = [
        FontAwesomeIcons.calendarAlt,
        FontAwesomeIcons.calendarAlt,
      ];

      screenNames = [
        'PLO',
        'PEO',
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
        'University_Page',
      ];
    }
  }

  Future<void> _setUniversityData() async {
    Future<List<dynamic>> universityFuture =
        University.getUniversityById(User.universityid);
    List<dynamic> universityData = await universityFuture;
    if (universityData.isNotEmpty) {
      print(universityData[0]['name']);
      University.id = universityData[0]['id'];
      University.name = universityData[0]['name'];
      University.mission = universityData[0]['mission'];
      University.vision = universityData[0]['vision'];
    }
  }

  Future<void> _setCampusData() async {
    Future<List<dynamic>> campusFuture = Campus.getCampusById(User.campusid);
    List<dynamic> campusData = await campusFuture;
    if (campusData.isNotEmpty) {
      print(campusData[0]['name']);
      Campus.id = campusData[0]['id'];
      Campus.name = campusData[0]['name'];
      Campus.mission = campusData[0]['mission'];
      Campus.vision = campusData[0]['vision'];
    }
  }

  Future<void> _setDepartmentData() async {
    Future<List<dynamic>> deptFuture =
        Department.getDepartmentById(User.departmentid);
    List<dynamic> deptData = await deptFuture;
    if (deptData.isNotEmpty) {
      print(deptData[0]['name']);
      Department.id = deptData[0]['id'];
      Department.name = deptData[0]['name'];
      Department.mission = deptData[0]['mission'];
      Department.vision = deptData[0]['vision'];
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
            appBar: AppBar(title: Text('Loading...')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffc19a6b),
              // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Container(
                margin: EdgeInsets.only(left: 26),
                child: Text('Admin Dashboard',
                    style: CustomTextStyles.headingStyle(fontSize: 22)
                    // TextStyle(fontWeight: FontWeight
                    //   .bold, fontFamily: 'Merri'
                    //
                    // ),
                    //

                    ),
              ),
              // actions: [
              //   IconButton(
              //     icon: Icon(Icons.more_vert),
              //     iconSize: 25,
              //     onPressed: () {},
              //   ),
              // ],

              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (String result) {
                    if (result == 'Log out') {
                      Token.deleteTokens();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                    setState(() {
                      _selectedOption = result;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Log out',
                      child: Text('Log out'),
                    ),
                    // PopupMenuItem<String>(
                    //   value: 'update',
                    //   child: Text('Update'),
                    // ),
                    // Add more PopupMenuItems for other options as needed
                  ],
                ),
              ],
            ),
            body: Container(
              // margin: const EdgeInsets.only(bottom: 102),
              height: double.infinity,
              color: Colors.white10,
              child: Column(
                children: [
                  SizedBox(
                    height: 23,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 8),
                        child: CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.asset(
                              "assets/images/MyProfile.jpeg",
                            ),
                          ),
                          radius: 35,
                        ),
                      ),
                      SizedBox(
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
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.notifications, size: 35),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Divider(thickness: 1, color: Colors.black),

                  SingleChildScrollView(
                    child: Container(
                      height: 600,
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
                                    context, '/' + screenNames[index]);
                              },

                              child: Card(
                                elevation: 7,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
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
                                          SizedBox(
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
                  // SizedBox(height: 33,)
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
