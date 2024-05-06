
import 'package:flutter/material.dart';
import 'package:login_screen/Role.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Group_Users extends StatefulWidget {
  const Group_Users({super.key});

  @override
  State<Group_Users> createState() => _Group_UsersState();
}

class _Group_UsersState extends State<Group_Users> {

  late Future<List<dynamic>> userFuture;

  void initState() {
    super.initState();
    userFuture = Role.fetchUserbyGroupId(Role.group);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        userFuture = Role.fetchUserbyGroupId(Role.group);
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
            'Group Users Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final users = snapshot.data!;
                    return Expanded(
                        child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final firstName = user['first_name'];
                              final lastName = user['last_name'];
                              return Card(
                                color: Colors.white,
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      '$firstName $lastName',
                                      style: CustomTextStyles.bodyStyle(
                                          fontSize: 17),
                                    ),
                                  ),
                                  // onTap: () async {
                                  //   // call of a function to get the data of that course whose id is passed and id is
                                  //   // passed by tapping the user
                                  //   var objective = await CourseObjective.getObjectivebyObjectiveId(objectives[index]['id']);
                                  //   if (objective != null) {
                                  //
                                  //     CourseObjective.id=objective['id'];
                                  //     CourseObjective.description=objective['description'];
                                  //
                                  //
                                  //
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute<bool>(
                                  //           builder: (context) =>
                                  //               CourseObjectiveProfile(),
                                  //         )).then((result) {
                                  //       if (result != null && result) {
                                  //         // Set the state of the page here
                                  //         setState(() {
                                  //           objectiveFuture = CourseObjective.fetchObjectivesByCourseId(Course.id)
                                  //           ;
                                  //         });
                                  //       }
                                  //     });
                                  //   }
                                  // },
                                ),
                              );
                            }));
                  }
                }),
            // Center(
            //   child: Container(
            //     margin: const EdgeInsets.only(bottom: 20, top: 12),
            //     child: Custom_Button(
            //       onPressedFunction: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => CreateCourseObjective()),
            //         );
            //       },
            //       ButtonText: 'Add Objective',
            //       ButtonWidth: 200,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),


    );
  }
}