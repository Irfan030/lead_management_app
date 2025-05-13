import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/appbar.dart';
import 'package:leads_management_app/widgets/default_drop_down.dart';
import 'package:leads_management_app/widgets/default_text_input.dart';
import 'package:leads_management_app/widgets/date_time_picker_field.dart';
import 'package:leads_management_app/widgets/text_button.dart';
import 'package:leads_management_app/widgets/title_widget.dart';
import 'package:leads_management_app/widgets/loader.dart';
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
  bool _isLoading = false;
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
        title: widget.lead == null ? 'Create New Lead' : 'Edit Lead',
      ),
      body: _isLoading
          ? const Loader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Basic Information'),
                    DefaultTextInput(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Enter name',
                      prefixIcon: const Icon(Icons.person, color: AppColor.secondaryColor),
                      onChange: (value) {},
                      validator: true,
                      errorMsg: 'Name is required',
                    ),
                    const SizedBox(height: 12),
                    DefaultTextInput(
                      controller: _phoneController,
                      label: 'Phone',
                      hint: 'Enter phone number',
                      prefixIcon: const Icon(Icons.phone, color: AppColor.secondaryColor),
                      onChange: (value) {},
                      validator: true,
                      errorMsg: 'Phone is required',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    DefaultTextInput(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter email',
                      prefixIcon: const Icon(Icons.email, color: AppColor.secondaryColor),
                      onChange: (value) {},
                      validator: true,
                      errorMsg: 'Email is required',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    DefaultTextInput(
                      controller: _companyNameController,
                      label: 'Company Name',
                      hint: 'Enter company name',
                      prefixIcon: const Icon(Icons.business, color: AppColor.secondaryColor),
                      onChange: (value) {},
                    ),
                    const SizedBox(height: 12),
                    DefaultTextInput(
                      controller: _addressController,
                      label: 'Address',
                      hint: 'Enter address',
                      prefixIcon: const Icon(Icons.location_on, color: AppColor.secondaryColor),
                      onChange: (value) {},
                      readOnly: true,
                      onSubmitted: (_) => _selectLocationOnMap(),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Lead Details'),
                    DefaultDropDown<String>(
                      label: 'Stage',
                      hint: 'Select stage',
                      value: _stage ?? '',
                      listValues: const [
                        'New',
                        'Contacted',
                        'Qualified',
                        'Proposal',
                        'Negotiation',
                        'Won',
                        'Lost'
                      ],
                      onChange: (value) => setState(() => _stage = value),
                      getDisplayText: (value) => value,
                      getValue: (value) => value,
                    ),
                    const SizedBox(height: 12),
                    DefaultDropDown<String>(
                      label: 'Status',
                      hint: 'Select status',
                      value: _status?.toString().split('.').last ?? '',
                      listValues: LeadStatus.values
                          .map((e) => e.toString().split('.').last)
                          .toSet()
                          .toList(),
                      onChange: (value) {
                        if (value != null && value.isNotEmpty) {
                          setState(() {
                            _status = LeadStatus.values.firstWhere(
                              (e) => e.toString().split('.').last == value,
                              orElse: () => LeadStatus.values.first,
                            );
                          });
                        }
                      },
                      getDisplayText: (value) => value,
                      getValue: (value) => value,
                    ),
                    const SizedBox(height: 12),
                    DefaultDropDown<String>(
                      label: 'Tag',
                      hint: 'Select tag',
                      value: _tag?.toString().split('.').last ?? '',
                      listValues: LeadTag.values
                          .map((e) => e.toString().split('.').last)
                          .toSet()
                          .toList(),
                      onChange: (value) {
                        if (value != null && value.isNotEmpty) {
                          setState(() {
                            _tag = LeadTag.values.firstWhere(
                              (e) => e.toString().split('.').last == value,
                              orElse: () => LeadTag.values.first,
                            );
                          });
                        }
                      },
                      getDisplayText: (value) => value,
                      getValue: (value) => value,
                    ),
                    const SizedBox(height: 12),
                    DefaultDropDown<String>(
                      label: 'Source',
                      hint: 'Select source',
                      value: _source?.toString().split('.').last ?? '',
                      listValues: LeadSource.values
                          .map((e) => e.toString().split('.').last)
                          .toSet()
                          .toList(),
                      onChange: (value) {
                        if (value != null && value.isNotEmpty) {
                          setState(() {
                            _source = LeadSource.values.firstWhere(
                              (e) => e.toString().split('.').last == value,
                              orElse: () => LeadSource.values.first,
                            );
                          });
                        }
                      },
                      getDisplayText: (value) => value,
                      getValue: (value) => value,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Dates'),
                    if (_date != null)
                      DateTimePickerField(
                        date: _date!,
                        time: TimeOfDay.now(),
                        label: 'Date',
                        isDate: true,
                        onDateChanged: (date) => setState(() => _date = date),
                        onTimeChanged: (_) {},
                      ),
                    const SizedBox(height: 12),
                    if (_followUpDate != null)
                      DateTimePickerField(
                        date: _followUpDate!,
                        time: TimeOfDay.now(),
                        label: 'Follow-up Date',
                        isDate: true,
                        onDateChanged: (date) => setState(() => _followUpDate = date),
                        onTimeChanged: (_) {},
                      ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Additional Information'),
                    DefaultTextInput(
                      controller: _notesController,
                      label: 'Notes',
                      hint: 'Enter notes',
                      prefixIcon: const Icon(Icons.note, color: AppColor.secondaryColor),
                      onChange: (value) {},
                      maxlineHeight: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildLeadScoreSlider(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: TextButtonWidget(
                        text: widget.lead == null ? 'Create Lead' : 'Update Lead',
                        textColor: Colors.white,
                        backgroundColor: AppColor.mainColor,
                        fontSize: 16,
                        height: 50,
                        borderRadius: 10,
                        onPressed: _createLead,
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
      child: TitleWidget(
        val: title,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColor.secondaryColor,
      ),
    );
  }

  Widget _buildLeadScoreSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          val: 'Lead Score: $_leadScore',
          fontSize: 14,
          color: AppColor.secondaryColor,
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
                  setState(() => _leadScore = newValue.clamp(0.0, 100.0).toInt());
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
                        width: (_leadScore / 100) * MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Positioned(
                        left: (_leadScore / 100) * MediaQuery.of(context).size.width - 8,
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
      // Validate required fields
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Name is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (_phoneController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (_emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (_stage == null || _stage!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stage is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final newLead = Lead(
          id: widget.lead?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          companyName: _companyNameController.text.trim(),
          address: _addressController.text.trim(),
          stage: _stage,
          date: _date ?? DateTime.now(),
          status: _status ?? LeadStatus.newLead,
          tag: _tag ?? LeadTag.cold,
          source: _source ?? LeadSource.other,
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

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.lead == null ? 'Lead created successfully' : 'Lead updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Return the new/updated lead
        Navigator.pop(context, newLead);
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      // Show validation error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
