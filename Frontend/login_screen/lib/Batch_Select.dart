import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen/Batch.dart';
import 'package:login_screen/Campus.dart';
import 'package:login_screen/Course.dart';
import 'package:login_screen/Course_Page.dart';
import 'package:login_screen/Course_Select.dart';
import 'package:login_screen/Department.dart';
import 'package:login_screen/PEO_Page.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class Batch_Select extends StatefulWidget {
  static bool isForAssessment = false;

  @override
  State<Batch_Select> createState() => _Batch_SelectState();
}

class _Batch_SelectState extends State<Batch_Select> {
  final int department_id = Department.id;
  late Future<List<dynamic>> batchFuture;

  @override
  void initState() {
    super.initState();
    batchFuture = Batch.getBatchBydeptId(department_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Center(
          child: Text('Batch Select Page',
              style: CustomTextStyles.headingStyle(fontSize: 22)),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: batchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
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
                            child: Text(batch['name'],
                                style:
                                CustomTextStyles.bodyStyle(fontSize: 17)),
                          ),
                          onTap: () async {
                            var batchData = await Batch.getBatchbyBatchId(batches[index]['id']);
                            if (batchData != null) {
                              Batch.id = batchData['id'];
                              Batch.name = batchData['name'];

                              if(Batch_Select.isForAssessment){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Course_Select()));
                              }
                              // Perform actions with campusData
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
