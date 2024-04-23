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
  dynamic? selectedCampusId;
  dynamic? selectedDepartmentId;

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

  bool _validateFields() {
    if (FirstNameController.text.isEmpty ||
        LastNameController.text.isEmpty ||
        EmailController.text.isEmpty ||
        PasswordController.text.isEmpty ||
        ConfirmPasswordController.text.isEmpty ||
        UserName.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all required fields.';
        messageColor = Colors.red;
      });
      return false;
    }

    if (!EmailController.text.contains('@') || !EmailController.text.contains('.')) {
      setState(() {
        errorMessage = 'Please enter a valid email address.';
        messageColor = Colors.red;
      });
      return false;
    }

    // Password complexity validation using the provided regular expression
    String password = PasswordController.text;
    if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,}$').hasMatch(password)) {
      setState(() {
        errorMessage = 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.';
        messageColor = Colors.red;
      });
      return false;
    }

    if (PasswordController.text != ConfirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match.';
        messageColor = Colors.red;
      });
      return false;
    }
    
    return true;
  }


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
                  UniversityDropDown(
                    fetchData: University.fetchUniversities, // Fetch universities data asynchronously
                    hintText: "Select University",
                    label: "University",
                    controller: UniversityController,
                    onValueChanged: (dynamic? id) {
                      setState(() {
                        universitySelected = id != null;
                        campusSelected = false;
                        departmentSelected = false;
                        CampusController.clear(); // Clear the Campus controller when University changes
                        DepartmentController.clear(); // Clear the Department controller when University changes
                        selectedCampusId = null;
                        selectedDepartmentId = null;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // Campus Dropdown
                  if (universitySelected)
                    CampusDropDown(
                      fetchData: () => Campus.fetchCampusesByUniversityId(int.tryParse(UniversityController.text)!), // Fetch campuses asynchronously
                      hintText: "Select Campus",
                      label: "Campus",
                      controller: CampusController,
                      selectedValue: selectedCampusId,
                      onValueChanged: (dynamic? id) {
                        setState(() {
                          campusSelected = id != null;
                          selectedCampusId = id;
                          departmentSelected = false;
                          DepartmentController.clear(); // Clear the Department controller when Campus changes
                          selectedDepartmentId = null;
                        });
                      },
                    ),
                  SizedBox(height: 20),
                  // Department Dropdown
                  if (campusSelected)
                    DepartmentDropDown(
                      fetchData: () => Department.getDepartmentsbyCampusid(int.tryParse(CampusController.text)!), // Fetch departments asynchronously
                      hintText: "Select department",
                      label: "department",
                      controller: DepartmentController,
                      selectedValue: selectedDepartmentId,
                      onValueChanged: (dynamic? id) {
                        setState(() {
                          departmentSelected = id != null;
                          selectedDepartmentId = id;
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

                      if (!_validateFields()) {
                        setState(() {
                          isLoading = false;
                        });
                        return;
                      }

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


                          //Reset Fields
                          FirstNameController.clear();
                          LastNameController.clear();
                          EmailController.clear();
                          PasswordController.clear();
                          ConfirmPasswordController.clear();
                          UserName.clear();
                          UniversityController.clear();
                          CampusController.clear();
                          DepartmentController.clear();
                          RoleController.clear();
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

