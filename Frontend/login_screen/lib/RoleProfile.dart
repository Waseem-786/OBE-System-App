import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:login_screen/Add_Group_User.dart';
import 'package:login_screen/Custom_Widgets/DetailCard.dart';
import 'package:login_screen/Group_Dashboard.dart';
import 'package:login_screen/Group_Permissions.dart';
import 'package:login_screen/Group_Users.dart';
import 'package:login_screen/Role.dart';

import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DeleteAlert.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';
import 'Permission.dart';
import 'User.dart';
class RoleProfile extends StatefulWidget {

  @override
  State<RoleProfile> createState() => _RoleProfileState();
}

class _RoleProfileState extends State<RoleProfile> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server
  late Future<bool> hasViewUsersPermissionFuture;
  late Future<bool> hasViewPermissionsPermissionFuture;
  late Future<bool> hasAddUsersPermissionFuture;
  late Future<bool> hasAddPermissionsPermissionFuture;
  late Future<bool> hasDeleteRolePermissionFuture;

  @override
  void initState() {
    super.initState();
    hasViewUsersPermissionFuture = Permission.searchPermissionByCodename
      ("view_customuser");
    hasViewPermissionsPermissionFuture = Permission
        .searchPermissionByCodename("view_permission");
    hasAddUsersPermissionFuture = Permission.searchPermissionByCodename
      ("add_customuser");
    hasAddPermissionsPermissionFuture = Permission.searchPermissionByCodename
      ("add_permission");
    hasDeleteRolePermissionFuture = Permission.searchPermissionByCodename
      ("delete_customgroup");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
            child: Text('Role Profile',
                style: CustomTextStyles.headingStyle(fontSize: 22))),
      ),
      body: Container(
        color: Colors.grey.shade200,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text("Role Details", style: CustomTextStyles.headingStyle())),
              const SizedBox(height: 20),
              ..._buildRoleInfoCards(),
              SizedBox(height: 20),
              Center(child: _actionButtons()),
              SizedBox(height: 10),
              Center(
                child: Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(),
                ),
              ),
              if (errorMessage != null)
                Center(
                  child: Text(errorMessage!,
                      style: CustomTextStyles.bodyStyle(color: colorMessage)),
                ),
            ],
          ),
        ),
      ),
    );

  }

  List<Widget> _buildRoleInfoCards() {
    if(User.isUniLevel()){
      return [
        DetailCard(label: "Role Name", value: Role.name, icon: Icons.group),
        DetailCard(label: "University Name",value: Role.university_name,
          icon: Icons.school),
      ];

    }
    else if(User.iscampusLevel()){
      return [
        DetailCard(label: "Role Name", value: Role.name, icon: Icons.group),
        DetailCard(label: "University Name",value: Role.university_name,
            icon: Icons.school),
        DetailCard(label: "Campus Name", value: Role.campus_name,
            icon: Icons.school),
      ];
    }
    else if(User.isdeptLevel()){
      return [
        DetailCard(label: "Role Name", value: Role.name, icon: Icons.group),
        DetailCard(label: "University Name",value: Role.university_name,
            icon: Icons.school),
        DetailCard(label: "Campus Name", value: Role.campus_name,
            icon: Icons.school),
        DetailCard(label: "Department Name", value: Role
            .department_name, icon: Icons.school),
      ];
    }
    return [
      DetailCard(label: "Role Name", value: Role.name, icon: Icons.group),
    ];
  }

  Widget _actionButtons() {
    return Column(
      children: [

        Custom_Button(onPressedFunction: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Group_Dashboard()));
        },
          ButtonText: 'Group Dashboard',
          ButtonWidth: 210,



        ),

        SizedBox(height: 20),
        PermissionBasedButton(
          buttonText: "Delete",
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          buttonWidth: 120,
          onPressed: () => _confirmDelete(context),
          permissionFuture: hasDeleteRolePermissionFuture,
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: "Confirm Deletion",
        content: "Are you sure you want to delete this role?",
      ),
    );
    if (confirmDelete) {
      setState(() => isLoading = true);
      bool deleted = await Role.deleteRole(Role.id);
      if (deleted) {
        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorMessage = 'Role deleted successfully';
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to delete role';
        });
      }
    }
  }

}