import 'package:flutter/material.dart';

import 'Department.dart';
import 'University.dart';
import 'Campus.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DropDown.dart';
import 'User.dart';

class User_Registration extends StatefulWidget {
  @override
  State<User_Registration> createState() => _User_RegistrationState();
}

class _User_RegistrationState extends State<User_Registration> {
  bool universitySelected = false;
  bool campusSelected = false;
  bool departmentSelected = false;

  String? errorMessage;
  Color messageColor = Colors.red;
  var isLoading = false;
  Color borderColor = Colors.black12;

  final TextEditingController FirstNameController = TextEditingController();
  final TextEditingController LastNameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final TextEditingController ConfirmPasswordController = TextEditingController();
  final TextEditingController UserName = TextEditingController();
  final TextEditingController UniversityController = TextEditingController();
  final TextEditingController CampusController = TextEditingController();
  final TextEditingController RoleController = TextEditingController();
  final TextEditingController DepartmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 25),
          child: Text(
            'User Registration',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Merri'),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 70),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    controller: FirstNameController,
                    label: 'First Name',
                    hintText: 'Enter First Name',
                    borderColor: borderColor,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: LastNameController,
                    label: 'Last Name',
                    hintText: 'Enter Last Name',
                    borderColor: borderColor,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: EmailController,
                    label: 'Email',
                    hintText: 'Enter Email',
                    borderColor: borderColor,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: PasswordController,
                    label: 'Password',
                    hintText: 'Enter Password',
                    borderColor: borderColor,
                    passField: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: ConfirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'Enter Password Again',
                    borderColor: borderColor,
                    passField: true,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: UserName,
                    label: 'User Name',
                    hintText: 'Enter Username',
                    borderColor: borderColor,
                  ),
                  SizedBox(height: 20),
                  // University Dropdown
                  DropDownWithoutArguments(
                    fetchData: University.fetchUniversities, // Fetch universities data asynchronously
                    hintText: "Select University",
                    label: "University",
                    controller: UniversityController,
                    onValueChanged: (dynamic? id) {
                      setState(() {
                        universitySelected = id != null;
                        campusSelected = false;
                      });
                      if (id != null) {
                        CampusController.clear(); // Clear the Campus controller when University changes
                        departmentSelected = false;
                      }
                    },
                  ),

                  // Campus Dropdown
                  if (universitySelected)
                    DropDownWithArguments(
                      fetchData: () => Campus.fetchCampusesByUniversityId(int.tryParse(UniversityController.text)!), // Fetch campuses asynchronously
                      hintText: "Select Campus",
                      label: "Campus",
                      controller: CampusController,
                      onValueChanged: (dynamic? id) {
                        setState(() {
                          campusSelected = id != null;
                          if (id != null) {
                            departmentSelected = false;
                          }
                        });
                      },
                    ),

                  // Department Dropdown
                  if (campusSelected)
                    DropDownWithArguments(
                      fetchData: () => Department.getDepartmentsbyCampusid(int.tryParse(CampusController.text)!), // Fetch departments asynchronously
                      hintText: "Select department",
                      label: "department",
                      controller: DepartmentController,
                      onValueChanged: (dynamic? id) {
                        setState(() {
                          departmentSelected = id != null;
                        });
                      },
                    ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    controller: RoleController,
                    label: 'User Role',
                    hintText: 'Enter Role',
                    borderColor: borderColor,
                  ),
                  SizedBox(height: 20),
                  Custom_Button(
                    onPressedFunction: () async {
                      setState(() {
                        isLoading = true;
                      });
                      String firstName = FirstNameController.text;
                      String lastName = LastNameController.text;
                      String email = EmailController.text;
                      String password = PasswordController.text;
                      String confirmPassword = ConfirmPasswordController.text;
                      String userName = UserName.text;
                      String? universityIdString = UniversityController.text.isNotEmpty ? UniversityController.text : null;
                      String? campusIdString = CampusController.text.isNotEmpty ? CampusController.text : null;
                      String? departmentIdString = DepartmentController.text.isNotEmpty ? DepartmentController.text : null;

                      int? universityId = universityIdString != null ? int.tryParse(universityIdString) : null;
                      int? campusId = campusIdString != null ? int.tryParse(campusIdString) : null;
                      int? departmentId = departmentIdString != null ? int.tryParse(departmentIdString) : null;

                      String message = await User.registerUser(firstName, lastName, email, password, confirmPassword, userName, universityId, campusId, departmentId);
                      errorMessage = message;
                      if (message != "Registration successful") {
                        setState(() {
                          isLoading = false;
                          borderColor = Colors.red;
                          messageColor = Colors.red;
                        });
                      }
                      else
                      {
                        setState(() {
                          isLoading = false;
                          borderColor = Colors.black;
                          messageColor = Colors.green;
                        });
                      }

                    },
                    ButtonText: 'Register',
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: isLoading,
                    child: CircularProgressIndicator(),
                  ),
                  errorMessage != null
                      ? Text(
                    errorMessage!,
                    style: CustomTextStyles.bodyStyle(color: messageColor),
                  )
                      : SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
