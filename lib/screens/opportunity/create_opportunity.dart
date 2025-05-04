import 'package:flutter/material.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/models/opportunity.dart';
import 'package:leads_management_app/widgets/appbar.dart';

class CreateOpportunityScreen extends StatefulWidget {
  final List<Lead> leads;
  const CreateOpportunityScreen({super.key, required this.leads});

  @override
  State<CreateOpportunityScreen> createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  String opportunityName = '';
  String expectedRevenue = '';
  Lead? selectedLead;
  String stage = 'Proposition';
  DateTime? expectedClosingDate;

  List<String> stageOptions = [
    'New',
    'Qualified',
    'Proposition',
    'Won',
    'Lost',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Opportunity'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Opportunity *'),
                onChanged: (val) => opportunityName = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Expected Revenue',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => expectedRevenue = val,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Lead>(
                value: selectedLead,
                items: widget.leads.map((lead) {
                  return DropdownMenuItem(value: lead, child: Text(lead.name));
                }).toList(),
                onChanged: (lead) {
                  setState(() => selectedLead = lead);
                },
                decoration: const InputDecoration(labelText: 'Linked Lead'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: stage,
                items: stageOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => stage = val);
                  }
                },
                decoration: const InputDecoration(labelText: 'Stage'),
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Expected Closing Date'),
                subtitle: Text(
                  expectedClosingDate != null
                      ? expectedClosingDate.toString().split(' ')[0]
                      : 'Tap to select date',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => expectedClosingDate = picked);
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final newOpportunity = Opportunity(
                      name: opportunityName,
                      lead: selectedLead,
                      date: expectedClosingDate?.toString().split(' ')[0] ?? '',
                      stage: stage,
                      expectedRevenue: double.tryParse(expectedRevenue) ?? 0.0,
                    );
                    Navigator.pop(context, newOpportunity);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
