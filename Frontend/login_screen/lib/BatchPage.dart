import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/Custom_Widgets/PermissionBasedButton.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/Permission.dart';
import 'package:login_screen/SectionPage.dart';
import 'CreateBatch.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/PermissionBasedIcon.dart';

class BatchPage extends StatefulWidget {
  const BatchPage({super.key});

  @override
  State<BatchPage> createState() => _BatchPageState();
}

class _BatchPageState extends State<BatchPage> {

  final int department_id = Department.id;
  late Future<List<dynamic>> batchFuture;
  late Future<bool> hasEditBatchPermissionFuture;
  late Future<bool> hasAddBatchPermissionFuture;

  @override
  void initState() {
    super.initState();
    batchFuture = Batch.getBatchBydeptId(Department.id);
    hasAddBatchPermissionFuture = Permission.searchPermissionByCodename("add_batch");
    hasEditBatchPermissionFuture = Permission.searchPermissionByCodename("change_batch");
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        batchFuture = Batch.getBatchBydeptId(Department.id);
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
                                  trailing: PermissionBasedIcon(
                                    iconData: Icons.edit_square,
                                    enabledColor:
                                    Color(0xffc19a6b), // Your desired enabled color
                                    disabledColor: Colors.grey,
                                    permissionFuture: hasEditBatchPermissionFuture,
                                    onPressed: () async {
                                      var batchData = await Batch.getBatchbyBatchId(batches[index]['id']);

                                      if (batchData != null) {
                                        Batch.id = batchData['id'];
                                        Batch.name = batchData['name'];
                                        Batch.sections = batchData['sections'];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<bool>(
                                              builder: (context) => CreateBatch(
                                                isUpdate: true,
                                                batchData: batchData,
                                              ),
                                            )).then((result) {
                                          if (result != null && result) {
                                            // Set the state of the page here
                                            setState(() {
                                              batchFuture = Batch.getBatchBydeptId(department_id);
                                            });
                                          }
                                        });
                                        // Perform actions with campusData
                                      }
                                    },
                                  ),
                                  onTap: () async {
                                    // Ensure batches[index]['id'] is not null before proceeding
                                    if (batches[index]['id'] != null) {
                                      // Call getBatchbyBatchId only if id is not null
                                      var batchData = await Batch.getBatchbyBatchId(batches[index]['id']);

                                      if (batchData != null) {
                                        Batch.id = batchData['id'];
                                        Batch.name = batchData['name'];
                                        Batch.sections = batchData['sections'];

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<bool>(
                                            builder: (context) => SectionPage(),
                                          ),
                                        ).then((result) {
                                          if (result != null && result) {
                                            // Set the state of the page here
                                            setState(() {
                                              batchFuture = Batch.getBatchBydeptId(Department.id);
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
            PermissionBasedButton(
                buttonText: "Add Batch",
                buttonWidth: 180,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBatch()),),
                permissionFuture: hasAddBatchPermissionFuture
            )
          ],
        ),
      ),

    );
  }
}
