import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class MultiSelectField extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final List<int> selectedOptions;
  final ValueChanged<List<int>> onSelectionChanged;
  final Text buttonText;
  final Widget title;
  final String displayKey;

  const MultiSelectField({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    this.buttonText = const Text('Add Users'),
    this.title = const Text('Select Users'),
    this.displayKey = 'name',
  }) : super(key: key);

  @override
  _MultiSelectFieldState createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  late List<int> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = widget.selectedOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.options.isEmpty)
          CircularProgressIndicator() // Show loading indicator while options are being fetched
        else
          MultiSelectBottomSheetField(
            initialChildSize: 0.4,
            listType: MultiSelectListType.CHIP,
            searchable: true,
            buttonText: widget.buttonText,
            title: widget.title,
            items: widget.options
                .map((option) => MultiSelectItem<int>(option['id'], option[widget.displayKey]))
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
              chipColor: Colors.green,
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
        if (_selectedOptions.isEmpty)
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(
              "None selected",
              style: TextStyle(color: Colors.black54),
            ),
          ),
      ],
    );
  }
}
