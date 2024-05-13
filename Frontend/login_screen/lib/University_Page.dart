import 'package:flutter/material.dart';
import 'package:login_screen/Create_University.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Custom_Widgets/PermissionBasedButton.dart';
import 'package:login_screen/University.dart';
import 'package:login_screen/University_Profile.dart';
import 'package:login_screen/Permission.dart';

import 'Custom_Widgets/PermissionBasedIcon.dart'; // Import Permission class

class University_Page extends StatefulWidget {
  @override
  State<University_Page> createState() => _University_PageState();
}

class _University_PageState extends State<University_Page> {
  late Future<List<dynamic>> universitiesFuture;
  late Future<bool> hasEditUniversityPermissionFuture;
  late Future<bool> hasAddUniversityPermissionFuture;

  @override
  void initState() {
    super.initState();
    universitiesFuture = University.fetchUniversities();
    hasEditUniversityPermissionFuture =
        Permission.searchPermissionByCodename("change_university");
    hasAddUniversityPermissionFuture =
        Permission.searchPermissionByCodename("add_university");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('University Page',
            style: CustomTextStyles.headingStyle(fontSize: 22)),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: universitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final universities = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: universities.length,
                    itemBuilder: (context, index) {
                      final university = universities[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              university['name'],
                              style: CustomTextStyles.bodyStyle(fontSize: 17),
                            ),
                          ),
                          trailing: PermissionBasedIcon(
                              iconData: Icons.edit_square,
                              enabledColor: Color(
                                  0xffc19a6b), // Your desired enabled color
                              disabledColor: Colors.grey,
                              permissionFuture:
                                  hasEditUniversityPermissionFuture,
                              onPressed: () async {
                                var university =
                                    await University.getUniversityById(
                                        universities[index]['id']);
                                if (university != null) {
                                  University.id = university['id'];
                                  University.name = university['name'];
                                  University.vision = university['vision'];
                                  University.mission = university['mission'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<bool>(
                                      builder: (context) => Create_University(
                                        isUpdate: true,
                                        UniversityData: university,
                                      ),
                                    ),
                                  ).then((result) {
                                    if (result != null && result) {
                                      setState(() {
                                        universitiesFuture =
                                            University.fetchUniversities();
                                      });
                                    }
                                  });
                                }
                              }),
                          onTap: () async {
                            var university = await University.getUniversityById(
                                universities[index]['id']);
                            if (university != null) {
                              University.id = university['id'];
                              University.name = university['name'];
                              University.vision = university['vision'];
                              University.mission = university['mission'];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (context) => University_Profile(),
                                  )).then((result) {
                                if (result != null && result) {
                                  setState(() {
                                    universitiesFuture =
                                        University.fetchUniversities();
                                  });
                                }
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          PermissionBasedButton(
              buttonText: 'Add University',
              buttonWidth: 200,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Create_University(),
                  ),
                );
              },
              permissionFuture: hasAddUniversityPermissionFuture)
        ],
      ),
    );
  }
}
