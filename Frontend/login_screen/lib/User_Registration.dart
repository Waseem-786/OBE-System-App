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
  dynamic selectedUniversityId;
  dynamic selectedCampusId;
  dynamic selectedDepartmentId;

  String? errorMessage;
  Color messageColor = Colors.red;
  var isLoading = false;
  Color borderColor = Colors.black12;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController campusController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  bool _validateFields() {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        userNameController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all required fields.';
        messageColor = Colors.red;
      });
      return false;
    }

    if (!emailController.text.contains('@') || !emailController.text.contains('.')) {
      setState(() {
        errorMessage = 'Please enter a valid email address.';
        messageColor = Colors.red;
      });
      return false;
    }

    // Password complexity validation using the provided regular expression
    String password = passwordController.text;
    if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,}$').hasMatch(password)) {
      setState(() {
        errorMessage = 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.';
        messageColor = Colors.red;
      });
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
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
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          margin: const EdgeInsets.only(left: 25),
          child: const Text(
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
              margin: const EdgeInsets.only(top: 70),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    controller: firstNameController,
                    label: 'First Name',
                    hintText: 'Enter First Name',
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: lastNameController,
                    label: 'Last Name',
                    hintText: 'Enter Last Name',
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: emailController,
                    label: 'Email',
                    hintText: 'Enter Email',
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: passwordController,
                    label: 'Password',
                    hintText: 'Enter Password',
                    borderColor: borderColor,
                    passField: true,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'Enter Password Again',
                    borderColor: borderColor,
                    passField: true,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: userNameController,
                    label: 'User Name',
                    hintText: 'Enter Username',
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 20),
                  // University Dropdown
                  DropDown(
                    fetchData: University.fetchUniversities, // Fetch universities data asynchronously
                    hintText: "Select University",
                    label: "University",
                    controller: universityController,
                    selectedValue: selectedUniversityId,
                    onValueChanged: (dynamic id) {
                      setState(() {
                        universitySelected = id != null;
                        selectedUniversityId = id;
                        campusSelected = false;
                        departmentSelected = false;
                        campusController.clear(); // Clear the Campus controller when University changes
                        departmentController.clear(); // Clear the Department controller when University changes
                        selectedCampusId = null;
                        selectedDepartmentId = null;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Campus Dropdown
                  if (universitySelected)
                    DropDown(
                      fetchData: () => Campus.fetchCampusesByUniversityId(int.tryParse(universityController.text)!), // Fetch campuses asynchronously
                      hintText: "Select Campus",
                      label: "Campus",
                      controller: campusController,
                      selectedValue: selectedCampusId,
                      onValueChanged: (dynamic id) {
                        setState(() {
                          campusSelected = id != null;
                          selectedCampusId = id;
                          departmentSelected = false;
                          departmentController.clear(); // Clear the Department controller when Campus changes
                          selectedDepartmentId = null;
                        });
                      },
                    ),
                  const SizedBox(height: 20),
                  // Department Dropdown
                  if (campusSelected)
                    DropDown(
                      fetchData: () => Department.getDepartmentsbyCampusid(int.tryParse(campusController.text)!), // Fetch departments asynchronously
                      hintText: "Select department",
                      label: "department",
                      controller: departmentController,
                      selectedValue: selectedDepartmentId,
                      onValueChanged: (dynamic id) {
                        setState(() {
                          departmentSelected = id != null;
                          selectedDepartmentId = id;
                        });
                      },
                    ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: roleController,
                    label: 'User Role',
                    hintText: 'Enter Role',
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 20),
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

                      String firstName = firstNameController.text;
                      String lastName = lastNameController.text;
                      String email = emailController.text;
                      String password = passwordController.text;
                      String confirmPassword = confirmPasswordController.text;
                      String userName = userNameController.text;
                      String? universityIdString = universityController.text.isNotEmpty ? universityController.text : null;
                      String? campusIdString = campusController.text.isNotEmpty ? campusController.text : null;
                      String? departmentIdString = departmentController.text.isNotEmpty ? departmentController.text : null;

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
                          firstNameController.clear();
                          lastNameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          confirmPasswordController.clear();
                          userNameController.clear();
                          universityController.clear();
                          campusController.clear();
                          departmentController.clear();
                          roleController.clear();
                        });
                      }

                    },
                    ButtonText: 'Register',
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: isLoading,
                    child: const CircularProgressIndicator(),
                  ),
                  errorMessage != null
                      ? Text(
                    errorMessage!,
                    style: CustomTextStyles.bodyStyle(color: messageColor),
                  )
                      : const SizedBox(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

