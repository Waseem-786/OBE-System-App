import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class MultiSelectField extends StatefulWidget {
  final List<Map<String, dynamic>> options; // Updated to accept a list of objects containing both name and ID
  final List<int> selectedOptions; // Updated to store IDs
  final ValueChanged<List<int>> onSelectionChanged; // Updated to pass IDs instead of names
  final Text buttonText;
  final Widget title;

  const MultiSelectField({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    this.buttonText = const Text('Add Users'),
    this.title = const Text('Select Users'),
  }) : super(key: key);

  @override
  _MultiSelectFieldState createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  late List<int> _selectedOptions; // Updated to store IDs

  @override
  void initState() {
    super.initState();
    _selectedOptions = widget.selectedOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MultiSelectBottomSheetField(
          initialChildSize: 0.4,
          listType: MultiSelectListType.CHIP,
          searchable: true,
          buttonText: widget.buttonText,
          title: widget.title,
          items: widget.options
              .map((option) => MultiSelectItem<int>(option['id'], option['name'])) // Extracting both ID and name
              .toList(),
          onConfirm: (values) {
            setState(() {
              _selectedOptions = values.cast<int>();
            });
            widget.onSelectionChanged(_selectedOptions);
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              setState(() {
                _selectedOptions.remove(value);
              });
              widget.onSelectionChanged(_selectedOptions);
            },
            chipColor: Colors.green, // Background color of chips
            textStyle: TextStyle(color: Colors.white), // Text color of chips
            // Icon to show before the chip label
            //iconColor: Colors.white, // Color of the icon
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
            : Container()
      ],
    );
  }
}
