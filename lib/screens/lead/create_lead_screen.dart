import 'package:flutter/material.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/appbar.dart';

import '../../Repository/Repository.dart';

class CreateLeadScreen extends StatefulWidget {
  final Lead? lead;
  const CreateLeadScreen({super.key, this.lead});

  @override
  State<CreateLeadScreen> createState() => _CreateLeadScreenState();
}

class _CreateLeadScreenState extends State<CreateLeadScreen> {
  Repository repository = Repository();
  final _formKey = GlobalKey<FormState>();

  // Contact Information Controllers
  final TextEditingController _leadNameController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _functionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Company Information Controllers
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  int _priority = 0;

  // Address Information Controllers
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  // Additional Information Controllers
  final TextEditingController _descriptionController = TextEditingController();

  String? _stage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.lead != null) {
      final lead = widget.lead!;
      _leadNameController.text = lead.name;
      _contactNameController.text = lead.contact_name ?? '';
      _functionController.text = lead.function ?? '';
      _phoneController.text = lead.phone ?? '';
      _emailController.text = lead.email_from ?? '';
      _companyNameController.text = lead.partner_name ?? '';
      _websiteController.text = lead.website ?? '';
      _typeController.text = lead.type ?? '';
      _priority = int.tryParse(lead.priority ?? '0') ?? 0;
      _streetController.text = lead.street ?? '';
      _cityController.text = lead.city ?? '';
      _zipController.text = lead.zip ?? '';
      _descriptionController.text = lead.description ?? '';
      _stage = lead.stage;
    }
  }

  @override
  void dispose() {
    _leadNameController.dispose();
    _contactNameController.dispose();
    _functionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _websiteController.dispose();
    _typeController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        // Build the values map with only allowed fields and only if filled
        final Map<String, dynamic> values = {};
        if (_leadNameController.text.trim().isNotEmpty) {
          values['name'] = _leadNameController.text.trim();
        }
        if (_phoneController.text.trim().isNotEmpty) {
          values['phone'] = _phoneController.text.trim();
        }
        if (_emailController.text.trim().isNotEmpty) {
          values['email_from'] = _emailController.text.trim();
        }
        if (_contactNameController.text.trim().isNotEmpty) {
          values['contact_name'] = _contactNameController.text.trim();
        }
        if (_companyNameController.text.trim().isNotEmpty) {
          values['partner_name'] = _companyNameController.text.trim();
        }
        if (_descriptionController.text.trim().isNotEmpty) {
          values['description'] = _descriptionController.text.trim();
        }
        if (_streetController.text.trim().isNotEmpty) {
          values['street'] = _streetController.text.trim();
        }
        if (_cityController.text.trim().isNotEmpty) {
          values['city'] = _cityController.text.trim();
        }
        if (_zipController.text.trim().isNotEmpty) {
          values['zip'] = _zipController.text.trim();
        }
        if (_functionController.text.trim().isNotEmpty) {
          values['function'] = _functionController.text.trim();
        }
        if (_websiteController.text.trim().isNotEmpty) {
          values['website'] = _websiteController.text.trim();
        }
        if (_priority > 0) values['priority'] = _priority.toString();
        if (_typeController.text.trim().isNotEmpty) {
          values['type'] = _typeController.text.trim();
        }

        // The fields list must match the allowed fields for the API
        final List<String> fields = [
          'name',
          'phone',
          'email_from',
          'contact_name',
          'partner_name',
          'description',
          'street',
          'city',
          'zip',
          'function',
          'website',
          'priority',
          'type',
        ];

        final body = {
          'fields': fields,
          'values': values,
        };

        final param = {
          'model': 'crm.lead',
          if (widget.lead?.id != null) 'id': widget.lead!.id,
          'body': body,
        };

        dynamic response;
        if (widget.lead != null) {
          response = await repository.updateLead(param);
        } else {
          response = await repository.createLead(param);
        }

        if (response != null &&
            response['statusCode'] == 200 &&
            response['body'] != null &&
            ((widget.lead == null &&
                    response['body']['New resource'] is List &&
                    response['body']['New resource'].isNotEmpty) ||
                (widget.lead != null &&
                    response['body']['Updated resource'] is List &&
                    response['body']['Updated resource'].isNotEmpty))) {
          if (mounted) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(widget.lead == null
                      ? 'Lead added successfully!'
                      : 'Lead updated successfully!')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Failed to ${widget.lead == null ? 'add' : 'update'} Lead.')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.lead == null ? 'Create New Lead' : 'Edit Lead',
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Lead Information'),
                  _buildTextField(
                    controller: _leadNameController,
                    label: 'Lead Name',
                    icon: Icons.label_important_outline_rounded,
                    isRequired: true,
                  ),
                  _buildStarRating(),
                  _buildSectionTitle('Company Information'),
                  _buildTextField(
                    controller: _companyNameController,
                    label: 'Company Name',
                    icon: Icons.business,
                  ),
                  _buildTextField(
                    controller: _websiteController,
                    label: 'Website',
                    icon: Icons.language,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Address Information'),
                  _buildTextField(
                    controller: _streetController,
                    label: 'Street',
                    icon: Icons.location_on,
                  ),
                  _buildTextField(
                    controller: _cityController,
                    label: 'City',
                    icon: Icons.location_city,
                  ),
                  _buildTextField(
                    controller: _zipController,
                    label: 'ZIP Code',
                    icon: Icons.local_post_office,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Contact Information'),
                  _buildTextField(
                    controller: _contactNameController,
                    label: 'Contact Name',
                    icon: Icons.person_outline,
                  ),
                  _buildTextField(
                    controller: _functionController,
                    label: 'Function',
                    icon: Icons.badge,
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone',
                    icon: Icons.phone,
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Additional Information'),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColor.mainColor,
                      ),
                      child: Text(
                        widget.lead == null ? 'Create Lead' : 'Update Lead',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label + (isRequired ? ' *' : ''),
          prefixIcon: Icon(
            icon,
            color: AppColor.mainColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          if (keyboardType == TextInputType.emailAddress &&
              value != null &&
              value.isNotEmpty) {
            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
          }
          if (keyboardType == TextInputType.phone &&
              value != null &&
              value.isNotEmpty) {
            if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) {
              return 'Please enter a valid phone number';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildStarRating() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Text('Priority:  '),
          ...List.generate(3, (index) {
            return IconButton(
              icon: Icon(
                index < _priority ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () => setState(() => _priority = index + 1),
            );
          }),
        ],
      ),
    );
  }
}
