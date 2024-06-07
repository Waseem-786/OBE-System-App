import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'PEO.dart'; // Import the PEO class
import 'Department.dart'; // Import the Department class

class Display_Generated_PEOs extends StatefulWidget {
  final List<String> peoStatements;

  Display_Generated_PEOs({required this.peoStatements});

  @override
  State<Display_Generated_PEOs> createState() => _Display_Generated_PEOsState();
}

class _Display_Generated_PEOsState extends State<Display_Generated_PEOs> {
  bool isLoading = false;
  TextEditingController commentController = TextEditingController();

  Future<String?> _showCommentDialog() async {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter additional message'),
          content: TextFormField(
            controller: commentController,
            decoration: const InputDecoration(hintText: "Optional message"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(commentController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          "Generated PEOs",
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generated Program Educational Objectives (PEOs)',
              style: CustomTextStyles.headingStyle(fontSize: 22, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.peoStatements.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PEO ${index + 1}',
                            style: CustomTextStyles.headingStyle(fontSize: 18, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.peoStatements[index],
                            style: CustomTextStyles.bodyStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Custom_Button(
                  onPressedFunction: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await PEO.createGeneratedPEOs(widget.peoStatements, Department.id);

                    setState(() {
                      isLoading = false;
                    });

                    Navigator.of(context).pop();
                  },
                  BackgroundColor: Colors.green,
                  ForegroundColor: Colors.white,
                  ButtonText: "OK",
                  ButtonHeight: 50,
                  ButtonWidth: 150,
                ),
                Custom_Button(
                  onPressedFunction: () async {
                    final comment = await _showCommentDialog();
                    if (comment == null) return;

                    setState(() {
                      isLoading = true;
                    });
                    String? comments = comment;
                    int numOfPEOs = widget.peoStatements.length;
                    String? peoStatements = await PEO.Generate_PEOs(numOfPEOs, comments, Department.id);
                    if (peoStatements != null) {
                      List<String> peoList = peoStatements.split('\n').where((peo) => peo.trim().isNotEmpty).toList();
                      setState(() {
                        isLoading = false;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Display_Generated_PEOs(peoStatements: peoList),
                          ),
                        );
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to generate PEO'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    }
                  },
                  BackgroundColor: const Color(0xffc19a6b),
                  ForegroundColor: Colors.white,
                  ButtonText: "Regenerate",
                  ButtonHeight: 50,
                  ButtonWidth: 150,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
