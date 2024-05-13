import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Department_Page.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DeleteAlert.dart';
import 'Custom_Widgets/DetailCard.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';
import 'Permission.dart';

class Campus_Profile extends StatefulWidget {
  @override
  State<Campus_Profile> createState() => _Campus_ProfileState();
}

class _Campus_ProfileState extends State<Campus_Profile> {
  final campus_id = Campus.id;
  String? errorMessage; //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading = false; // variable for use the functionality of loading while request is processed to server

  late Future<bool> hasDeleteCampusPermissionFuture;
  late Future<bool> hasViewDepartmentPermissionFuture;

  @override
  void initState() {
    super.initState();
    hasDeleteCampusPermissionFuture = Permission.searchPermissionByCodename("delete_campus");
    hasViewDepartmentPermissionFuture = Permission.searchPermissionByCodename("view_department");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('Campus Profile', style: CustomTextStyles.headingStyle(fontSize: 22)),
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
              ..._buildCampusInfoCards(),
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

  List<Widget> _buildCampusInfoCards() {
    return [
      DetailCard(label: "Campus Name", value: Campus.name, icon: Icons.school),
      DetailCard(label: "Campus Mission", value: Campus.mission, icon: Icons.flag),
      DetailCard(label: "Campus Vision", value: Campus.vision, icon: Icons.visibility),
    ];
  }

  Widget _actionButtons() {
    return Column(
      children: [
        PermissionBasedButton(
          buttonText: "Show Departments",
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          buttonWidth: 220,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Department_Page())),
          permissionFuture: hasViewDepartmentPermissionFuture,
        ),
        SizedBox(height: 20),
        PermissionBasedButton(
          buttonText: "Delete",
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          buttonWidth: 120,
          onPressed: () => _confirmDelete(context),
          permissionFuture: hasDeleteCampusPermissionFuture,
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
        onConfirm: () => Campus.deleteCampus(campus_id), // Call University.deleteUniversity on confirmation
      ),
    );

    if (confirmDelete) {
      setState(() => isLoading = true);
      bool deleted = await Campus.deleteCampus(campus_id);
      if (deleted) {
        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorMessage = 'Campus deleted successfully';
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to delete campus';
        });
      }
    }
  }
}
