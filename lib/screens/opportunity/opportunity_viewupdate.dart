import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/appbar.dart';

class OpportunityViewUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> opportunity;

  const OpportunityViewUpdateScreen({super.key, required this.opportunity});

  @override
  State<OpportunityViewUpdateScreen> createState() =>
      _OpportunityViewUpdateScreenState();
}

class _OpportunityViewUpdateScreenState
    extends State<OpportunityViewUpdateScreen> {
  late TextEditingController nameController;
  late TextEditingController revenueController;
  late TextEditingController probabilityController;
  late TextEditingController customerController;
  late String selectedStage;

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
    nameController = TextEditingController(text: widget.opportunity['name']);
    revenueController = TextEditingController(
      text: widget.opportunity['revenue'].toString(),
    );
    probabilityController = TextEditingController(
      text: widget.opportunity['probability'] ?? '',
    );
    customerController = TextEditingController(
      text: widget.opportunity['customer'] ?? '',
    );
    selectedStage = widget.opportunity['stage'];
  }

  @override
  void dispose() {
    nameController.dispose();
    revenueController.dispose();
    probabilityController.dispose();
    customerController.dispose();
    super.dispose();
  }

  void updateOpportunity() {
    String name = nameController.text.trim();
    String revenueText = revenueController.text.trim();
    String probability = probabilityController.text.trim();
    String customer = customerController.text.trim();

    if (name.isEmpty ||
        revenueText.isEmpty ||
        probability.isEmpty ||
        customer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields.'),
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

    final updatedOpportunity = {
      ...widget.opportunity,
      'name': name,
      'revenue': revenue,
      'probability': probability,
      'customer': customer,
      'stage': selectedStage,
    };

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
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Opportunity Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Creation Date: ${widget.opportunity['date']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: customerController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: revenueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Revenue',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: probabilityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Probability (%)',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
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
