import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/BatchPage.dart';
import 'package:login_screen/Custom_Widgets/DetailCard.dart';
import 'package:login_screen/Permission.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DeleteAlert.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';
import 'Department.dart';
import 'SelectedUser.dart';
import 'User.dart';

class User_Profile extends StatefulWidget {
  @override
  State<User_Profile> createState() => _User_ProfileState();
}

class _User_ProfileState extends State<User_Profile> {
  String? errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;

  late Future<bool> hasDeleteUserPermissionFuture;
  late Future<bool> hasViewGroupPermissionFuture;

  @override
  void initState() {
    super.initState();
    hasDeleteUserPermissionFuture = Permission.searchPermissionByCodename
      ("delete_customuser");
    hasViewGroupPermissionFuture = Permission.searchPermissionByCodename
      ("view_customgroup");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('User Profile', style: CustomTextStyles.headingStyle
          (fontSize: 22)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade200,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text("User Details", style: CustomTextStyles
                  .headingStyle())),
              const SizedBox(height: 20),
              ..._buildUserInfoCards(),
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

  List<Widget> _buildUserInfoCards() {

    if(SelectedUser.isSuperUser){
      return [
        DetailCard(label: "First Name", value: SelectedUser.firstName, icon:
        Icons.account_circle),
        DetailCard(label: "Last Name", value: SelectedUser.lastName, icon:
        Icons.account_circle,),
        DetailCard(label: "Username", value: SelectedUser.username, icon: Icons
            .verified_user),
        DetailCard(label: "Email", value: SelectedUser.email, icon: Icons.email),
      ];

    }
    else if(SelectedUser.isUniLevel()){

      return [
        DetailCard(label: "First Name", value: SelectedUser.firstName, icon:
        Icons.account_circle),
        DetailCard(label: "Last Name", value: SelectedUser.lastName, icon:
        Icons.account_circle,),
        DetailCard(label: "Username", value: SelectedUser.username, icon: Icons
            .verified_user),
        DetailCard(label: "Email", value: SelectedUser.email, icon: Icons.email),

        DetailCard(label: "University", value: SelectedUser.universityName,
            icon: Icons.school),
      ];
    }
    else if(SelectedUser.iscampusLevel()){

      return [

        DetailCard(label: "First Name", value: SelectedUser.firstName, icon:
        Icons.account_circle),
        DetailCard(label: "Last Name", value: SelectedUser.lastName, icon:
        Icons.account_circle,),
        DetailCard(label: "Username", value: SelectedUser.username, icon: Icons
            .verified_user),
        DetailCard(label: "Email", value: SelectedUser.email, icon: Icons.email),
        DetailCard(label: "University", value: SelectedUser.universityName,
            icon: Icons.school),
        DetailCard(label: "Campus", value: SelectedUser.campusName,icon: Icons.school),

      ];

    }
    else{

      return [
        DetailCard(label: "First Name", value: SelectedUser.firstName, icon:
        Icons.account_circle),
        DetailCard(label: "Last Name", value: SelectedUser.lastName, icon:
        Icons.account_circle,),
        DetailCard(label: "Username", value: SelectedUser.username, icon: Icons
            .verified_user),
        DetailCard(label: "Email", value: SelectedUser.email, icon: Icons.email),
        DetailCard(label: "University", value: SelectedUser.universityName,
            icon: Icons.school),
        DetailCard(label: "Campus", value: SelectedUser.campusName,icon: Icons.school),
        DetailCard(label: "Department", value: SelectedUser.departmentName,icon: Icons
            .school),

      ];
    }
  }

  Widget _actionButtons() {
    return Column(
      children: [
        PermissionBasedButton(
            buttonText: "Show Groups",
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            buttonWidth: 170,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BatchPage())),
            permissionFuture: hasViewGroupPermissionFuture
        ),
        SizedBox(height: 20),
        PermissionBasedButton(
          buttonText: "Delete",
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          buttonWidth: 120,
          onPressed: () => _confirmDelete(context),
          permissionFuture: hasDeleteUserPermissionFuture,
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: "Confirm Deletion",
        content: "Are you sure you want to delete this user?",
      ),
    );

    if (confirmDelete) {
      setState(() => isLoading = true);
      bool deleted = await User.deleteUser(SelectedUser.id);
      if (deleted) {
        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorMessage = 'User deleted successfully';
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to delete User';
        });
      }
    }
  }

}