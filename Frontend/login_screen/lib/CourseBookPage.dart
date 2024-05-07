import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CourseBooks.dart';
import 'package:login_screen/CreateCourseBook.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/Outline.dart';

import 'CourseBookProfile.dart';

class CourseBookPage extends StatefulWidget {
  @override
  State<CourseBookPage> createState() => _CourseBookPageState();
}

class _CourseBookPageState extends State<CourseBookPage> {

  late Future<List<dynamic>> bookFuture;

  @override
  void initState() {
    super.initState();
    bookFuture = CourseBooks.fetchBooksByOutlineId(Outline.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        bookFuture = CourseBooks.fetchBooksByOutlineId(Outline.id);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          'Course Book Page',
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: bookFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final books = snapshot.data!;
                    return Expanded(
                        child: ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              final book = books[index];
                              return Card(
                                color: Colors.white,
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      'Book ${index+1}',
                                      style: CustomTextStyles.bodyStyle(
                                          fontSize: 17),
                                    ),
                                  ),
                                  trailing: InkWell(
                                      onTap: () async {
                                        var bookData = await CourseBooks.getBookbyId(books[index]['id']);
                                        if (bookData != null) {
                                          CourseBooks.id=bookData['id'];
                                          CourseBooks.bookTitle=bookData['title'];
                                          CourseBooks.bookType=bookData['book_type'];
                                          CourseBooks.description=bookData['description'];
                                          CourseBooks.link=bookData['link'];
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute<bool>(
                                                builder: (context) =>
                                                    CreateCourseBook(
                                                        isUpdate : true,
                                                        BookData : bookData
                                                    ),
                                              )).then((result) {
                                            if (result != null && result) {
                                              // Set the state of the page here
                                              setState(() {
                                                bookFuture = CourseBooks.fetchBooksByOutlineId(Outline.id);
                                              });
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 40,
                                          child: Icon(
                                            size: 32,
                                            Icons.edit_square,
                                            color: Color(0xffc19a6b),
                                          ))),

                                  onTap: () async {
                                    // call of a function to get the data of that course whose id is passed and id is
                                    // passed by tapping the user
                                    var book = await CourseBooks.getBookbyId(books[index]['id']);
                                    if (book != null) {
                                      CourseBooks.id=book['id'];
                                      CourseBooks.bookTitle=book['title'];
                                      CourseBooks.bookType=book['book_type'];
                                      CourseBooks.description=book['description'];
                                      CourseBooks.link=book['link'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute<bool>(
                                            builder: (context) =>
                                                CourseBookProfile(),
                                          )).then((result) {
                                        if (result != null && result) {
                                          // Set the state of the page here
                                          setState(() {
                                            bookFuture = CourseBooks.fetchBooksByOutlineId(Outline.id);
                                          });
                                        }
                                      });
                                    }
                                  },
                                ),
                              );
                            }));
                  }
                }),
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 12),
                child: Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateCourseBook()),
                    );
                  },
                  ButtonText: 'Add Book',
                  ButtonWidth: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
