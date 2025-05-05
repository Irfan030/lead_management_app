import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/models/dummy_leads.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/models/opportunity.dart';
import 'package:leads_management_app/models/quotation.dart';
import 'package:leads_management_app/providers/quotation_provider.dart';
import 'package:leads_management_app/widgets/appbar.dart';
import 'package:provider/provider.dart';

class CreateQuotationScreen extends StatefulWidget {
  final Quotation? quotation;
  const CreateQuotationScreen({Key? key, this.quotation}) : super(key: key);

  @override
  State<CreateQuotationScreen> createState() => _CreateQuotationScreenState();
}

class _CreateQuotationScreenState extends State<CreateQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<QuotationLine> _lines = [];
  DateTime _validUntil = DateTime.now().add(const Duration(days: 30));
  String _notes = '';
  String _termsAndConditions = 'Standard terms and conditions apply';
  late final List<Lead> _leads;
  late final List<Opportunity> _opportunities;
  Lead? _selectedLead;
  Opportunity? _selectedOpportunity;

  @override
  void initState() {
    super.initState();
    _leads = getDummyLeads();
    _opportunities = [
      Opportunity(
        id: '1',
        name: 'Sample Opportunity',
        lead: _leads[0],
        expectedRevenue: 1000.00,
      ),
      Opportunity(
        id: '2',
        name: 'Big Deal',
        lead: _leads[1],
        expectedRevenue: 5000.00,
      ),
      Opportunity(
        id: '3',
        name: 'Another Opportunity',
        lead: _leads[0],
        expectedRevenue: 2000.00,
      ),
    ];
    if (widget.quotation != null) {
      final q = widget.quotation!;
      _selectedLead = q.lead;
      _selectedOpportunity = q.opportunity;
      _validUntil = q.validUntil;
      _lines.addAll(q.lines);
      _notes = q.notes;
      _termsAndConditions = q.termsAndConditions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Quotation'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Lead Selection
            _buildLeadSelection(),
            const SizedBox(height: 16),

            // Opportunity Selection
            _buildOpportunitySelection(),
            const SizedBox(height: 16),

            // Valid Until Date
            _buildDatePicker(),
            const SizedBox(height: 16),

            // Product Lines
            _buildProductLinesSection(),
            const SizedBox(height: 16),

            // Add Product Line Button
            ElevatedButton.icon(
              onPressed: _addProductLine,
              icon: const Icon(Icons.add),
              label: const Text("Add Product Line"),
            ),
            const SizedBox(height: 16),

            // Notes
            _buildTextField(
              "Notes",
              onChanged: (value) => _notes = value,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Terms and Conditions
            _buildTextField(
              "Terms and Conditions",
              initialValue: _termsAndConditions,
              onChanged: (value) => _termsAndConditions = value,
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Create Quotation"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadSelection() {
    return DropdownButtonFormField<Lead?>(
      decoration: const InputDecoration(
        labelText: "Lead",
        border: OutlineInputBorder(),
      ),
      value: _selectedLead,
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('None'),
        ),
        ..._leads.map((lead) => DropdownMenuItem(
              value: lead,
              child: Text(lead.name),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedLead = value;
          _selectedOpportunity = null;
        });
      },
    );
  }

  Widget _buildOpportunitySelection() {
    final filteredOpportunities = _selectedLead == null
        ? _opportunities
        : _opportunities.where((opp) => opp.lead == _selectedLead).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Opportunity",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Opportunity?>(
          value: _selectedOpportunity,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select an opportunity',
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('None'),
            ),
            ...filteredOpportunities.map((opp) => DropdownMenuItem(
              value: opp,
              child: Text(opp.name),
            )),
          ],
          onChanged: (value) => setState(() => _selectedOpportunity = value),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Valid Until",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _validUntil,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              setState(() => _validUntil = picked);
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            child: Text(DateFormat('yyyy-MM-dd').format(_validUntil)),
          ),
        ),
      ],
    );
  }

  Widget _buildProductLinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Lines",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ..._lines.asMap().entries.map((entry) {
          final index = entry.key;
          final line = entry.value;
          return _buildProductLineCard(index, line);
        }).toList(),
      ],
    );
  }

  Widget _buildProductLineCard(int index, QuotationLine line) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Product Name",
                    initialValue: line.productName,
                    onChanged: (value) =>
                        _updateProductLine(index, productName: value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeProductLine(index),
                ),
              ],
            ),
            _buildTextField(
              "Description",
              initialValue: line.description,
              onChanged: (value) =>
                  _updateProductLine(index, description: value),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Quantity",
                    initialValue: line.quantity.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateProductLine(
                      index,
                      quantity: double.tryParse(value) ?? 0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    "Unit Price",
                    initialValue: line.unitPrice.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateProductLine(
                      index,
                      unitPrice: double.tryParse(value) ?? 0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    "Tax Rate (%)",
                    initialValue: line.taxRate.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _updateProductLine(
                      index,
                      taxRate: double.tryParse(value) ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? initialValue,
    TextInputType? keyboardType,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  void _addProductLine() {
    setState(() {
      _lines.add(QuotationLine(
        productName: '',
        description: '',
        quantity: 1,
        unitPrice: 0,
        taxRate: 5,
      ));
    });
  }

  void _removeProductLine(int index) {
    setState(() {
      _lines.removeAt(index);
    });
  }

  void _updateProductLine(
    int index, {
    String? productName,
    String? description,
    double? quantity,
    double? unitPrice,
    double? taxRate,
  }) {
    setState(() {
      final line = _lines[index];
      _lines[index] = QuotationLine(
        productName: productName ?? line.productName,
        description: description ?? line.description,
        quantity: quantity ?? line.quantity,
        unitPrice: unitPrice ?? line.unitPrice,
        taxRate: taxRate ?? line.taxRate,
      );
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _lines.isNotEmpty) {
      final newQuotation = Quotation(
        id: widget.quotation?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        number: widget.quotation?.number ?? 'QT${(_opportunities.length + 1).toString().padLeft(3, '0')}',
        lead: _selectedLead,
        opportunity: _selectedOpportunity,
        date: DateTime.now(),
        validUntil: _validUntil,
        status: widget.quotation?.status ?? 'Draft',
        lines: _lines,
        notes: _notes,
        termsAndConditions: _termsAndConditions,
      );
      if (widget.quotation != null) {
        context.read<QuotationProvider>().updateQuotation(newQuotation);
      } else {
        context.read<QuotationProvider>().createQuotation(
              lead: _selectedLead,
              opportunity: _selectedOpportunity,
              validUntil: _validUntil,
              lines: _lines,
              notes: _notes,
              termsAndConditions: _termsAndConditions,
            );
      }
      Navigator.pop(context, newQuotation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please fill in all required fields and add at least one product line'),
        ),
      );
    }
  }
}
