import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Generate_PEO_Page.dart';
import 'Create_PEO.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'PEO.dart';
import 'PEO_Profile.dart';
import 'Show_PEO_Consistency_Page.dart'; // Import the new page

class PEO_Page extends StatefulWidget {
  @override
  State<PEO_Page> createState() => _PEO_PageState();
}

class _PEO_PageState extends State<PEO_Page> {
  late Future<List<dynamic>> peoFuture;

  @override
  void initState() {
    super.initState();
    peoFuture = PEO.AllPEOsbyDeptId(Department.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        peoFuture = PEO.AllPEOsbyDeptId(Department.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text(
            "PEO Page",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: peoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final peos = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: peos.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          var user = await PEO.getPEObyPEOId(peos[index]['id']);
                          if (user != null) {
                            PEO.id = user['id'];
                            PEO.description = user['description'];
                            Navigator.push(
                                context,
                                MaterialPageRoute<bool>(
                                  builder: (context) => PEO_Profile(),
                                )).then((result) {
                              if (result != null && result) {
                                // Set the state of the page here
                                setState(() {
                                  peoFuture = PEO.AllPEOsbyDeptId(Department.id);
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECECEC),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "PEO-${(index + 1).toString()}",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.info,
                                color: Color(0xffc19a6b),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Generate_PEO_Page()));
                  },
                  ButtonWidth: 180,
                  ButtonText: 'Generate PEOs',
                  BackgroundColor: Colors.green,
                  ForegroundColor: Colors.white,
                ),
                Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Create_PEO()));
                  },
                  BackgroundColor: Colors.green,
                  ForegroundColor: Colors.white,
                  ButtonText: "Create PEO",
                  ButtonWidth: 150,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Custom_Button(
              onPressedFunction: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShowPEOConsistencyPage()));
              },
              BackgroundColor: Colors.blue,
              ForegroundColor: Colors.white,
              ButtonText: "Show Consistency",
              ButtonWidth: 250,
            ),
          ),
        ],
      ),
    );
  }
}
