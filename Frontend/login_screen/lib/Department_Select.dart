import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Department.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Department_Select extends StatefulWidget {
  @override
  State<Department_Select> createState() => _Department_SelectState();
}

class _Department_SelectState extends State<Department_Select> {
  final int campus_id = Campus.id;
  late Future<List<dynamic>> departmentFuture;

  @override
  void initState() {
    super.initState();
    departmentFuture = Department.getDepartmentsbyCampusid(campus_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text('Department Select Page',
              style: CustomTextStyles.headingStyle(fontSize: 22)),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: departmentFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final departments = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: departments.length,
                    itemBuilder: (context, index) {
                      final department = departments[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(department['name'],
                                style:
                                CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),
                          onTap: () async {
                            var departmentData =
                            await Department.getDepartmentById(
                                departments[index]['id']);
                            if (departmentData != null) {
                              Department.id = departmentData['id'];
                              Department.name = departmentData['name'];
                              Department.mission = departmentData['mission'];
                              Department.vision = departmentData['vision'];
                              Department.campus_id = departmentData['campus'];
                              Department.campus_name =
                              departmentData['campus_name'];
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Department_Select()));
                              // Perform actions with campusData
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
        ],
      ),
    );
  }
}
