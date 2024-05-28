
import 'package:flutter/material.dart';
import 'package:login_screen/Role.dart';
import 'package:login_screen/User_Profile.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';
import 'User.dart';

class Group_Users extends StatefulWidget {
  const Group_Users({super.key});

  @override
  State<Group_Users> createState() => _Group_UsersState();
}

class _Group_UsersState extends State<Group_Users> {

  late Future<List<dynamic>> userFuture;

  void initState() {
    super.initState();
    userFuture = User.fetchUserbyGroupId(Role.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        userFuture = User.fetchUserbyGroupId(Role.id);
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
                                  onTap: () async {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>User_Profile(user_data: user)));
                                  },
                                ),
                              );
                            }));
                  }
                }),
          ],
        ),
      ),


    );
  }
}
