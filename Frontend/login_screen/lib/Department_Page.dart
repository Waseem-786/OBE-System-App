import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Create_Department.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Department_Profile.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Department_Page extends StatefulWidget{
  @override
  State<Department_Page> createState() => _Department_PageState();
}

class _Department_PageState extends State<Department_Page> {

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
          child: Text(
              'Department Page',style: CustomTextStyles.headingStyle(fontSize: 22)
          ),
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
                            child: Text(department['name'], style: CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),
                          onTap: () async {
                            var departmentData = await Department.getDepartmentById(departments[index]['id']);
                            if (departmentData != null) {
                              Department.id = departmentData['id'];
                              Department.name = departmentData['name'];
                              Department.mission = departmentData['mission'];
                              Department.vision = departmentData['vision'];
                              Department.campus_id = departmentData['campus'];
                              Department.campus_name = departmentData['campus_name'];
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
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, top: 12),
              child: Custom_Button(
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Create_Department()),
                  );
                },
                ButtonText: 'Add Department',
                ButtonWidth: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }

}