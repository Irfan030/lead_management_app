import 'package:flutter/material.dart';
import 'package:leads_management_app/models/dummy_leads.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/models/opportunity.dart';
import 'package:leads_management_app/widgets/appbar.dart';

class CreateOpportunityScreen extends StatefulWidget {
  const CreateOpportunityScreen({Key? key}) : super(key: key);

  @override
  State<CreateOpportunityScreen> createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<Lead> _leads;
  String _name = '';
  Lead? _selectedLead;
  DateTime? _date;
  String? _stage;
  double _expectedRevenue = 0.0;
  String? _probability;
  String? _description;
  String? _notes;

  final List<String> _stages = [
    'New',
    'Qualified',
    'Proposal',
    'Negotiation',
    'Closed Won',
    'Closed Lost',
  ];

  @override
  void initState() {
    super.initState();
    _leads = getDummyLeads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Opportunity'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Opportunity Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              _buildTextField('Name',
                  onChanged: (v) => _name = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Name required' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<Lead?>(
                value: _selectedLead,
                decoration: const InputDecoration(
                    labelText: 'Lead', border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ..._leads.map((lead) =>
                      DropdownMenuItem(value: lead, child: Text(lead.name))),
                ],
                onChanged: (value) => setState(() => _selectedLead = value),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                      labelText: 'Date', border: OutlineInputBorder()),
                  child: Text(
                      _date != null ? _formatDate(_date!) : 'Select date',
                      style: TextStyle(
                          color: _date != null ? Colors.black : Colors.grey)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _stage,
                decoration: const InputDecoration(
                    labelText: 'Stage', border: OutlineInputBorder()),
                items: _stages
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setState(() => _stage = value),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                'Expected Revenue',
                keyboardType: TextInputType.number,
                onChanged: (v) => _expectedRevenue = double.tryParse(v) ?? 0.0,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField('Probability',
                  onChanged: (v) => _probability = v),
              const SizedBox(height: 16),
              _buildTextField('Description',
                  onChanged: (v) => _description = v, maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField('Notes',
                  onChanged: (v) => _notes = v, maxLines: 3),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Create Opportunity',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {String? initialValue,
      TextInputType? keyboardType,
      int maxLines = 1,
      String? Function(String?)? validator,
      required Function(String) onChanged}) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: validator,
      onChanged: onChanged,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedLead != null &&
        _date != null &&
        _stage != null) {
      final newOpportunity = Opportunity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        lead: _selectedLead,
        date: _formatDate(_date!),
        stage: _stage,
        expectedRevenue: _expectedRevenue,
        probability: _probability,
        description: _description,
        notes: _notes,
      );
      Navigator.pop(context, newOpportunity);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
