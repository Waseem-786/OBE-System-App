import 'package:flutter/material.dart';
import 'package:login_screen/Create_University.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/University.dart';
import 'package:login_screen/University_Profile.dart';

class University_Page extends StatefulWidget {
  @override
  State<University_Page> createState() => _University_PageState();
}

class _University_PageState extends State<University_Page> {
  late Future<List<dynamic>> universitiesFuture;

  @override
  void initState() {
    super.initState();
    universitiesFuture = University.fetchUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text('University Page',
              style: CustomTextStyles.headingStyle(fontSize: 22)),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: universitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final universities = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: universities.length,
                    itemBuilder: (context, index) {
                      final university = universities[index];
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              university['name'],
                              style: CustomTextStyles.bodyStyle(fontSize: 17),
                            ),
                          ),
                          onTap: () async {
                            // call of a function to get the data of that user whose id is passed and id is
                            // passed by tapping the user
                            List user = await University.getUniversityById(
                                universities[index]['id']);
                            if (user != null) {
                              University.id = user[0]['id'];
                              University.name = user[0]['name'];
                              University.vision = user[0]['vision'];
                              University.mission = user[0]['mission'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => University_Profile()),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, top: 12),
              child: Custom_Button(
                onPressedFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Create_University()),
                  );
                },
                ButtonText: 'Add University',
                ButtonWidth: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
