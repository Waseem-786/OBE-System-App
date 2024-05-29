
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Role.dart';
import 'package:login_screen/SelectedUser.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';
import 'RoleProfile.dart';
import 'User.dart';

class Specific_Role_Page extends StatefulWidget {
  const Specific_Role_Page({super.key});

  @override
  State<Specific_Role_Page> createState() => _Specific_Role_PageState();
}



class _Specific_Role_PageState extends State<Specific_Role_Page> {


  late Future<List<dynamic>> roleFuture;

  void initState() {
    super.initState();
    roleFuture=Role.getUserGroups(SelectedUser.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        roleFuture=Role.getUserGroups(SelectedUser.id);
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
            'Specific Roles Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),

      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: roleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
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
                            child: Text(role['group_name'],
                                style:
                                CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),

                          onTap: () async {
                            // Ensure batches[index]['id'] is not null before proceeding
                            if (roles[index]['id'] != null) {
                              // Call getBatchbyBatchId only if id is not null
                              var role = await Role.getRolebyRoleId(roles[index]['id']);
                              if (role != null) {

                                Role.id=role['id'];
                                if(User.isUniLevel()){
                                  Role.university_id=role['university'];
                                  Role.university_name=role['university_name'];
                                }
                                if(User.iscampusLevel()){
                                  Role.university_id=role['university'];
                                  Role.university_name=role['university_name'];
                                  Role.campus_id=role['campus'];
                                  Role.campus_name=role['campus_name'];
                                }
                                if(User.isdeptLevel()){
                                  Role.university_id=role['university'];
                                  Role.university_name=role['university_name'];
                                  Role.campus_id=role['campus'];
                                  Role.campus_name=role['campus_name'];
                                  Role.department_id=role['department'];
                                  Role.department_name=role['department_name'];
                                }
                                Role.name=role['group_name'];
                                Role.user=role['user'];
                                Role.group_permissions=role['group_permissions'];


                                Navigator.push(
                                  context,
                                  MaterialPageRoute<bool>(
                                    builder: (context) => RoleProfile(),
                                  ),
                                ).then((result) {
                                  if (result != null && result) {
                                    // Set the state of the page here
                                    setState(() {
                                      // roleFuture = Role.fetchTopLevelRoles();
                                      roleFuture=Role.getUserGroups(SelectedUser.id);
                                      // roleFuture=Role.fetchUniLevelRoles(University.id);
                                    });
                                  }
                                });
                              }
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
