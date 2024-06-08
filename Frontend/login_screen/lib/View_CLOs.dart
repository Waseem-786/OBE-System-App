import 'package:flutter/material.dart';
import 'package:login_screen/CLO.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'Course.dart';
import 'Create_CLO.dart';
import 'Create_Weekly_Topic.dart'; // Import the CreateWeeklyTopic page

class View_CLOs extends StatefulWidget {
  final bool isFromOutline;

  View_CLOs({this.isFromOutline = false});

  @override
  State<View_CLOs> createState() => _View_CLOsState();
}

class _View_CLOsState extends State<View_CLOs> {
  int Course_id = Course.id;
  String? errorMessage;
  var isLoading = false;
  List<Map<String, dynamic>> existingCLOs = [];

  @override
  void initState() {
    super.initState();
    _loadExistingCLOs();
  }

  Future<void> _loadExistingCLOs() async {
    setState(() {
      isLoading = true;
    });

    try {
      final clos = await CLO.fetchCLO(Course_id);
      print(clos);
      setState(() {
        existingCLOs = clos.map((clo) => {
          'description': clo['description'],
          'bloom_taxonomy': clo['bloom_taxonomy'],
          'level': clo['level'].toString(),
          'plos': clo['plo']
        }).toList();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load existing CLOs';
      });
    }
  }

  void _showUpdateCLOForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Create_CLO()),
    );
  }

  void _navigateToWeeklyTopic() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateWeeklyTopic(isFromOutline: true,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            "View CLOs",
            style: CustomTextStyles.headingStyle(fontSize: 20),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const CircularProgressIndicator(),
                ] else ...[
                  Text(
                    "Existing CLOs",
                    style: CustomTextStyles.headingStyle(fontSize: 20, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  ...existingCLOs.map((clo) {
                    return Card(
                      elevation: 4,
                      shadowColor: Colors.black45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        title: Text(
                          clo['description'],
                          style: CustomTextStyles.headingStyle(fontSize: 18, color: Colors.black87),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Bloom Taxonomy: ${clo['bloom_taxonomy']}",
                              style: CustomTextStyles.bodyStyle(color: Colors.black54),
                            ),
                            Text(
                              "BT Level: ${clo['level']}",
                              style: CustomTextStyles.bodyStyle(color: Colors.black54),
                            ),
                            Text(
                              "PLOs: ${clo['plos'].join(', ')}",
                              style: CustomTextStyles.bodyStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  Custom_Button(
                    onPressedFunction: _showUpdateCLOForm,
                    ButtonText: "Update CLOs",
                    ButtonIcon: Icons.update,
                    ForegroundColor: Colors.white,
                    BackgroundColor: Colors.purple,
                    ButtonWidth: 200,
                    ButtonHeight: 50,
                  ),
                  if (widget.isFromOutline) ...[
                    const SizedBox(height: 20),
                    Custom_Button(
                      onPressedFunction: _navigateToWeeklyTopic,
                      ButtonText: "Next",
                      ButtonIcon: Icons.arrow_forward,
                      ForegroundColor: Colors.white,
                      BackgroundColor: Colors.brown,
                      ButtonWidth: 200,
                    ),
                  ],
                ],
                if (errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    errorMessage!,
                    style: CustomTextStyles.bodyStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
