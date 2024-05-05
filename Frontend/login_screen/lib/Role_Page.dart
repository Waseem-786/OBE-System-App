
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Role.dart';
import 'package:login_screen/SectionPage.dart';
import 'package:login_screen/University.dart';
import 'CreateBatch.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Role_Page extends StatefulWidget {
  const Role_Page({super.key});

  @override
  State<Role_Page> createState() => _Role_PageState();
}

class _Role_PageState extends State<Role_Page> {

  late Future<List<dynamic>> roleFuture;

  @override
  void initState() {
    super.initState();
    roleFuture = Role.fetchTopLevelRoles();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        roleFuture = Role.fetchTopLevelRoles();
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Role Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: roleFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final roles = snapshot.data!;
                    return Expanded(
                        child: ListView.builder(
                            itemCount: roles.length,
                            itemBuilder: (context, index) {
                              final role = roles[index];
                              return Card(
                                color: Colors.white,
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      role['group_name'],
                                      style: CustomTextStyles.bodyStyle(
                                          fontSize: 17),
                                    ),
                                  ),
                                  onTap: () async {
                                    // Ensure batches[index]['id'] is not null before proceeding
                                    if (roles[index]['id'] != null) {
                                      // Call getBatchbyBatchId only if id is not null
                                      var role = await Role.getRolebyRoleId(roles[index]['id']);

                                      if (role != null) {

                                        Role.id=role['id'];
                                        Role.university_id=role['university'];
                                        Role.university_name=role['university_name'];
                                        Role.campus_id=role['campus'];
                                        Role.campus_name=role['campus_name'];
                                        Role.department_id=role['department'];
                                        Role.department_name=role['department_name'];
                                        Role.group=role['group'];
                                        Role.name=role['group_name'];
                                        Role.user=role['user'];
                                        Role.group_permissions=role['group_permissions'];


                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<bool>(
                                            builder: (context) => (),
                                          ),
                                        ).then((result) {
                                          if (result != null && result) {
                                            // Set the state of the page here
                                            setState(() {
                                              roleFuture = Role.fetchTopLevelRoles();

                                            });
                                          }
                                        });
                                      }
                                    }
                                  },

                                ),
                              );
                            }));
                  }
                }),
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 12),
                child: Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateBatch()),
                    );
                  },
                  ButtonText: 'Add Batch',
                  ButtonWidth: 200,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
