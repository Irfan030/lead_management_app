import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/appbar.dart';
import 'package:leads_management_app/models/opportunity.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/utils/color_utils.dart';

class OpportunityViewUpdateScreen extends StatefulWidget {
  final Opportunity opportunity;
  final List<Lead> leads;

  const OpportunityViewUpdateScreen({super.key, required this.opportunity, required this.leads});

  @override
  State<OpportunityViewUpdateScreen> createState() => _OpportunityViewUpdateScreenState();
}

class _OpportunityViewUpdateScreenState extends State<OpportunityViewUpdateScreen> {
  late TextEditingController nameController;
  late TextEditingController revenueController;
  late Lead? selectedLead;
  late String selectedStage;
  late String date;

  final List<String> stages = [
    'New',
    'Qualified',
    'Proposition',
    'Won',
    'Lost',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.opportunity.name);
    revenueController = TextEditingController(text: widget.opportunity.expectedRevenue.toString());
    selectedLead = widget.opportunity.lead;
    selectedStage = widget.opportunity.stage;
    date = widget.opportunity.date;
  }

  @override
  void dispose() {
    nameController.dispose();
    revenueController.dispose();
    super.dispose();
  }

  void updateOpportunity() {
    String name = nameController.text.trim();
    String revenueText = revenueController.text.trim();

    if (name.isEmpty || revenueText.isEmpty || selectedLead == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a lead.'),
          backgroundColor: AppColor.secondaryColor,
        ),
      );
      return;
    }

    double? revenue = double.tryParse(revenueText);
    if (revenue == null || revenue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revenue must be a positive number.'),
          backgroundColor: AppColor.secondaryColor,
        ),
      );
      return;
    }

    final updatedOpportunity = Opportunity(
      name: name,
      lead: selectedLead,
      date: date,
      stage: selectedStage,
      expectedRevenue: revenue,
    );

    Navigator.pop(context, updatedOpportunity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Opportunity'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Summary Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: ColorUtils.getStageColor(selectedStage).withOpacity(0.08),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nameController.text.isNotEmpty ? nameController.text : 'Opportunity',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Chip(
                          label: Text(selectedStage),
                          backgroundColor: ColorUtils.getStageColor(selectedStage),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Revenue: \$${revenueController.text.isNotEmpty ? revenueController.text : '0.00'}', style: const TextStyle(fontSize: 16)),
                    Text('Lead: ${selectedLead?.name ?? '-'}', style: const TextStyle(fontSize: 16)),
                    Text('Date: $date', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Editable Fields
            ListTile(
              leading: const Icon(Icons.title, color: Colors.blue),
              title: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Opportunity Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: DropdownButtonFormField<Lead>(
                value: selectedLead,
                items: widget.leads.map((lead) {
                  return DropdownMenuItem(
                    value: lead,
                    child: Text(lead.name),
                  );
                }).toList(),
                onChanged: (lead) {
                  setState(() => selectedLead = lead);
                },
                decoration: const InputDecoration(labelText: 'Linked Lead', border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.orange),
              title: TextField(
                controller: revenueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Revenue',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.purple),
              title: DropdownButtonFormField<String>(
                value: selectedStage,
                items: stages.map((stage) {
                  return DropdownMenuItem<String>(
                    value: stage,
                    child: Text(stage),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Stage',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStage = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: updateOpportunity,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.mainColor,
                foregroundColor: AppColor.borderColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
