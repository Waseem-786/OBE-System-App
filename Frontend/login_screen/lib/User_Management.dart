import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/User_Profile.dart';
import 'package:login_screen/User_Registration.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'User.dart';

class User_Management extends StatefulWidget {
  @override
  State<User_Management> createState() => User_Management_State();
}

class User_Management_State extends State<User_Management> {
  // variable to store the data after making a get request
  var responseData;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getAllUsers() async {
    responseData = await User.getAllUsers();
  }



  // function to get user's data by passing email
  Map<String, dynamic>? getUserByEmail(String email) {
    if (responseData != null) {
      for (var user in responseData) {
        // assume user = responseData[user] and "user" is the index so user = responseData[0] and so on until all users.
        // It will check all the users in the responseData and return the user whose email matches
        if (user['email'] == email) {
          return user;
        }
      }
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Center(
          child: Text(
            'User Management',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),

      ),

      // The users will be shown in the List view builder by getting them from the server so it will work asynchronously
      // and  there could be a timing issue where the UI is built before responseData is populated with the actual data.
      // so the Future builder is used
      body: FutureBuilder(
        future: _getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {

            // the UI will start from here when the users are loaded from the server
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.grey.shade200,
                    height: 670,
                    child: ListView.builder(
                      itemCount: responseData != null ? responseData.length : 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            child: Container(
                              height: 100,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                leading: CircleAvatar(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset("assets/images/sd.jpg"),
                                  ),
                                  radius: 30,
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Icon(Icons.edit_square),
                                ),
                                title: Text(
                                  responseData[index]['username'],
                                  style:
                                      CustomTextStyles.headingStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  'User ID: ${responseData[index]['id']}',
                                  style: CustomTextStyles.bodyStyle(),
                                ),
                                onTap: () {
                                  // call of a function to get the data of that user whose email is passed and email is
                                  // passed by tapping the user
                                  var user = getUserByEmail(
                                      responseData[index]['email']);
                                  if (user != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              User_Profile(user_data: user)),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Custom_Button(
                    onPressedFunction: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => User_Registration()));
                    },
                    ButtonText: 'Add',
                    ButtonWidth: 100,
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
