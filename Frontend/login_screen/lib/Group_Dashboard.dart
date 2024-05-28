
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';

class Group_Dashboard extends StatefulWidget {
  const Group_Dashboard({super.key});

  @override
  State<Group_Dashboard> createState() => _Group_DashboardState();
}

class _Group_DashboardState extends State<Group_Dashboard> {


  List<String> headings = [
    'Show Users',
    'Show Permissions',
    'Add Users',
    'Add Permissions',
  ];

  List<IconData> icons = [
    FontAwesomeIcons.eye,
    FontAwesomeIcons.eye,
    FontAwesomeIcons.add,
    FontAwesomeIcons.add,
  ];

  List<String> screenNames = [
    'Group Users Page',
    'Group Permissions Page',
    'Add Group Users',
    'Add Group Permissions',

  ];








  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(backgroundColor: const Color(0xffc19a6b),
        title: Text('Group Dashboard',style: CustomTextStyles.headingStyle
          (fontSize: 22),),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: 700,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, '/${screenNames[index]}');
                      },

                      child: Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF8B5A2B), // Dark brown
                                Color(0xFFC19A6B), // Light brown
                                Color(0xFF8B5A2B), // Dark brown
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    icons[index],
                                    size: 39,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    headings[index],
                                    style:
                                    CustomTextStyles.headingStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: headings.length,
              ),
            ),
          ),
        ],
      ),



    );
  }
}
