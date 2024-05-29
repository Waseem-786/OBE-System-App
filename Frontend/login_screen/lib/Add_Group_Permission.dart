
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Role.dart';

import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/Multi_Select_Field.dart';
import 'Permission.dart';
import 'User.dart';

class Add_Group_Permissions extends StatefulWidget {
  const Add_Group_Permissions({super.key});

  @override
  State<Add_Group_Permissions> createState() => _Add_Group_PermissionsState();
}

class _Add_Group_PermissionsState extends State<Add_Group_Permissions> {

  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  List<int> _selectedPermissionIds = [];
  List<Map<String, dynamic>> _permissionOptions = [];

  @override
  void initState() {
    super.initState();

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

  Future<List<Map<String, dynamic>>> fetchPermissions() async {
    List<dynamic> permissions = await Permission.getUserPermissions(User.id);
    return permissions.map((permission) => {'id': permission['id'], 'name': permission['name']}).toList();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Add Group Permissions',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
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
                title: Text('Select Permissions'),
              ),
            ),
            SizedBox(height: 10,),
            Custom_Button(
              onPressedFunction: () async {
                List<int> selectedPermissionIds = _selectedPermissionIds;

                if (selectedPermissionIds.isEmpty) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please Select at least one Permission';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });

                  bool created = await Permission.addPermissionsToGroup(Role
                      .id, selectedPermissionIds);


                  setState(() {
                    isLoading = false;
                    if (created) {
                      _selectedPermissionIds = [];
                      colorMessage = Colors.green;
                      errorMessage = 'Permission Added successfully';
                    } else {
                      colorMessage = Colors.red;
                      errorMessage = 'Failed to add Permissions';
                    }
                  });
                }
              },
              ButtonWidth: 210,
              ButtonText: 'Add Permissions',

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



    );
  }
}

