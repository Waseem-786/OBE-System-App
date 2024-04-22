import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/CLO_Profile.dart';

import 'Create_CLO.dart';
import 'Create_PLO.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'PLO.dart';
import 'PLO_Profile.dart';

class PLO_Page extends StatefulWidget {
  @override
  State<PLO_Page> createState() => _PLO_PageState();
}

class _PLO_PageState extends State<PLO_Page> {
  late Future<List<dynamic>> ploFuture;

  @override
  void initState() {
    super.initState();
    ploFuture = PLO.fetchPLO();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc19a6b),
        title: Container(
          margin: EdgeInsets.only(left: 90),
          child: Text(
            "PLO Page",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: ploFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final plos = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: plos.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          var user = await PLO.getPLObyPLOId(plos[index]['id']);
                          if (user != null) {
                            PLO.id = user['id'];
                            PLO.name=user['name'];
                            PLO.description = user['description'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  PLO_Profile()),
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
                                plos[index]['id'].toString(),
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
                    MaterialPageRoute(builder: (context) => Create_PLO()));
              },
              BackgroundColor: Colors.green,
              ForegroundColor: Colors.white,
              ButtonText: "Create PLO",
              ButtonWidth: 160,
            ),
          )
        ],
      ),
    );
  }
}
