
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
