import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/CLO_Profile.dart';
import 'package:login_screen/Course.dart';

import 'Create_CLO.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class CLO_Page extends StatefulWidget {
  @override
  State<CLO_Page> createState() => _CLO_PageState();
}

class _CLO_PageState extends State<CLO_Page> {
  late Future<List<dynamic>> cloFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cloFuture = CLO.fetchCLO(Course.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        cloFuture = CLO.fetchCLO(Course.id);
      });
    }
  }

  Future<void> _generateCLOs() async {
    setState(() {
      isLoading = true;
      // cloFuture = CLO.generateCLOs(Course.id); // Replace with your CLO generation method
    });

    cloFuture.then((_) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          margin: const EdgeInsets.only(left: 90),
          child: Text(
            "CLO Page",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(),
          FutureBuilder(
            future: cloFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final clos = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: clos.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          var user = await CLO.getCLObyCLOId(clos[index]['id']);
                          if (user != null) {
                            CLO.id = user['id'];
                            CLO.description = user['description'];
                            CLO.bloom_taxonomy = user['bloom_taxonomy'];
                            CLO.level = user['level'];

                            Navigator.push(
                                context,
                                MaterialPageRoute<bool>(
                                  builder: (context) => CLO_Profile(),
                                )).then((result) {
                              if (result != null && result) {
                                // Set the state of the page here
                                setState(() {
                                  cloFuture = CLO.fetchCLO(Course.id);
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECECEC),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CLO-${1 + index}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Custom_Button(
                  onPressedFunction: _generateCLOs,
                  BackgroundColor: Colors.blue,
                  ForegroundColor: Colors.white,
                  ButtonText: "Generate CLOs",
                  ButtonWidth: 180,
                ),
                const SizedBox(height: 10),
                Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Create_CLO()));
                  },
                  BackgroundColor: Colors.green,
                  ForegroundColor: Colors.white,
                  ButtonText: "Create CLO",
                  ButtonWidth: 180,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
