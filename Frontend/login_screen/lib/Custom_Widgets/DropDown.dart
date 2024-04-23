import 'package:flutter/material.dart';

class UniversityDropDown extends StatefulWidget {
  final Future<List<dynamic>> Function() fetchData;
  final Function(dynamic)? onValueChanged;
  final Color? borderColor;
  final String? hintText;
  final String? label;
  final TextEditingController? controller;

  UniversityDropDown({
    required this.fetchData,
    this.onValueChanged,
    this.borderColor,
    this.hintText,
    this.label,
    this.controller,
  });

  @override
  _UniversityDropDownState createState() => _UniversityDropDownState();
}

class _UniversityDropDownState extends State<UniversityDropDown> {
  dynamic? selectedValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> data = snapshot.data!;
          return SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<dynamic>(
              value: selectedValue,
              decoration: InputDecoration(
                label: widget.label != null
                    ? Text(
                  widget.label!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
                    : null,
                hintText: widget.hintText ?? 'Select',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(value);
                }
                if (widget.controller != null) {
                  if (value is Map<String, dynamic>) {
                    widget.controller!.text = value['id'].toString();
                  } else {
                    widget.controller!.text = value.toString();
                  }
                }
              },
              items: data.map<DropdownMenuItem<dynamic>>((item) {
                return DropdownMenuItem<dynamic>(
                  value: item['id'],
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.7, // Set the width to 70% of the screen width
                    child: Text(
                      item['name'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

class CampusDropDown extends StatefulWidget {
  final Future<List<dynamic>> Function() fetchData;
  final Function(dynamic)? onValueChanged;
  final Color? borderColor;
  final String? hintText;
  final String? label;
  final TextEditingController? controller;
  dynamic selectedValue;

  CampusDropDown({
    required this.fetchData,
    this.onValueChanged,
    this.borderColor,
    this.hintText,
    this.label,
    this.controller,
    required this.selectedValue,
  });

  @override
  _CampusDropDownState createState() => _CampusDropDownState();
}

class _CampusDropDownState extends State<CampusDropDown> {
  // dynamic? selectedValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> data = snapshot.data!;
          return SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<dynamic>(
              isExpanded: true,
              value: widget.selectedValue,
              decoration: InputDecoration(
                label: widget.label != null
                    ? Text(
                  widget.label!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
                    : null,
                hintText: widget.hintText ?? 'Select',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  widget.selectedValue = value;
                });
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(value);
                }
                if (widget.controller != null) {
                  if (value is Map<String, dynamic>) {
                    widget.controller!.text = value['id'].toString();
                  } else {
                    widget.controller!.text = value.toString();
                  }
                }
              },
              items: data.map<DropdownMenuItem<dynamic>>((item) {
                final uniqueValue = item['id'];
                return DropdownMenuItem<dynamic>(
                  value: uniqueValue,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth:
                      MediaQuery.of(context).size.width * 0.7, // Limit the width to 70% of the screen width
                    ),
                    child: Text(
                      item['name'],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

class DepartmentDropDown extends StatefulWidget {
  final Future<List<dynamic>> Function() fetchData;
  final Function(dynamic)? onValueChanged;
  final Color? borderColor;
  final String? hintText;
  final String? label;
  final TextEditingController? controller;
  dynamic selectedValue;

  DepartmentDropDown({
    required this.fetchData,
    this.onValueChanged,
    this.borderColor,
    this.hintText,
    this.label,
    this.controller,
    required this.selectedValue,
  });

  @override
  _DepartmentDropDownState createState() => _DepartmentDropDownState();
}

class _DepartmentDropDownState extends State<DepartmentDropDown> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> data = snapshot.data!;
          return SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<dynamic>(
              isExpanded: true,
              value: widget.selectedValue,
              decoration: InputDecoration(
                label: widget.label != null
                    ? Text(
                  widget.label!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
                    : null,
                hintText: widget.hintText ?? 'Select',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.borderColor ?? Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  widget.selectedValue = value;
                });
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(value);
                }
                if (widget.controller != null) {
                  if (value is Map<String, dynamic>) {
                    widget.controller!.text = value['id'].toString();
                  } else {
                    widget.controller!.text = value.toString();
                  }
                }
              },
              items: data.map<DropdownMenuItem<dynamic>>((item) {
                final uniqueValue = item['id'];
                return DropdownMenuItem<dynamic>(
                  value: uniqueValue,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width *
                          0.7, // Limit the width to 70% of the screen width
                    ),
                    child: Text(
                      item['name'],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
