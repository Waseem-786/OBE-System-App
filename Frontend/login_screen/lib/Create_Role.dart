import 'dart:async';
import 'dart:convert';
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
  const Create_Role({Key? key});

  @override
  State<Create_Role> createState() => _Create_Role_Page();
}

class _Create_Role_Page extends State<Create_Role> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  final TextEditingController Role_Controller = TextEditingController();

  List<int> _selectedUserIds = [];
  List<Map<String, dynamic>> _userOptions = [];

  List<int> _selectedPermissionIds = [];
  List<Map<String, dynamic>> _permissionOptions = [];

  @override
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

  Future<List<Map<String, dynamic>>> fetchUserNames() async {
    List<dynamic> users = [];

    if (User.isSuperUser) {
      users = await User.getAllUsers();
      print(users);
    } else if (User.isUniLevel()) {
      users = await User.getUsersByUniversityId(University.id);
    } else if (User.iscampusLevel()) {
      users = await User.getUsersByCampusId(Campus.id);
    } else if (User.isdeptLevel()) {
      users = await User.getUsersByDepartmentId(Department.id);
    }

    return users.map((user) => {'id': user['id'], 'username': user['username']}).toList();
  }

  Future<List<Map<String, dynamic>>> fetchPermissions() async {
    List<dynamic> permissions = await Permission.getUserPermissions(User.id);
    return permissions.map((permission) => {'id': permission['id'], 'name': permission['name']}).toList();
  }

  @override
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: MultiSelectField(
                  options: _userOptions,
                  selectedOptions: _selectedUserIds,
                  onSelectionChanged: (values) {
                    setState(() {
                      _selectedUserIds = values;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: MultiSelectField(
                  options: _permissionOptions,
                  selectedOptions: _selectedPermissionIds,
                  onSelectionChanged: (values) {
                    setState(() {
                      _selectedPermissionIds = values;
                    });
                  },
                  buttonText: Text('Add Permissions'),
                ),
              ),

              SizedBox(height: 20,),

              Custom_Button(
                onPressedFunction: () async {
                  String roleName = Role_Controller.text;
                  if (roleName.isEmpty) {
                    setState(() {
                      colorMessage = Colors.red;
                      errorColor = Colors.red;
                      errorMessage = 'Please enter all fields';
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    bool created = false;

                    if (User.isSuperUser) {
                      created = await Role.createTopLevelRole(roleName,
                          _selectedUserIds, _selectedPermissionIds);
                    } else if (User.isUniLevel()) {
                      created = await Role.createUniversityLevelRole(roleName, University.id, _selectedUserIds, _selectedPermissionIds);
                    } else if (User.iscampusLevel()) {
                      created = await Role.createCampusLevelRole(roleName,
                          Campus.id,_selectedUserIds,_selectedPermissionIds);
                    } else if (User.isdeptLevel()) {
                      created = await Role.createDepartmentLevelRole
                        (roleName, Department.id,_selectedUserIds,_selectedPermissionIds);
                    }

                    if (created) {
                      Role_Controller.clear();

                      setState(() {
                        _selectedUserIds = [];
                        _selectedPermissionIds = [];
                        isLoading = false;
                        colorMessage = Colors.green;
                        errorColor = Colors.black12; // Reset errorColor to default value
                        errorMessage = 'Role Created successfully';

                      });

                    }
                  }
                },
                ButtonWidth: 160,
                ButtonText: 'Create Role',
              ),
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
