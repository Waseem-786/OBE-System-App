import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Campus_Page.dart';
import 'package:login_screen/Custom_Widgets/DetailCard.dart';
import 'package:login_screen/Permission.dart';
import 'package:login_screen/University.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DeleteAlert.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';

class University_Profile extends StatefulWidget {
  @override
  State<University_Profile> createState() => _UniversityProfileState();
}

class _UniversityProfileState extends State<University_Profile> {
  final university_id = University.id;  // Assuming University is a class with static members
  late Future<bool> hasDeleteUniversityPermissionFuture;
  late Future<bool> hasViewCampusPermissionFuture;

  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    hasDeleteUniversityPermissionFuture = Permission.searchPermissionByCodename("delete_university");
    hasViewCampusPermissionFuture = Permission.searchPermissionByCodename("view_campus");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('University Profile', style: CustomTextStyles.headingStyle(fontSize: 22)),
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
              Center(child: Text("University Details", style: CustomTextStyles.headingStyle())),
              const SizedBox(height: 20),
              ..._buildUniversityInfoCards(),
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

  List<Widget> _buildUniversityInfoCards() {
    return [
      DetailCard(label: "University Name", value: University.name, icon: Icons.school),
      DetailCard(label: "Mission", value: University.mission, icon: Icons.flag),
      DetailCard(label: "Vision", value: University.vision, icon: Icons.visibility),
    ];
  }


  Widget _actionButtons() {
    return Column(
      children: [
        PermissionBasedButton(
          buttonText: "Show Campuses",
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          buttonWidth: 190,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Campus_Page())),
          permissionFuture: hasViewCampusPermissionFuture,
        ),
        SizedBox(height: 20),
        PermissionBasedButton(
          buttonText: "Delete",
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          buttonWidth: 120,
          onPressed: () => _confirmDelete(context),
          permissionFuture: hasDeleteUniversityPermissionFuture,
        ),
      ],
    );
  }


  Future<void> _confirmDelete(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: "Confirm Deletion",
        content: "Are you sure you want to delete this university?",
        onConfirm: () => University.deleteUniversity(university_id), // Call University.deleteUniversity on confirmation
      ),
    );
    if (confirmDelete) {
      setState(() => isLoading = true);
      bool deleted = await University.deleteUniversity(university_id);
      if (deleted) {
        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorMessage = 'University deleted successfully';
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to delete university';
        });
      }
    }
  }
}
