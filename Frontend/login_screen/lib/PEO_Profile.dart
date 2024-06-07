import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Button.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';
import 'Custom_Widgets/DeleteAlert.dart';
import 'Custom_Widgets/DetailCard.dart';
import 'Custom_Widgets/PermissionBasedButton.dart';
import 'PEO.dart';
import 'Permission.dart';

class PEO_Profile extends StatefulWidget {
  @override
  State<PEO_Profile> createState() => _PEO_ProfileState();
}

class _PEO_ProfileState extends State<PEO_Profile> {
  final peoId = PEO.id;
  String? errorMessage;
 //variable to show the error when the wrong credentials are entered or the fields are empty
  Color colorMessage = Colors.red;
 // color of the message when the error occurs
  var isLoading = false;
  late Future<bool> hasDeletePEOPermissionFuture;

  @override
  void initState() {
    super.initState();
    hasDeletePEOPermissionFuture = Permission.searchPermissionByCodename("delete_peo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text('PEO Profile', style: CustomTextStyles.headingStyle(fontSize: 22)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade200,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text("PEO Details", style: CustomTextStyles.headingStyle())),
              const SizedBox(height: 20),
              ..._buildPEOInfoCards(),
              SizedBox(height: 20),
              Center(child: _actionButtons()),
              SizedBox(height: 10),
              Center(
                child: Visibility(
                  visible: isLoading,
                  child: const CircularProgressIndicator(),
                ),
              ),
              if (errorMessage != null)
                Center(
                  child: Text(errorMessage!,
                      style: CustomTextStyles.bodyStyle(color: colorMessage)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPEOInfoCards() {
    return [
      DetailCard(label: "PEO Description", value: PEO.description, icon: Icons.school,)

    ];
  }

  Widget _actionButtons() {
    return Column(
      children: [
        PermissionBasedButton(
          buttonText: "Delete",
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          buttonWidth: 120,
          onPressed: () => _confirmDelete(context),
          permissionFuture: hasDeletePEOPermissionFuture,
        ),
      ],
    );
  }


  Future<void> _confirmDelete(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: "Confirm Deletion",
        content: "Are you sure you want to delete this PEO?",
      ),
    );
    if (confirmDelete) {
      setState(() => isLoading = true);
      bool deleted = await PEO.deletePEO(peoId);
      if (deleted) {
        setState(() {
          isLoading = false;
          colorMessage = Colors.green;
          errorMessage = 'PEO deleted successfully';
        });
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          isLoading = false;
          colorMessage = Colors.red;
          errorMessage = 'Failed to delete peo';
        });
      }
    }
  }
}
