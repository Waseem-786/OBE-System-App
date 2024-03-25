import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'package:login_screen/User_Management.dart';

class Dashboard_Page extends StatefulWidget {
  @override
  State<Dashboard_Page> createState() => _Dashboard_PageState();
}

class _Dashboard_PageState extends State<Dashboard_Page> {
  List<String> headings = [
    'Program Management',
    'Batch Management',
    'Courses',
    'Approval Process',
    'Assessments',
    'User Management',
  ];
  final List<IconData> icons = [
    FontAwesomeIcons.cogs,
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.book,
    FontAwesomeIcons.thumbsUp,
    FontAwesomeIcons.poll,
    FontAwesomeIcons.users,
  ];

  List<String> screenNames = [
    'Screen1',
    'Screen2',
    'Screen3',
    'Screen4',
    'Screen5',
    'Screen6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Container(
          margin: EdgeInsets.only(left: 26),
          child: Text('Admin Dashboard',
            style:

              CustomTextStyles.headingStyle(fontSize: 22)
            // TextStyle(fontWeight: FontWeight
            //   .bold, fontFamily: 'Merri'
            //
            // ),
            //

          ),

        ),
      ),
      body: Container(
        // margin: const EdgeInsets.only(bottom: 102),
        height: double.infinity,
        color: Colors.white10,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 23,),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 8),
                    child: CircleAvatar(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          "assets/images/MyProfile.jpeg",
                        ),
                      ),
                      radius: 35,
                    ),

                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name", style: CustomTextStyles.bodyStyle
                          (fontSize: 27)),

                        Text("UserID",style: CustomTextStyles.bodyStyle(),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only( right:8.0),
                    child: Icon(Icons.notifications,size: 35),
                  ),
                ],
              ),
              SizedBox(height: 15,),

              Divider(thickness: 1,color: Colors.black),

              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the corresponding location
                        // For simplicity, let's print the location for now
                        // print(screenNames[index]);

                      Navigator.push(context, MaterialPageRoute(builder: (context)=> User_Management()));

                      },

                      child: Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(

                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF8B5A2B), // Dark brown
                                Color(0xFFC19A6B), // Light brown
                                Color(0xFF8B5A2B), // Dark brown
                              ],

                              // begin: Alignment.topLeft,
                              // end: Alignment.bottomRight,
                              // colors: [
                                // Color(0xFFF6D365),
                                // Color(0xFFFDA085),

                                // Color(0xFFE0C3FC),
                                // Color(0xFF8EC5FC),


                                // Color(0xFFfdfcfb),
                                // Color(0xFFfef9d7)

                                // Color(0xFFfeada6),
                                // Color(0xFFf5efef)
                                //

                              //   Color(0xFFc19a6b),
                              //   Color(0xFFc19a6b)
                              //
                              // ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Icon(icons[index],size: 39,color: Colors.white,),
                                  SizedBox(height: 15,),
                                  Text(
                                    headings[index],
                                    style: CustomTextStyles.headingStyle
                                      (color: Colors.white,fontSize: 19,),
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
                itemCount: 6,
              ),
              // SizedBox(height: 33,)
            ],
          ),
        ),
      ),
    );
  }
}