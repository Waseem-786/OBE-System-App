import 'package:flutter/material.dart';
import 'package:login_screen/Campus_Select.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/University.dart';

class University_Select extends StatefulWidget {
  static bool isForPEO = false;
  static bool isForAssessment = false;
  @override
  State<University_Select> createState() => _University_SelectState();
}

class _University_SelectState extends State<University_Select> {
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
        title: Text('University Select Page',
            style: CustomTextStyles.headingStyle(fontSize: 22)),
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
                            var university = await University.getUniversityById(
                                universities[index]['id']);
                            if (university != null) {
                              University.id = university['id'];
                              University.name = university['name'];
                              University.vision = university['vision'];
                              University.mission = university['mission'];
                              if(University_Select.isForPEO){
                                Campus_Select.isForPEO = true;
                              }
                              else if(University_Select.isForAssessment){
                                Campus_Select.isForAssessment = true;
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Campus_Select()));

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
        ],
      ),
    );
  }
}
