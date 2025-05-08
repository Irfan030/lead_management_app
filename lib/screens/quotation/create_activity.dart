import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/widgets/appbar.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({Key? key}) : super(key: key);

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String _activityType = 'Call';
  DateTime _dueDate = DateTime.now();
  String _summary = '';
  String _assignedTo = 'Demo User';
  String _note = '';

  final List<String> activityTypes = ['Call', 'Email', 'Meeting'];
  final List<String> assignees = ['Demo User', 'User A', 'User B'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Activity'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.edit),
                      label: const Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _markAsDone,
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Mark As Done"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Activity Type Dropdown
              _buildDropdown("Activity", activityTypes, _activityType, (val) {
                setState(() => _activityType = val ?? activityTypes.first);
              }),

              const SizedBox(height: 16),

              // Due Date Picker
              _buildDatePicker("Due Date", _dueDate, (pickedDate) {
                if (pickedDate != null) {
                  setState(() => _dueDate = pickedDate);
                }
              }),

              const SizedBox(height: 16),

              // Summary Field
              _buildTextField("Summary", onChanged: (val) => _summary = val),

              const SizedBox(height: 16),

              // Assigned To Dropdown
              _buildDropdown("Assigned To", assignees, _assignedTo, (val) {
                setState(() => _assignedTo = val ?? assignees.first);
              }),

              const SizedBox(height: 16),

              // Note Field
              const Text("Note", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Type here..",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (val) => _note = val,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String selected,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selected,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime selectedDate,
    Function(DateTime?) onPicked,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            onPicked(picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, {required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Add your backend call or logic here
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Activity Submitted')));
    }
  }

  void _markAsDone() {
    // Logic for marking activity done
    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Marked as Done')));
  }
}
