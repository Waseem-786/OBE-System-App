// import 'dart:ffi';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'User_Registration.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class User_Management extends StatefulWidget{
  @override
  State<User_Management> createState() => User_Management_State();
}
class User_Management_State extends State<User_Management>{

  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  @override
  void initState() {
    super.initState();
    storage.read(key: "access_token").then((accessToken) {
      getUsers(accessToken!);
    });
  }

  Future<void> getUsers(String accessToken) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.112:8000/auth/users/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
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
          child: Text('User Management',style: CustomTextStyles.headingStyle
            (fontSize: 20),),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert),
        //     iconSize: 25,
        //     onPressed: () {},
        //   ),
        // ],


        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String result) {

              if(result=='add'){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>User_Registration()));
              }
              setState(() {
                _selectedOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'add',
                child: Text('Add'),
              ),
              // PopupMenuItem<String>(
              //   value: 'update',
              //   child: Text('Update'),
              // ),
              // Add more PopupMenuItems for other options as needed
            ],
          ),
        ],

      ),

      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: 5, // Assuming there are 10 users,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,
                  vertical: 5.0),
              child: Card(
                // margin: EdgeInsets.only(top: 20),
                color: Colors.white,
                elevation: 3,
                child: Container(
                  height: 100,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10,
                        horizontal: 10),
                    leading: CircleAvatar(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          "assets/images/sd.jpg",
                        ),
                      ),
                      radius: 30,
                    ),


                    title: Text(
                      'User Name',
                      style: CustomTextStyles.headingStyle(fontSize: 20),

                      // style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('User ID: ABC123',style: CustomTextStyles.bodyStyle(),),
                    onTap: () {
                      // Handle tap on user tile
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),


    );

  }
}