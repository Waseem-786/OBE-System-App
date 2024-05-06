import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';


class Add_Group_User extends StatefulWidget {
  const Add_Group_User({Key? key}) : super(key: key);

  @override
  State<Add_Group_User> createState() => _Add_Group_UserState();
}

class _Add_Group_UserState extends State<Add_Group_User> {

  List<String> _selectedOptions = [];

  List<String> _options = [
    'User 1',
    'User 2',
    'User 3',
    'User 4',
    'User 5',
  ];

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

      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Column(
            children: <Widget>[
              MultiSelectBottomSheetField(
                initialChildSize: 0.4,
                listType: MultiSelectListType.CHIP,
                searchable: true,
                buttonText: Text("Add Users"),
                title: Text("Select Users"),
                items: _options
                    .map((option) => MultiSelectItem<String>(option, option))
                    .toList(),
                onConfirm: (values) {
                  setState(() {
                    _selectedOptions = values.cast<String>();
                  });
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      _selectedOptions.remove(value);
                    });
                  },
                ),
              ),
              _selectedOptions.isEmpty
                  ? Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "None selected",
                  style: TextStyle(color: Colors.black54),
                ),
              )
                  : Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: _selectedOptions
                      .map((option) =>
                      Chip(
                        label: Text(option),
                        onDeleted: () {
                          setState(() {
                            _selectedOptions.remove(option);
                          });
                        },
                      ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}


