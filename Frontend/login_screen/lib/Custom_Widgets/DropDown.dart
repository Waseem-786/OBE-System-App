import 'package:flutter/material.dart';

class DropDownWithoutArguments extends StatefulWidget {
  final Future<List<dynamic>> Function() fetchData; // Update to accept Future<List<dynamic>> Function()
  final Function(dynamic)? onValueChanged;
  final Color? borderColor;
  final String? hintText;
  final String? label;
  final TextEditingController? controller;

  DropDownWithoutArguments({
    required this.fetchData,
    this.onValueChanged,
    this.borderColor,
    this.hintText,
    this.label,
    this.controller,
  });

  @override
  _DropDownWithoutArgumentsState createState() => _DropDownWithoutArgumentsState();
}

class _DropDownWithoutArgumentsState extends State<DropDownWithoutArguments> {
  dynamic? selectedValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.fetchData(), // Fetch data asynchronously
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
                    // If the value is a map, set the controller to the value of its 'id' field
                    widget.controller!.text = value['id'].toString();
                  } else {
                    // If the value is not a map, set the controller directly to the value
                    widget.controller!.text = value.toString();
                  }
                }
              },
              items: data.map<DropdownMenuItem<dynamic>>((item) {
                print(item);
                return DropdownMenuItem<dynamic>(
                  value: item['id'], // Assuming 'id' is the unique identifier
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 45,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.borderColor ?? Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['name'],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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



















class DropDownWithArguments extends StatefulWidget {
  final Future<List<dynamic>> Function() fetchData; // Function to fetch data with arguments
  final Function(dynamic)? onValueChanged;
  final Color? borderColor;
  final String? hintText;
  final String? label;
  final TextEditingController? controller;

  DropDownWithArguments({
    required this.fetchData,
    this.onValueChanged,
    this.borderColor,
    this.hintText,
    this.label,
    this.controller,
  });

  @override
  _DropDownWithArgumentsState createState() => _DropDownWithArgumentsState();
}

class _DropDownWithArgumentsState extends State<DropDownWithArguments> {
  dynamic? selectedValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.fetchData(), // Call the function to fetch data with arguments
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
                    // If the value is a map, set the controller to the value of its 'id' field
                    widget.controller!.text = value['id'].toString();
                  } else {
                    // If the value is not a map, set the controller directly to the value
                    widget.controller!.text = value.toString();
                  }
                }
              },
              items: data.map<DropdownMenuItem<dynamic>>((item) {
                print(item);
                // Ensure that each item has a unique value
                final uniqueValue = item['id']; // Assuming 'id' is the unique identifier
                return DropdownMenuItem<dynamic>(
                  value: uniqueValue,
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 45,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: widget.borderColor ?? Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['name'],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
