import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/CLO_PLO_Mapping.dart';

import 'CLO.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Show_CLO_PLO_Mapping extends StatefulWidget {
  @override
  State<Show_CLO_PLO_Mapping> createState() => _Show_CLO_PLO_MappingState();
}

class _Show_CLO_PLO_MappingState extends State<Show_CLO_PLO_Mapping> {
  late Future<List<Map<String, dynamic>>> mappedData;

  @override
  void initState() {
    super.initState();
    mappedData = CLO.fetchMappedCLOPLOData();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        mappedData = CLO.fetchMappedCLOPLOData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffc19a6b),
          title: Text('Mapped CLOs PLOs',
              style: CustomTextStyles.headingStyle(fontSize: 22)),
        ),
        body: Column(
          children: [
            Container(
              height: 650,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: mappedData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<Map<String, dynamic>> mappedItems =
                    snapshot.data!;
                    return ListView.builder(
                      itemCount: mappedItems.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> item = mappedItems[index];
                        return Card(
                          color: Colors.white,
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text("CLO ${item['clo']} is mapped with: ", style: CustomTextStyles.bodyStyle(fontSize: 17)),
                            ),
                            trailing:  Padding(
                              padding: const EdgeInsets.all( 15.0),
                              child: Text("PLO ${item['plo']}", style: CustomTextStyles.bodyStyle(fontSize: 17)),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20, top: 12),
                child: Custom_Button(
                  onPressedFunction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CLO_PLO_Mapping()),
                    ).then((result) {
                      if (result != null && result) {
                        // Set the state of the page here
                        setState(() {
                          mappedData = CLO.fetchMappedCLOPLOData();
                        });
                      }
                    });
                  },
                  ButtonText: 'Map',
                  ButtonWidth: 100,
                ),
              ),
            ),
          ],
        ));
  }
}