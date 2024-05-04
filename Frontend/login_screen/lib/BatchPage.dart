
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/SectionPage.dart';
import 'CreateBatch.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class BatchPage extends StatefulWidget {
  const BatchPage({super.key});

  @override
  State<BatchPage> createState() => _BatchPageState();
}

class _BatchPageState extends State<BatchPage> {

  late Future<List<dynamic>> batchFuture;

  @override
  void initState() {
    super.initState();
    batchFuture = Batch.fetchBatchBydeptId(Department.id);
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        batchFuture = Batch.fetchBatchBydeptId(Department.id);
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
            'Batch Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: batchFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final batches = snapshot.data!;
                    return Expanded(
                        child: ListView.builder(
                            itemCount: batches.length,
                            itemBuilder: (context, index) {
                              final batch = batches[index];
                              return Card(
                                color: Colors.white,
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      batch['name'],
                                      style: CustomTextStyles.bodyStyle(
                                          fontSize: 17),
                                    ),
                                  ),
                                  onTap: () async {
                                    // Ensure batches[index]['id'] is not null before proceeding
                                    if (batches[index]['id'] != null) {
                                      // Call getBatchbyBatchId only if id is not null
                                      var batch = await Batch.getBatchbyBatchId(batches[index]['id']);

                                      if (batch != null) {
                                        Batch.id = batch['id'];
                                        Batch.name = batch['name'];
                                        Batch.sections = batch['section_names'];

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<bool>(
                                            builder: (context) => SectionPage(),
                                          ),
                                        ).then((result) {
                                          if (result != null && result) {
                                            // Set the state of the page here
                                            setState(() {
                                              batchFuture = Batch.fetchBatchBydeptId(Department.id);
                                            });
                                          }
                                        });
                                      }
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
                      MaterialPageRoute(builder: (context) => CreateBatch()),
                    );
                  },
                  ButtonText: 'Add Batch',
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
