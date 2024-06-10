import 'package:flutter/material.dart';
import 'package:login_screen/Campus.dart';
import 'Approval.dart';
import 'Create_Approval_Chain.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';
import 'Permission.dart';

class Approval_Chain extends StatefulWidget {
  @override
  _ApprovalChainState createState() => _ApprovalChainState();
}

class _ApprovalChainState extends State<Approval_Chain> {
  late Future<List<dynamic>> _approvalChainsFuture;
  late Future<bool> hasEditCoursePermissionFuture;
  late Future<bool> hasAddCoursePermissionFuture;

  @override
  void initState() {
    super.initState();
    _approvalChainsFuture = Approval.getApprovalChainsByCampus(Campus.id);
    hasEditCoursePermissionFuture =
        Permission.searchPermissionByCodename("edit_approvalchain");
    hasAddCoursePermissionFuture =
        Permission.searchPermissionByCodename("add_approvalchain");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        _approvalChainsFuture = Approval.getApprovalChainsByCampus(Campus.id);
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
            'Approval Chains for Campus ${Campus.name}',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _approvalChainsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final approval_chains = snapshot.data!;
                  if (approval_chains.length == 0) {
                    return Center(
                      child: Text('No Approval chains found'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: approval_chains.length,
                      itemBuilder: (context, index) {
                        final chain = approval_chains[index];
                        return Card(
                          color: Colors.white,
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                chain['description'],
                                style: CustomTextStyles.bodyStyle(
                                    fontSize: 17),
                              ),
                            ),
                            onTap: () async {},
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PermissionBasedButton(
              buttonText: "Add Approval Chain",
              buttonWidth: 250,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Create_Approval_Chain(),
                  ),
                );
              },
              permissionFuture: hasAddCoursePermissionFuture,
            ),
          ),
        ],
      ),
    );
  }
}
