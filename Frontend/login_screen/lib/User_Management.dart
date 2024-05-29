import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/SelectedUser.dart';
import 'package:login_screen/University.dart';
import 'package:login_screen/User_Profile.dart';
import 'package:login_screen/User_Registration.dart';
import 'Campus.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Department.dart';
import 'User.dart';

class User_Management extends StatefulWidget {
  @override
  State<User_Management> createState() => User_Management_State();
}

class User_Management_State extends State<User_Management> {
  // Variable to store the future data
  late Future<List<dynamic>> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _getUsers();  // Fetch data on initialization
  }

  Future<List<dynamic>> _getUsers() async {
    if (User.isSuperUser) {
      return await User.getAllUsers();
    } else if (User.isUniLevel()) {
      return await User.getUsersByUniversityId(University.id);
    } else if (User.iscampusLevel()) {
      return await User.getUsersByCampusId(Campus.id);
    } else if (User.isdeptLevel()) {
      return await User.getUsersByDepartmentId(Department.id);
    } else {
      return [];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        userFuture = _getUsers();
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
            'User Management',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: FutureBuilder<List>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;

            // The UI will start from here when the users are loaded from the server
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.grey.shade200,
                    height: 670,
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            child: SizedBox(
                              height: 100,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset("assets/images/sd.jpg"),
                                  ),
                                ),
                                trailing: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Icon(Icons.edit_square),
                                ),
                                title: Text(
                                  users[index]['username'],
                                  style:
                                  CustomTextStyles.headingStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  'User ID: ${users[index]['id']}',
                                  style: CustomTextStyles.bodyStyle(),
                                ),
                                onTap: () {
                                  // Get the data of that user whose email is passed and email is passed by tapping the user
                                  var user = users[index];
                                  if (user != null) {
                                    SelectedUser.id = user['id'];
                                    SelectedUser.firstName = user['first_name'];
                                    SelectedUser.lastName = user['last_name'];
                                    SelectedUser.username = user['username'];
                                    SelectedUser.email = user['email'];
                                    SelectedUser.isSuperUser = user['is_superuser'];
                                    SelectedUser.universityid = user['university'] ?? '';
                                    SelectedUser.campusid = user['campus'] ?? '';
                                    SelectedUser.departmentid = user['department'] ?? '';
                                    SelectedUser.universityName = user['university_name'] ?? '';
                                    SelectedUser.campusName = user['campus_name'] ?? '';
                                    SelectedUser.departmentName = user['department_name'] ?? '';

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<bool>(
                                        builder: (context) => User_Profile(),
                                      ),
                                    ).then((result) {
                                      if (result != null && result) {
                                        // Refresh the user list if a change occurred
                                        setState(() {
                                          userFuture = _getUsers();
                                        });
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Custom_Button(
                    onPressedFunction: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => User_Registration()));
                    },
                    ButtonText: 'Add User',
                    ButtonWidth: 140,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
