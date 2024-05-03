

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login_screen/CourseBooks.dart';
import 'package:login_screen/Custom_Widgets/DropDown.dart';
import 'package:login_screen/Outline.dart';
import 'Course.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Field.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class CreateCourseBook extends StatefulWidget {

  @override
  State<CreateCourseBook> createState() => _CreateCourseBookState();
}

class _CreateCourseBookState extends State<CreateCourseBook> {

   // int departmentId = User.departmentid;
  String? errorMessage;
  //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
  // color of the message when the error occurs
  var isLoading = false;
  // variable for use the functionality of loading while request is processed to server
  Color errorColor = Colors.black12;
  // color of border of text fields when the error is not occurred

  final TextEditingController BookTitleController = TextEditingController();
  // final TextEditingController BookTypeController = TextEditingController();
  final TextEditingController BookDescriptionController = TextEditingController();
  final TextEditingController BookLinkController = TextEditingController();

  String? SelectedBookType;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          margin: const EdgeInsets.only(left: 90),
          child: Text(
            "Create Book",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(controller: BookTitleController,
                  hintText: 'Enter Book Title',
                  label: 'Enter Book Title',
                ),
                const SizedBox(height: 20,),

                DropdownButtonFormField<String>(
                  value: SelectedBookType,
                  onChanged: (value) {
                    setState(() {
                      SelectedBookType = value as String;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Book Type',
                    hintText: 'Select Book Type',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black12, // Default border color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: errorColor),
                    ),
                  ),
                  items: ['Reference', 'Text'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),


                const SizedBox(height: 20,),


                CustomTextFormField(controller: BookDescriptionController,
                  hintText: 'Enter Book Description',
                  label: 'Enter Book Description',
                ),
                const SizedBox(height: 20,),

                CustomTextFormField(controller: BookLinkController,
                  hintText: 'Enter Book Link',
                  label: 'Enter Book Link',
                ),
                const SizedBox(height: 20,),




                Custom_Button(
                  onPressedFunction: () async {
                    String BookTitle = BookTitleController.text;
                    String BookDescription = BookDescriptionController.text;
                    String BookLink = BookLinkController.text;
                    if (BookTitle.isEmpty || BookDescription.isEmpty || BookLink
                        .isEmpty || SelectedBookType==null) {
                      setState(() {
                        colorMessage = Colors.red;
                        errorColor = Colors.red;
                        errorMessage = 'Please enter all fields';
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      bool created = await CourseBooks.createBook(
                          BookTitle,SelectedBookType,BookDescription,BookLink,
                          Outline.id);
                      if (created) {
                        //Clear all the fields
                        BookDescriptionController.clear();
                        BookTitleController.clear();
                        SelectedBookType = null;
                        BookLinkController.clear();

                        setState(() {
                          isLoading = false;
                          colorMessage = Colors.green;
                          errorColor =
                              Colors.black12; // Reset errorColor to default value
                          errorMessage = 'Book Created successfully';
                        });
                      }
                    }
                  },
                  ButtonWidth: 160,
                  ButtonText: 'Create Book',),
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
        ),
      ),




    );
  }
}
