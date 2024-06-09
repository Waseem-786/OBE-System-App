import 'package:flutter/material.dart';
import 'package:login_screen/CourseBooks.dart';
import 'package:login_screen/CreateCourseObjective.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Field.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Outline.dart';
import 'package:login_screen/Custom_Widgets/UpdateWidget.dart';

class CreateCourseBook extends StatefulWidget {
  final bool isFromOutline;
  final bool isUpdate;
  final Map<String, dynamic>? BookData;

  CreateCourseBook(
      {this.isFromOutline = false, this.isUpdate = false, this.BookData});

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

  List<Map<String, TextEditingController>> bookControllers = [];

  @override
  void initState() {
    super.initState();
    BookTitleController =
        TextEditingController(text: widget.BookData?['title'] ?? '');
    BookDescriptionController =
        TextEditingController(text: widget.BookData?['description'] ?? '');
    BookLinkController =
        TextEditingController(text: widget.BookData?['link'] ?? '');
    SelectedBookType = widget.BookData?['book_type'] ?? null;

    if (widget.isFromOutline) {
      _addBook();
    }
  }

  void _addBook() {
    setState(() {
      bookControllers.add({
        'title': TextEditingController(),
        'book_type': TextEditingController(),
        'description': TextEditingController(),
        'link': TextEditingController(),
      });
    });
  }

  void _removeBook(int index) {
    setState(() {
      bookControllers.removeAt(index);
    });
  }

  bool _validateFields() {
    bool isValid = true;
    if (widget.isFromOutline) {
      for (var controllers in bookControllers) {
        if (controllers['title']!.text.isEmpty ||
            controllers['book_type']!.text.isEmpty ||
            controllers['description']!.text.isEmpty ||
            controllers['link']!.text.isEmpty) {
          isValid = false;
          break;
        }
      }
    } else {
      if (BookTitleController.text.isEmpty ||
          BookDescriptionController.text.isEmpty ||
          BookLinkController.text.isEmpty ||
          SelectedBookType == null) {
        isValid = false;
      }
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    String buttonText =
    widget.isFromOutline ? 'Next' : (widget.isUpdate ? 'Update' : 'Create');

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isFromOutline) ...[
                  ...bookControllers.map((controllers) {
                    int index = bookControllers.indexOf(controllers);
                    return Card(
                      elevation: 4,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: controllers['title']!,
                              hintText: 'Enter Book Title',
                              label: 'Book Title',
                              borderColor: errorColor,
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: controllers['book_type']!.text.isEmpty
                                  ? null
                                  : controllers['book_type']!.text,
                              onChanged: (value) {
                                setState(() {
                                  controllers['book_type']!.text = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Book Type',
                                hintText: 'Select Book Type',
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: errorColor),
                                ),
                              ),
                              items: ['Reference', 'Text']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: controllers['description']!,
                              hintText: 'Enter Book Description',
                              label: 'Book Description',
                              borderColor: errorColor,
                            ),
                            const SizedBox(height: 20),
                            CustomTextFormField(
                              controller: controllers['link']!,
                              hintText: 'Enter Book Link',
                              label: 'Book Link',
                              borderColor: errorColor,
                            ),
                            const SizedBox(height: 20),
                            Custom_Button(
                              onPressedFunction: () => _removeBook(index),
                              ButtonIcon: Icons.delete,
                              ButtonText: "Remove Book",
                              ButtonWidth: 200,
                              ForegroundColor: Colors.white,
                              BackgroundColor: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  Custom_Button(
                    onPressedFunction: _addBook,
                    ButtonText: "Add Book",
                    ButtonIcon: Icons.add,
                    ForegroundColor: Colors.white,
                    BackgroundColor: Colors.blue,
                    ButtonWidth: 170,
                  ),
                ] else ...[
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
                ],
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

                    if (!_validateFields()) {
                      setState(() {
                        colorMessage = Colors.red;
                        errorColor = Colors.red;
                        errorMessage = 'Please enter all fields';
                      });
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    bool result = true;

                    if (widget.isFromOutline) {
                      List<Map<String, dynamic>> books = bookControllers
                          .map((controllers) {
                        return {
                          'title': controllers['title']!.text,
                          'book_type': controllers['book_type']!.text,
                          'description': controllers['description']!.text,
                          'link': controllers['link']!.text,
                          'course_outline': Outline.id,
                        };
                      }).toList();
                      CourseBooks.books = books;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateCourseObjective(isFromOutline: true),
                        ),
                      ); // Replace with your next screen
                    } else {
                      if (widget.isUpdate) {
                        result = await CourseBooks.updateCourseBook(
                          widget.BookData?['id'],
                          BookTitleController.text,
                          SelectedBookType!,
                          BookDescriptionController.text,
                          BookLinkController.text,
                        );
                      } else {
                        result = await CourseBooks.createBook(
                          BookTitleController.text,
                          SelectedBookType!,
                          BookDescriptionController.text,
                          BookLinkController.text,
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
                          errorMessage = widget.isUpdate
                              ? 'Course Book Updated successfully'
                              : 'Course Book Created successfully';
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                          colorMessage = Colors.red;
                          errorMessage = 'Failed to save Course Books';
                        });
                      }
                    }
                  },
                  ButtonWidth: 140,
                  ButtonIcon: Icons.navigate_next,
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
        ),
      ),
    );
  }
}
