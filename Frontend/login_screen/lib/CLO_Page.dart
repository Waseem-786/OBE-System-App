import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/CLO_Profile.dart';

import 'Create_CLO.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class CLO_Page extends StatefulWidget {
  @override
  State<CLO_Page> createState() => _CLO_PageState();
}

class _CLO_PageState extends State<CLO_Page> {
  late Future<List<dynamic>> cloFuture;

  @override
  void initState() {
    super.initState();
    cloFuture = CLO.fetchCLO();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 90),
          child: Text(
            "CLO Page",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
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
                              MaterialPageRoute(builder: (context) => CLO_Profile()),
                            );
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
                                clos[index]['id'].toString(),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.info,
                                color: Colors.green,
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
            child: Custom_Button(
              onPressedFunction: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Create_CLO()));
              },
              BackgroundColor: Colors.green,
              ForegroundColor: Colors.white,
              ButtonText: "Create CLO",
              ButtonWidth: 160,
            ),
          )
        ],
      ),
    );
  }
}