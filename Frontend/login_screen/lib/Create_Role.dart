import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Permission.dart';
import 'package:login_screen/University.dart';
import 'package:login_screen/User.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Multi_Select_Field.dart';
import 'Role.dart';

class Create_Role extends StatefulWidget {
  const Create_Role({super.key});

  @override
  State<Create_Role> createState() => _Create_Role_Page();
}

class _Create_Role_Page extends State<Create_Role> {

  String?errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors.black12;
  // color of border of text fields when the error is not occurred

  final TextEditingController Role_Controller = TextEditingController();

  List<String> _selectedUsers = [];
  List<String> _userOptions = [];

  List<String> _selectedPermissions = [];
  List<String> _permissionOptions = [];

  void initState() {
    super.initState();
    fetchUserNames().then((userNames) {
      setState(() {
        _userOptions = userNames;
      });
    }).catchError((error) {
      setState(() {
        errorMessage = 'Failed to load user names: $error';
      });
    });

    fetchPermissions().then((permissions) {
      setState(() {
        _permissionOptions = permissions;
      });
    }).catchError((error) {
      setState(() {
        errorMessage = 'Failed to load permissions: $error';
      });
    });
  }



  Future<List<String>> fetchUserNames() async {
    List<dynamic> users = await User.getUsersByUniversityId(University.id);
    return users.map((user) => user['username'].toString()).toList();
  }

  Future<List<String>> fetchPermissions() async {
    List<dynamic> permissions = await Permission.getAllPermissions();
    return permissions.map((permission) => permission['name'].toString())
        .toList();
  }



  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          margin: const EdgeInsets.only(left: 90),
          child: Text(
            "Create Role",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(

        child: Container(
          margin: EdgeInsets.only(top: 100),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              CustomTextFormField(controller: Role_Controller,
                hintText: 'Enter Role here e.g. Dean',
                label: 'Enter Role',
              ),
              const SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: MultiSelectField(
                  options: _userOptions,
                  selectedOptions: _selectedUsers,
                  onSelectionChanged: (values) {
                    setState(() {
                      _selectedUsers = values;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: MultiSelectField(
                  
                  options: _permissionOptions,
                  selectedOptions: _selectedPermissions,
                  onSelectionChanged: (values) {
                    setState(() {
                      _selectedPermissions = values;
                    });
                  },
                  buttonText: Text('Add Permissions'),
                ),
              ),

              SizedBox(height: 20,),


              Custom_Button(
                onPressedFunction: () async {
                  String RoleName = Role_Controller.text;
                  if (RoleName.isEmpty) {
                    setState(() {
                      colorMessage = Colors.red;
                      errorColor = Colors.red;
                      errorMessage = 'Please enter all fields';
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    bool created=false;

                    if(User.isSuperUser){
                      created = await Role.createTopLevelRole(RoleName);
                    }
                    else if(User.isUniLevel()){
                      created= await Role.createUniversityLevelRole(RoleName,
                          University.id);
                    }
                    else if(User.iscampusLevel()){
                      created=await Role.createCampusLevelRole(RoleName, Campus.id);
                    }
                    else if(User.isdeptLevel()){
                      created= await Role.createDepartmentLevelRole(RoleName, Department.id);
                    }


                    if (created) {
                      Role_Controller.clear();

                      setState(() {
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorColor =
                            Colors.black12; // Reset errorColor to default value
                        errorMessage = 'Role Created successfully';
                      });
                    }
                  }
                },
                ButtonWidth: 160,
                ButtonText: 'Create Role',),
              const SizedBox(height: 20),
              Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(),
              ),
              errorMessage != null
                  ? Text(
                errorMessage!,
                style: CustomTextStyles.bodyStyle(color: colorMessage),
              )
                  : const SizedBox(),
            ],
          ),
        ),
      ),


    );


  }
}