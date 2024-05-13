
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/DetailCard.dart';
import 'package:login_screen/Permission.dart';
import 'CourseBooks.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DeleteAlert.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';

class CourseBookProfile extends StatefulWidget {
  const CourseBookProfile({super.key});

  @override
  State<CourseBookProfile> createState() => _CourseBookProfileState();
}

class _CourseBookProfileState extends State<CourseBookProfile> {

  // final clo_id = CLO.id;
  String? errorMessage; //variable to show the error when the wrong
  // credentials are entered or the fields are empty
  Color colorMessage = Colors.red; // color of the message when the error occurs
  var isLoading = false; // variable for use the functionality of loading while request is processed to server

  final bookId = CourseBooks.id;
  late Future<bool> hasDeleteBookPermissionFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hasDeleteBookPermissionFuture = Permission.searchPermissionByCodename("delete_book");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
            child: Text('Course Book Profile',
                style: CustomTextStyles.headingStyle(fontSize: 22))),
      ),

      body: Container(
        color: Colors.grey.shade200,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text(
                  "Book Details", style: CustomTextStyles.headingStyle())),
              const SizedBox(height: 20),
              ..._buildBookInfoCards(),
              SizedBox(height: 20),
              Center(child: _actionButtons()),
              SizedBox(height: 10),
              Center(
                child: Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(),
                ),
              ),
              if (errorMessage != null)
                Center(
                  child: Text(errorMessage!,
                      style: CustomTextStyles.bodyStyle(color: colorMessage)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBookInfoCards() {
    return [
      DetailCard(
          label: "Book Title", value: CourseBooks.bookTitle, icon: Icons.title),
      DetailCard(label: "Book Type",
          value: CourseBooks.bookType,
          icon: Icons.type_specimen),
      DetailCard(label: "Book Description",
          value: CourseBooks.description,
          icon: Icons.description),
      DetailCard(label: "Book Link", value: CourseBooks.link, icon: Icons.link),
    ];
  }

  Widget _actionButtons() {
    return Column(
      children: [
        PermissionBasedButton(
          buttonText: "Delete",
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          buttonWidth: 120,
          onPressed: () => _confirmDelete(context),
          permissionFuture: hasDeleteBookPermissionFuture,
        ),
      ],
    );
  }


  Future<void> _confirmDelete(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: "Confirm Deletion",
        content: "Are you sure you want to delete this book?",
      ),
    );
    if (confirmDelete) {
      setState(() => isLoading = true);
      bool deleted = await CourseBooks.deleteBook(bookId);
      if (deleted) {
        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorMessage = 'Book deleted successfully';
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to delete book';
        });
      }
    }
  }
}