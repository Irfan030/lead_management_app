import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/appbar.dart';
import 'package:location/location.dart';

class CreateLeadScreen extends StatefulWidget {
  final Lead? lead;
  const CreateLeadScreen({super.key, this.lead});

  @override
  State<CreateLeadScreen> createState() => _CreateLeadScreenState();
}

class _CreateLeadScreenState extends State<CreateLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final Location _location = Location();
  LatLng? _selectedLocation;
  String? _address;
  bool _isLoadingLocation = false;

  String? _stage;
  DateTime? _date;
  DateTime? _followUpDate;
  LeadStatus? _status;
  LeadTag? _tag;
  LeadSource? _source;
  int _leadScore = 0;
  List<Activity> _activities = [];
  List<Note> _notesList = [];
  List<CallLog> _callLogs = [];

  @override
  void initState() {
    super.initState();
    if (widget.lead != null) {
      final lead = widget.lead!;
      _nameController.text = lead.name;
      _phoneController.text = lead.phone;
      _emailController.text = lead.email ?? '';
      _companyNameController.text = lead.companyName ?? '';
      _addressController.text = lead.address ?? '';
      _stage = lead.stage;
      _date = lead.date;
      _followUpDate = lead.followUpDate;
      _status = lead.status;
      _tag = lead.tag;
      _source = lead.source;
      _leadScore = lead.leadScore;
      _notesController.text = lead.notes.isNotEmpty ? lead.notes.first : '';
      _activities = lead.activities;
      _notesList = lead.notesList;
      _callLogs = lead.callLogs;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final location = await _location.getLocation();
      final placemarks = await placemarkFromCoordinates(
        location.latitude!,
        location.longitude!,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _selectedLocation = LatLng(location.latitude!, location.longitude!);
          _address = '${place.street}, ${place.locality}, ${place.country}';
          _addressController.text = _address!;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _selectLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          initialLocation: _selectedLocation,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result['location'] as LatLng;
        _address = result['address'] as String;
        _addressController.text = _address!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.lead == null ? 'Create New Lead' : 'Edit Lead'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                isRequired: true,
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone',
                icon: Icons.phone,
                isRequired: true,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                isRequired: true,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _companyNameController,
                label: 'Company Name',
                icon: Icons.business,
              ),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Lead Details'),
              _buildDropdown(
                label: 'Stage',
                items: const [
                  'New',
                  'Contacted',
                  'Qualified',
                  'Proposal',
                  'Negotiation',
                  'Closed Won',
                  'Closed Lost'
                ],
                value: _stage,
                onChanged: (value) => setState(() => _stage = value),
              ),
              _buildDropdown(
                label: 'Status',
                items: LeadStatus.values
                    .map((e) => e.toString().split('.').last)
                    .toList(),
                value: _status?.toString().split('.').last,
                onChanged: (value) => setState(() {
                  _status = LeadStatus.values.firstWhere(
                    (e) => e.toString().split('.').last == value,
                  );
                }),
              ),
              _buildDropdown(
                label: 'Tag',
                items: LeadTag.values
                    .map((e) => e.toString().split('.').last)
                    .toList(),
                value: _tag?.toString().split('.').last,
                onChanged: (value) => setState(() {
                  _tag = LeadTag.values.firstWhere(
                    (e) => e.toString().split('.').last == value,
                  );
                }),
              ),
              _buildDropdown(
                label: 'Source',
                items: LeadSource.values
                    .map((e) => e.toString().split('.').last)
                    .toList(),
                value: _source?.toString().split('.').last,
                onChanged: (value) => setState(() {
                  _source = LeadSource.values.firstWhere(
                    (e) => e.toString().split('.').last == value,
                  );
                }),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Dates'),
              _buildDateField(
                label: 'Date',
                date: _date,
                onDateSelected: (date) => setState(() => _date = date),
              ),
              _buildDateField(
                label: 'Follow-up Date',
                date: _followUpDate,
                onDateSelected: (date) => setState(() => _followUpDate = date),
                isOptional: true,
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Location'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed:
                              _isLoadingLocation ? null : _getCurrentLocation,
                        ),
                      ),
                      readOnly: true,
                      onTap: _selectLocationOnMap,
                    ),
                  ),
                ],
              ),
              if (_isLoadingLocation)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              const SizedBox(height: 16),
              _buildSectionTitle('Additional Information'),
              _buildTextField(
                controller: _notesController,
                label: 'Notes',
                icon: Icons.note,
                maxLines: 3,
              ),
              _buildSlider(
                label: 'Lead Score',
                value: _leadScore,
                onChanged: (value) =>
                    setState(() => _leadScore = value.toInt()),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createLead,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Create Lead',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColor.secondaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColor.secondaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.secondaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return '$label is required';
          }
          if (label == 'Email' && value != null && value.trim().isNotEmpty) {
            final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'Enter a valid email address';
            }
          }
          if (label == 'Phone' && value != null && value.trim().isNotEmpty) {
            final phone = value.trim();
            if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
              return 'Phone must be 10 digits';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.secondaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: AppColor.secondaryColor),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required Function(DateTime) onDateSelected,
    bool isOptional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) onDateSelected(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.secondaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date != null ? _formatDate(date) : 'Select date',
                style: TextStyle(
                  color: date != null ? Colors.black : Colors.grey,
                ),
              ),
              const Icon(Icons.calendar_today, color: AppColor.secondaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required int value,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(color: AppColor.secondaryColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTapDown: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final double width = box.size.width;
                  final double dx = details.localPosition.dx;
                  final double newValue = (dx / width) * 100;
                  onChanged(newValue.clamp(0.0, 100.0));
                },
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width:
                            (value / 100) * MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Positioned(
                        left:
                            (value / 100) * MediaQuery.of(context).size.width -
                                8,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColor.secondaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _createLead() {
    if (_formKey.currentState!.validate()) {
      final newLead = Lead(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        companyName: _companyNameController.text.trim(),
        address: _addressController.text.trim(),
        stage: _stage,
        date: _date,
        status: _status,
        tag: _tag,
        source: _source,
        notes: _notesController.text.trim().isNotEmpty
            ? [_notesController.text.trim()]
            : [],
        followUpDate: _followUpDate,
        leadScore: _leadScore,
        activities: _activities,
        notesList: _notesList,
        callLogs: _callLogs,
        latitude: _selectedLocation?.latitude,
        longitude: _selectedLocation?.longitude,
      );
      Navigator.pop(context, newLead);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerScreen({Key? key, this.initialLocation})
      : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  String? _address;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  Future<void> _getAddressFromLocation(LatLng location) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address = '${place.street}, ${place.locality}, ${place.country}';
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _selectedLocation != null
                ? () => Navigator.pop(context, {
                      'location': _selectedLocation,
                      'address': _address,
                    })
                : null,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? const LatLng(-26.2041, 28.0473),
              zoom: 15,
            ),
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location;
              });
              _getAddressFromLocation(location);
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
          ),
          if (_address != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(_address!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
