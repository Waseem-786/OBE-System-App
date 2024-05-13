import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/BatchPage.dart';
import 'package:login_screen/Custom_Widgets/DetailCard.dart';
import 'package:login_screen/Permission.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DeleteAlert.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';
import 'Department.dart';

class Department_Profile extends StatefulWidget {
  @override
  State<Department_Profile> createState() => _Department_ProfileState();
}

class _Department_ProfileState extends State<Department_Profile> {
  String? errorMessage;
 //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
 // color of the message when the error occurs
  var isLoading = false;
 // variable for use the functionality of loading while request is processed to server
  final departmentId = Department.id;

  late Future<bool> hasDeleteDepartmentPermissionFuture;
  late Future<bool> hasViewBatchPermissionFuture;

  @override
  void initState() {
    super.initState();
    hasDeleteDepartmentPermissionFuture = Permission.searchPermissionByCodename("delete_department");
    hasViewBatchPermissionFuture = Permission.searchPermissionByCodename("view_batch");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
          title: Text('Department Profile', style: CustomTextStyles.headingStyle(fontSize: 22)),
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
              Center(child: Text("Campus Details", style: CustomTextStyles.headingStyle())),
              const SizedBox(height: 20),
              ..._buildDepartmentInfoCards(),
              SizedBox(height: 20),
              Center(child: _actionButtons()),
              Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(),
              ),
              if (errorMessage != null)
                Text(errorMessage!, style: CustomTextStyles.bodyStyle(color: colorMessage)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDepartmentInfoCards() {
    return [
      DetailCard(label: "Department Name",value: Department.name, icon: Icons.school),
      DetailCard(label: "Department Mission",value: Department.mission, icon: Icons.flag),
      DetailCard(label: "Department Vision",value: Department.vision, icon: Icons.visibility),
    ];
  }

  Widget _actionButtons() {
    return Column(
      children: [
        PermissionBasedButton(
            buttonText: "Show Batches",
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            buttonWidth: 170,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BatchPage())),
            permissionFuture: hasViewBatchPermissionFuture
        ),
        SizedBox(height: 20),
        PermissionBasedButton(
          buttonText: "Delete",
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          buttonWidth: 120,
          onPressed: () => _confirmDelete(context),
          permissionFuture: hasDeleteDepartmentPermissionFuture,
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: "Confirm Deletion",
        content: "Are you sure you want to delete this campus?",
        onConfirm: () => Department.deleteDepartment(departmentId), // Call University.deleteUniversity on confirmation
      ),
    );

    if (confirmDelete) {
      setState(() => isLoading = true);
      bool deleted = await Department.deleteDepartment(departmentId);
      if (deleted) {
        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorMessage = 'Department deleted successfully';
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to delete department';
        });
      }
    }
  }

}
