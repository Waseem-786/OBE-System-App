// import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/User_Profile.dart';
import 'package:login_screen/User_Registration.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class User_Management extends StatefulWidget {
  @override
  State<User_Management> createState() => User_Management_State();
}

class User_Management_State extends State<User_Management> {
  // for Encryption purpose
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  @override
  void initState() {
    super.initState();
    storage.read(key: "access_token").then((accessToken) {
      // show the users of that person(authority) who is logged in
      getUsers(
          accessToken!); // pass the token of that user who is logged in to show the users which are authorized to show
      //to that account who is logged in
    });
  }

  // variable to store the data after making a get request
  var responseData;

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


  // function to get the users from the server by passing token of the user who is logged in
  Future<void> getUsers(String accessToken) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.112:8000/api/users'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print("response.body");
    if (response.statusCode == 200) {
      print("Success");

      // all the data of the users is stored in responseData
      responseData = jsonDecode(response.body);
      // Handle the response data
      print(responseData);
    } else {
      throw Exception('Failed to load users');
    }
  }

  String _selectedOption = '';

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
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert),
        //     iconSize: 25,
        //     onPressed: () {},
        //   ),
        // ],

        // actions: [
        //   PopupMenuButton<String>(
        //     icon: Icon(Icons.more_vert),
        //     onSelected: (String result) {
        //
        //       if(result=='add'){
        //         Navigator.push(context, MaterialPageRoute(builder: (context)=>User_Registration()));
        //       }
        //       setState(() {
        //         _selectedOption = result;
        //       });
        //     },
        //     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //       PopupMenuItem<String>(
        //         value: 'add',
        //         child: Text('Add'),
        //       ),
        //       // PopupMenuItem<String>(
        //       //   value: 'update',
        //       //   child: Text('Update'),
        //       // ),
        //       // Add more PopupMenuItems for other options as needed
        //     ],
        //   ),
        // ],
      ),

      // The users will be shown in the List view builder by getting them from the server so it will work asynchronously
      // and  there could be a timing issue where the UI is built before responseData is populated with the actual data.
      // so the Future builder is used
      body: FutureBuilder(
        future: storage
            .read(key: "access_token")
            .then((accessToken) => getUsers(accessToken!)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {

            // the UI will start from here when the users are loaded from the server
            return Column(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  height: 650,
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
            );
          }
        },
      ),
    );
  }
}
