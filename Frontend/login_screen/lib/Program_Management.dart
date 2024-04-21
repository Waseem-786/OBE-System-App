import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Department_CLO_PLO.dart';
import 'package:login_screen/Show_PEO.dart';
import 'package:login_screen/Show_PLO.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Program_Management extends StatelessWidget {
  final int campus_id = Campus.id;
  // print(campus_id);
  var DepartmentFuture = Department.getDepartmentsbyCampusid(1);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffc19a6b),
          title: Container(
            margin: EdgeInsets.only(left: 30),
            child: Text(
              'Program Management',
              style: CustomTextStyles.headingStyle(fontSize: 20),
            ),
          ),
        ),

      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: DepartmentFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
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
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(department['name'], style: CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),
                          onTap: ()  {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Department_CLO_PLO()
                                  ));

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
