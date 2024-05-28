
import 'package:flutter/material.dart';
import 'package:login_screen/Permission.dart';

import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Role.dart';

class Group_Permissions extends StatefulWidget {
  const Group_Permissions({super.key});

  @override
  State<Group_Permissions> createState() => _Group_PermissionsState();
}

class _Group_PermissionsState extends State<Group_Permissions> {

  late Future<List<dynamic>> permissionFuture;

  void initState() {
    super.initState();
    permissionFuture = Permission.fetchPermissionsbyGroupId(Role.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the current route is the route you're returning from
    ModalRoute? currentRoute = ModalRoute.of(context);
    if (currentRoute != null && currentRoute.isCurrent) {
      // Call your refresh function here
      setState(() {
        permissionFuture = Permission.fetchPermissionsbyGroupId(Role.id);
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
            'Group Permissions Page',
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: permissionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final permissions = snapshot.data!;
                    return Expanded(
                        child: ListView.builder(
                            itemCount: permissions.length,
                            itemBuilder: (context, index) {
                              final permission = permissions[index];
                              final name = permission['name'];
                              return Card(
                                color: Colors.white,
                                elevation: 5,
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      '${(index+1).toString()}. $name',
                                      style: CustomTextStyles.bodyStyle(
                                          fontSize: 17),
                                    ),
                                  ),
                                  // onTap: () async { // },
                                ),
                              );
                            }));
                  }
                }),
          ],
        ),
      ),

    );
  }
}
