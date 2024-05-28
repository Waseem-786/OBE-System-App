import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import 'Campus.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/Multi_Select_Field.dart';
import 'Department.dart';
import 'Role.dart';
import 'University.dart';
import 'User.dart';

class Add_Group_User extends StatefulWidget {
  const Add_Group_User({Key? key}) : super(key: key);

  @override
  State<Add_Group_User> createState() => _Add_Group_UserState();
}

class _Add_Group_UserState extends State<Add_Group_User> {

  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  List<String> _selectedUserNames = [];
  List<Map<String, dynamic>> _userOptions = [];

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

    return users.map((user) => {
      'id': user['id'],
      'username': user['username']
    }).toList();
  }

  List<int> getSelectedUserIds() {
    return _selectedUserNames.map((username) {
      return _userOptions.firstWhere((option) => option['username'] == username)['id'] as int;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            'Add Group Users',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: MultiSelectField(
                options: _userOptions.map((option) => option['username'].toString()).toList(),
                selectedOptions: _selectedUserNames,
                onSelectionChanged: (values) {
                  setState(() {
                    _selectedUserNames = values;
                  });
                },
              ),
            ),
            Custom_Button(
              onPressedFunction: () async {
                List<int> selectedUserIds = getSelectedUserIds();

                if (selectedUserIds.isEmpty) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please Select at least one user';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });

                  bool created = await User.addUserToGroup(Role.id, selectedUserIds);

                  setState(() {
                    isLoading = false;
                    if (created) {
                      _selectedUserNames = [];
                      colorMessage = Colors.green;
                      errorMessage = 'Users Added successfully';
                    } else {
                      colorMessage = Colors.red;
                      errorMessage = 'Failed to add users';
                    }
                  });
                }
              },
              ButtonWidth: 160,
              ButtonText: 'Add Users',
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
