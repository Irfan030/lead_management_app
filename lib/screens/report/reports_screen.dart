import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/defaultDropDown.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedFilter = 'This Month';

  final List<String> filters = const [
    'This Month',
    'This Year',
    'Last 3 Months',
    'Last 6 Months',
  ];

  final opportunitySummary = const {'Created': 45, 'Won': 18, 'Lost': 12};

  final topOpportunities = const [
    {'name': 'Opportunity A', 'customer': 'ABC Corp', 'amount': 12000},
    {'name': 'Opportunity B', 'customer': 'XYZ Ltd', 'amount': 10500},
    {'name': 'Opportunity C', 'customer': 'Acme Inc', 'amount': 9800},
    {'name': 'Opportunity D', 'customer': 'Delta Group', 'amount': 8700},
    {'name': 'Opportunity E', 'customer': 'Nexus LLC', 'amount': 8600},
  ];

  final stageData = const {
    'New': 10,
    'Qualified': 15,
    'Proposal': 8,
    'Won': 18,
    'Lost': 12,
  };

  final stageRevenue = const {
    'New': 3000,
    'Qualified': 7500,
    'Proposal': 6000,
    'Won': 18000,
    'Lost': 4000,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),

            // Filter Section

            _buildFilterSection(),
            const SizedBox(height: 16),

            // Summary Section
            _buildSummarySection(),
            const SizedBox(height: 24),

            // Top Opportunities Section
            _buildTopOpportunitiesSection(),
            const SizedBox(height: 24),

            // Lead Stage Report Section
            _buildLeadStageReportSection(),
            const SizedBox(height: 24),

            // Lead Stage vs Revenue Section
            _buildLeadStageRevenueSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 200,
          child: DefaultDropDown<String>(
            hint: 'Select Filter',
            label: 'Filter',
            value: selectedFilter,
            listValues: filters,
            onChange: (value) => setState(() => selectedFilter = value),
            getDisplayText: (value) => value,
            getValue: (value) => value,
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Row(
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
    );
  }

  Widget _buildSummaryCard(String label, int value, Color color) {
    return Expanded(
      child: Card(
        color: color.withAlphaDouble(0.2),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TitleWidget(
                val: value.toString(),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              const SizedBox(height: 4),
              TitleWidget(
                val: label,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopOpportunitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(
          val: 'Top 5 Opportunities',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        ...topOpportunities.map(_buildTopOpportunityCard).toList(),
      ],
    );
  }

  Widget _buildTopOpportunityCard(Map<String, dynamic> opportunity) {
    return Card(
      color: AppColor.whiteColor,
      child: ListTile(
        title: TitleWidget(
          val: opportunity['name'],
          color: AppColor.textPrimary,
        ),
        subtitle: TitleWidget(
          val: opportunity['customer'],
          color: AppColor.textSecondary,
        ),
        trailing: TitleWidget(
          val: 'R ${opportunity['amount']}',
          color: AppColor.textPrimary,
        ),
      ),
    );
  }

  Widget _buildLeadStageReportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(
          val: 'Opportunity Lead Stage Report',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        _buildBarChart(stageData),
      ],
    );
  }

  Widget _buildLeadStageRevenueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(
          val: 'Lead Stage vs Revenue Report',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        _buildBarChart(stageRevenue, isRevenue: true),
      ],
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
              SizedBox(
                width: 80,
                child: TitleWidget(
                  val: entry.key,
                  color: AppColor.textPrimary,
                ),
              ),
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
              TitleWidget(
                val: isRevenue ? 'R ${entry.value}' : '${entry.value}',
                color: AppColor.textPrimary,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
