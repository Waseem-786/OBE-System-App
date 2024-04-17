

import 'Custom_Text_Style.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Custom_Text_Style.dart';

class DropDown extends StatefulWidget {
  final String token;
  final String endpoint;
  final Color? borderColor;
  final String? hintText;
  final String? label;

  DropDown({
    required this.token,
    required this.endpoint,
    this.borderColor,
    this.hintText,
    this.label,
  });

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  late Future<List<Map<String, dynamic>>> universitiesFuture;
  Map<String, dynamic>? selectedUniversity;

  @override
  void initState() {
    super.initState();
    universitiesFuture = fetchUniversities(widget.token, widget.endpoint);
  }

  Future<List<Map<String, dynamic>>> fetchUniversities(
      String token, String endpoint) async {
    List<Map<String, dynamic>> universities = [];

    try {
      http.Response response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        universities = data.map((item) => {
          'id': item['id'],
          'name': item['name'],
        }).toList();
      } else {
        throw Exception('Failed to fetch universities');
      }
    } catch (e) {
      print('Error fetching universities: $e');
      throw Exception('Failed to fetch universities. Please try again later.');
    }

    return universities;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: universitiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> universities = snapshot.data!;
          return SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedUniversity,
              decoration: InputDecoration(
                label: widget.label != null
                    ? Text(
                  widget.label!,
                  style: CustomTextStyles.bodyStyle(),
                )
                    : null,
                hintText: widget.hintText ?? 'Enter Email',
                hintStyle: CustomTextStyles.bodyStyle(color: Colors.grey),
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
                  selectedUniversity = value;
                });
              },
              items: universities.map((university) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: university,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        university['name'],
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.bodyStyle(),
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
