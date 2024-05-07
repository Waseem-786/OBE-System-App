import 'package:flutter/material.dart';
import 'package:login_screen/CourseBooks.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Outline.dart';

import 'Custom_Widgets/UpdateWidget.dart';

class CreateCourseBook extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? BookData;

  CreateCourseBook({this.isUpdate = false, this.BookData});

  @override
  State<CreateCourseBook> createState() => _CreateCourseBookState();
}

class _CreateCourseBookState extends State<CreateCourseBook> {
  String? errorMessage;
  Color colorMessage = Colors.red;
  var isLoading = false;
  Color errorColor = Colors.black12;

  late TextEditingController BookTitleController;
  late TextEditingController BookDescriptionController;
  late TextEditingController BookLinkController;
  String? SelectedBookType;

  @override
  void initState() {
    super.initState();
    BookTitleController = TextEditingController(text: widget.BookData?['title'] ?? '');
    BookDescriptionController = TextEditingController(text: widget.BookData?['description'] ?? '');
    BookLinkController = TextEditingController(text: widget.BookData?['link'] ?? '');
    SelectedBookType = widget.BookData?['book_type'] ?? null;
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isUpdate ? 'Update' : 'Create';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          widget.isUpdate ? 'Update Book Form' : 'Create Book Form',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: BookTitleController,
              label: 'Book Title',
              hintText: 'Enter Book Title',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: SelectedBookType,
              onChanged: (value) {
                setState(() {
                  SelectedBookType = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Book Type',
                hintText: 'Select Book Type',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
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
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: BookDescriptionController,
              label: 'Book Description',
              hintText: 'Enter Book Description',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: BookLinkController,
              label: 'Book Link',
              hintText: 'Enter Book Link',
              borderColor: errorColor,
            ),
            const SizedBox(height: 20),
            Custom_Button(
              onPressedFunction: () async {
                if (widget.isUpdate) {
                  // Show confirmation dialog
                  bool confirmUpdate = await showDialog(
                    context: context,
                    builder: (context) => const UpdateWidget(
                      title: "Confirm Update",
                      content: "Are you sure you want to update Book?",
                    ),
                  );
                  if (!confirmUpdate) {
                    return; // Cancel the update if user selects 'No' in the dialog
                  }
                }
                String BookTitle = BookTitleController.text;
                String BookDescription = BookDescriptionController.text;
                String BookLink = BookLinkController.text;
                if (BookTitle.isEmpty || BookDescription.isEmpty || BookLink.isEmpty || SelectedBookType == null) {
                  setState(() {
                    colorMessage = Colors.red;
                    errorColor = Colors.red;
                    errorMessage = 'Please enter all fields';
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  bool result;
                  if (widget.isUpdate) {
                    result = await CourseBooks.updateCourseBook(
                      widget.BookData?['id'],
                      BookTitle,
                      SelectedBookType,
                      BookDescription,
                      BookLink,
                    );
                  } else {
                    result = await CourseBooks.createBook(
                      BookTitle,
                      SelectedBookType,
                      BookDescription,
                      BookLink,
                      Outline.id,
                    );
                  }
                  if (result) {
                    BookTitleController.clear();
                    BookDescriptionController.clear();
                    BookLinkController.clear();
                    SelectedBookType = null;
                    setState(() {
                      isLoading = false;
                      colorMessage = Colors.green;
                      errorColor = Colors.black12;
                      errorMessage = widget.isUpdate ? 'Course Book Updated successfully' : 'Course Book Created successfully';
                    });
                  }
                }
              },
              ButtonWidth: 160,
              ButtonText: buttonText,
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
