import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedFilter = 'This Month';

  final List<String> filters = [
    'This Month',
    'This Year',
    'Last 3 Months',
    'Last 6 Months',
  ];

  final opportunitySummary = {'Created': 45, 'Won': 18, 'Lost': 12};

  final topOpportunities = [
    {'name': 'Opportunity A', 'customer': 'ABC Corp', 'amount': 12000},
    {'name': 'Opportunity B', 'customer': 'XYZ Ltd', 'amount': 10500},
    {'name': 'Opportunity C', 'customer': 'Acme Inc', 'amount': 9800},
    {'name': 'Opportunity D', 'customer': 'Delta Group', 'amount': 8700},
    {'name': 'Opportunity E', 'customer': 'Nexus LLC', 'amount': 8600},
  ];

  final stageData = {
    'New': 10,
    'Qualified': 15,
    'Proposal': 8,
    'Won': 18,
    'Lost': 12,
  };

  final stageRevenue = {
    'New': 3000,
    'Qualified': 7500,
    'Proposal': 6000,
    'Won': 18000,
    'Lost': 4000,
  };

  Widget _buildSummaryCard(String label, int value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopOpportunityCard(Map<String, dynamic> opportunity) {
    return Card(
      color: AppColor.cardBackground,
      child: ListTile(
        title: Text(opportunity['name']),
        subtitle: Text(opportunity['customer']),
        trailing: Text('R ${opportunity['amount']}'),
      ),
    );
  }

  Widget _buildBarChart(Map<String, int> data, {bool isRevenue = false}) {
    return Column(
      children: data.entries.map((entry) {
        final percent =
            (entry.value / (data.values.reduce((a, b) => a > b ? a : b))) * 100;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(width: 80, child: Text(entry.key)),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: percent.isNaN ? 0 : percent,
                      decoration: BoxDecoration(
                        color: isRevenue ? Colors.orange : Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(isRevenue ? 'R ${entry.value}' : '${entry.value}'),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: selectedFilter,
                  items: filters
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedFilter = val!),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Summary
            Row(
              children: [
                _buildSummaryCard(
                  'Created',
                  opportunitySummary['Created']!,
                  Colors.blue,
                ),
                _buildSummaryCard(
                  'Won',
                  opportunitySummary['Won']!,
                  Colors.green,
                ),
                _buildSummaryCard(
                  'Lost',
                  opportunitySummary['Lost']!,
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Top Opportunities
            const Text(
              'Top 5 Opportunities',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...topOpportunities.map(_buildTopOpportunityCard).toList(),

            const SizedBox(height: 24),

            // Lead Stage Report
            const Text(
              'Opportunity Lead Stage Report',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildBarChart(stageData),

            const SizedBox(height: 24),

            // Lead Stage Vs Revenue
            const Text(
              'Lead Stage vs Revenue Report',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildBarChart(stageRevenue, isRevenue: true),
          ],
        ),
      ),
    );
  }
}
