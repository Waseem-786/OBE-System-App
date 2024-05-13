import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Create_Department.dart';
import 'package:login_screen/Custom_Widgets/PermissionBasedButton.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Department_Profile.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/PermissionBasedIcon.dart';
import 'Permission.dart';

class Department_Page extends StatefulWidget {
  @override
  State<Department_Page> createState() => _Department_PageState();
}

class _Department_PageState extends State<Department_Page> {
  final int campus_id = Campus.id;
  late Future<List<dynamic>> departmentFuture;
  late Future<bool> hasEditDepartmentPermissionFuture;
  late Future<bool> hasAddDepartmentPermissionFuture;

  @override
  void initState() {
    super.initState();
    departmentFuture = Department.getDepartmentsbyCampusid(campus_id);
    hasAddDepartmentPermissionFuture =
        Permission.searchPermissionByCodename("add_department");
    hasEditDepartmentPermissionFuture =
        Permission.searchPermissionByCodename("change_department");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        departmentFuture = Department.getDepartmentsbyCampusid(campus_id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text('Department Page',
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
                          trailing: PermissionBasedIcon(
                            iconData: Icons.edit_square,
                            enabledColor:
                                Color(0xffc19a6b), // Your desired enabled color
                            disabledColor: Colors.grey,
                            permissionFuture: hasEditDepartmentPermissionFuture,
                            onPressed: () async {
                              var DeptData = await Department.getDepartmentById(
                                  departments[index]['id']);
                              if (DeptData != null) {
                                Department.id = DeptData['id'];
                                Department.name = DeptData['name'];
                                Department.mission = DeptData['mission'];
                                Department.vision = DeptData['vision'];
                                Department.campus_id = DeptData['campus'];
                                Department.campus_name =
                                    DeptData['campus_name'];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<bool>(
                                      builder: (context) => Create_Department(
                                        isUpdate: true,
                                        DeptData: DeptData,
                                      ),
                                    )).then((result) {
                                  if (result != null && result) {
                                    // Set the state of the page here
                                    setState(() {
                                      departmentFuture =
                                          Department.getDepartmentsbyCampusid(
                                              campus_id);
                                    });
                                  }
                                });
                                // Perform actions with campusData
                              }
                            },
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (context) => Department_Profile(),
                                  )).then((result) {
                                if (result != null && result) {
                                  // Set the state of the page here
                                  setState(() {
                                    departmentFuture = Department.getDepartmentsbyCampusid(campus_id);
                                  });
                                }
                              });
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
          PermissionBasedButton(
              buttonText: "Add Department",
              buttonWidth: 200,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Create_Department()),
                );
              },
              permissionFuture: hasAddDepartmentPermissionFuture),
        ],
      ),
    );
  }
}
