import 'package:flutter/material.dart';
import 'package:login_screen/Custom_Widgets/Custom_Text_Style.dart';
import 'PEO.dart';
import 'Department.dart';

class ShowPEOConsistencyPage extends StatefulWidget {
  @override
  _ShowPEOConsistencyPageState createState() => _ShowPEOConsistencyPageState();
}

class _ShowPEOConsistencyPageState extends State<ShowPEOConsistencyPage> {
  late Future<Map<String, dynamic>> consistencyData;

  final List<Color> colorPalette = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.amber
  ];

  @override
  void initState() {
    super.initState();
    consistencyData = PEO.getPEOConsistency(Department.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffc19a6b),
        title: Text(
          "PEO Consistency",
          style: CustomTextStyles.headingStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: consistencyData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No consistency data found.'));
            } else {
              final data = snapshot.data!;
              final visionsAndMissions = data['visions_and_missions'] as Map<String, dynamic>;
              final peos = data['peos'] as Map<String, dynamic>;
              final consistency = data['consistency'] as Map<String, dynamic>;

              return ListView(
                children: [
                  _buildLegend(peos.keys.toList()),
                  const SizedBox(height: 20),
                  _buildVisionMissionSection('University Vision', visionsAndMissions['university_vision'], consistency),
                  _buildVisionMissionSection('University Mission', visionsAndMissions['university_mission'], consistency),
                  _buildVisionMissionSection('Campus Vision', visionsAndMissions['campus_vision'], consistency),
                  _buildVisionMissionSection('Campus Mission', visionsAndMissions['campus_mission'], consistency),
                  _buildVisionMissionSection('Department Vision', visionsAndMissions['department_vision'], consistency),
                  _buildVisionMissionSection('Department Mission', visionsAndMissions['department_mission'], consistency),
                  const SizedBox(height: 20),
                  ...peos.keys.map((peo) {
                    final consistencyDetails = consistency[peo] as Map<String, dynamic>;
                    final peoStatement = peos[peo] as String;
                    return _buildPEOCard(peo, peoStatement, consistencyDetails, peos.keys.toList());
                  }).toList(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLegend(List<String> peoKeys) {
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
              'Legend',
              style: CustomTextStyles.headingStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            ...peoKeys.asMap().entries.map((entry) {
              int idx = entry.key;
              String peo = entry.value;
              return _buildLegendItem(peo, colorPalette[idx % colorPalette.length]);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: CustomTextStyles.bodyStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildVisionMissionSection(String title, String? content, Map<String, dynamic> consistency) {
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
              title,
              style: CustomTextStyles.headingStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            content != null
                ? _buildHighlightedText(content, consistency)
                : Text(
              'No data available',
              style: CustomTextStyles.bodyStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, Map<String, dynamic> consistency) {
    final List<TextSpan> children = [];

    final words = text.split(' ');
    for (final word in words) {
      Color? color;

      consistency.forEach((peo, details) {
        final peoDetails = details as Map<String, dynamic>;
        if (peoDetails.values.any((detail) {
          final keywords = detail['keywords'] as List<dynamic>;
          return keywords.contains(word.toLowerCase());
        })) {
          color ??= _getColorForPEO(peo, consistency.keys.toList());
        }
      });

      children.add(
        TextSpan(
          text: '$word ',
          style: CustomTextStyles.bodyStyle(
            fontSize: 16,
            color: color ?? Colors.black87,
            fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(children: children),
    );
  }

  Widget _buildPEOCard(String peo, String peoStatement, Map<String, dynamic> consistencyDetails, List<String> peoKeys) {
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
              peo,
              style: CustomTextStyles.headingStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                peoStatement,
                style: CustomTextStyles.bodyStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            _buildConsistencyDetail('University Vision', consistencyDetails['uni_vision'], peoKeys),
            _buildConsistencyDetail('University Mission', consistencyDetails['uni_mission'], peoKeys),
            _buildConsistencyDetail('Campus Vision', consistencyDetails['camp_vision'], peoKeys),
            _buildConsistencyDetail('Campus Mission', consistencyDetails['camp_mission'], peoKeys),
            _buildConsistencyDetail('Department Vision', consistencyDetails['dept_vision'], peoKeys),
            _buildConsistencyDetail('Department Mission', consistencyDetails['dept_mission'], peoKeys),
          ],
        ),
      ),
    );
  }

  Widget _buildConsistencyDetail(String label, Map<String, dynamic> detail, List<String> peoKeys) {
    final overlap = detail['overlap'];
    final total = detail['total'];
    final percentage = detail['percentage'];
    final keywords = detail['keywords'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: CustomTextStyles.bodyStyle(fontSize: 16, color: Colors.black),
          ),
          Text(
            '$overlap / $total keywords match ($percentage%)',
            style: CustomTextStyles.bodyStyle(fontSize: 16, color: Colors.blue),
          ),
          Text(
            'Keywords: ${keywords.join(', ')}',
            style: CustomTextStyles.bodyStyle(fontSize: 16, color: Colors.purple),
          ),
        ],
      ),
    );
  }

  Color _getColorForPEO(String peo, List<String> peoKeys) {
    int idx = peoKeys.indexOf(peo);
    return colorPalette[idx % colorPalette.length];
  }
}
