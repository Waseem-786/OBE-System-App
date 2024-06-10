import 'package:flutter/material.dart';
import 'Custom_Widgets/Custom_Text_Style.dart';

class CLO_Update_Report extends StatelessWidget {
  final List<Map<String, dynamic>> previousCLOs;
  final List<Map<String, dynamic>> newCLOs;
  final String justification;

  const CLO_Update_Report({
    Key? key,
    required this.previousCLOs,
    required this.newCLOs,
    required this.justification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          "CLO Change Justification",
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Previous CLOs'),
              SizedBox(height: 10),
              _buildCLOTable(previousCLOs),
              SizedBox(height: 20),
              _buildSectionHeader('New CLOs'),
              SizedBox(height: 10),
              _buildCLOTable(newCLOs),
              SizedBox(height: 20),
              _buildSectionHeader('Justification'),
              SizedBox(height: 10),
              _buildJustification(justification),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement update logic here
                  },
                  child: Text('Confirm Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildJustification(String justification) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(justification),
    );
  }

  Widget _buildCLOTable(List<Map<String, dynamic>> clos) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16.0,
        columns: [
          DataColumn(
            label: Text('Description'),
          ),
          DataColumn(
            label: Text('PLOs'),
          ),
          DataColumn(
            label: Text('Bloom Taxonomy'),
          ),
          DataColumn(
            label: Text('Level'),
          ),
        ],
        rows: clos.map((clo) {
          return DataRow(
            cells: [
              DataCell(Text(clo['description'])),
              DataCell(Text(clo['plo'].join(', '))),
              DataCell(Text(clo['bloom_taxonomy'])),
              DataCell(Text(clo['level'].toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}
