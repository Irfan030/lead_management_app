import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamMember {
  final String id;
  final String name;
  final String? imageUrl;
  final LatLng location;
  final DateTime lastUpdated;

  TeamMember({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.location,
    required this.lastUpdated,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  static const LatLng _center = LatLng(-26.2041, 28.0473); // Johannesburg
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Circle> _geofences = {};
  List<Lead> _leads = [];
  List<TeamMember> _teamMembers = [];
  bool _showLeads = true;
  bool _showTeam = true;
  bool _showRoutes = false;
  Timer? _locationUpdateTimer;
  List<LatLng> _waypoints = [];
  bool _isCalculatingRoute = false;
  Position? _currentPosition;
  bool _isLoading = true;
  bool _isNavigating = false;
  String _selectedLeadStage = 'All';
  final List<String> _leadStages = [
    'All',
    'New',
    'Contacted',
    'Qualified',
    'Proposal',
    'Negotiation',
    'Closed'
  ];
  bool _showOnlyNearbyLeads = false;
  double _nearbyRadius = 5.0; // in kilometers

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDummyLeads();
    _loadTeamMembers();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground
      setState(() {
        _isNavigating = false;
      });
      _getCurrentLocation(); // Refresh location when app resumes
    } else if (state == AppLifecycleState.paused) {
      // App went to background
      setState(() {
        _isNavigating = true;
      });
    }
  }

  Future<void> _loadTeamMembers() async {
    // TODO: Load team members from your data source
    setState(() {
      _teamMembers = [
        TeamMember(
          id: '1',
          name: 'John Doe',
          location: const LatLng(-26.2041, 28.0473),
          lastUpdated: DateTime.now(),
        ),
        // Add more team members
      ];
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();
      if (_showLeads) {
        _addLeadMarkers();
      }
      if (_showTeam) {
        _addTeamMarkers();
      }
      if (_currentPosition != null) {
        _addCurrentLocationMarker();
      }
    });
  }

  void _addLeadMarkers() {
    for (var lead in _leads) {
      if (_selectedLeadStage == 'All' || lead.stage == _selectedLeadStage) {
        if (!_showOnlyNearbyLeads || _isLeadNearby(lead)) {
          _markers.add(
            Marker(
              markerId: MarkerId('lead_${lead.id}'),
              position: LatLng(lead.latitude ?? 0, lead.longitude ?? 0),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                _getMarkerHueForStage(lead.stage ?? ''),
              ),
              onTap: () => _showLeadDetails(lead),
            ),
          );
        }
      }
    }
  }

  void _addTeamMarkers() {
    for (var member in _teamMembers) {
      _markers.add(
        Marker(
          markerId: MarkerId('team_${member.id}'),
          position: member.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: member.name,
            snippet: 'Last updated: ${_formatTime(member.lastUpdated)}',
          ),
        ),
      );
    }
  }

  void _addCurrentLocationMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );
  }

  bool _isLeadNearby(Lead lead) {
    if (_currentPosition == null) return false;
    final distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lead.latitude ?? 0,
      lead.longitude ?? 0,
    );
    return distance <= _nearbyRadius * 1000; // Convert km to meters
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  Future<void> _loadDummyLeads() async {
    // Dummy data for leads
    setState(() {
      _leads = [
        Lead(
          id: '1',
          name: 'ABC Corporation',
          companyName: 'ABC Corp',
          stage: 'New',
          phone: '+1234567890',
          latitude: -26.2041,
          longitude: 28.0473,
          date: DateTime.now().subtract(const Duration(days: 2)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '2',
          name: 'XYZ Industries',
          companyName: 'XYZ Ltd',
          stage: 'Qualified',
          phone: '+1234567891',
          latitude: -26.2141,
          longitude: 28.0573,
          date: DateTime.now().subtract(const Duration(days: 5)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '3',
          name: 'Tech Solutions',
          companyName: 'TechSol',
          stage: 'Proposal',
          phone: '+1234567892',
          latitude: -26.1941,
          longitude: 28.0373,
          date: DateTime.now().subtract(const Duration(days: 1)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '4',
          name: 'Global Enterprises',
          companyName: 'Global Inc',
          stage: 'Negotiation',
          phone: '+1234567893',
          latitude: -26.2241,
          longitude: 28.0673,
          date: DateTime.now().subtract(const Duration(days: 3)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '5',
          name: 'Digital Innovations',
          companyName: 'DigiTech',
          stage: 'Closed',
          phone: '+1234567894',
          latitude: -26.1841,
          longitude: 28.0273,
          date: DateTime.now().subtract(const Duration(days: 7)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '6',
          name: 'Future Systems',
          companyName: 'FutureSys',
          stage: 'New',
          phone: '+1234567895',
          latitude: -26.2341,
          longitude: 28.0773,
          date: DateTime.now().subtract(const Duration(days: 1)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '7',
          name: 'Smart Solutions',
          companyName: 'SmartSol',
          stage: 'Contacted',
          phone: '+1234567896',
          latitude: -26.1741,
          longitude: 28.0173,
          date: DateTime.now().subtract(const Duration(days: 4)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '8',
          name: 'Innovative Tech',
          companyName: 'InnoTech',
          stage: 'Qualified',
          phone: '+1234567897',
          latitude: -26.2441,
          longitude: 28.0873,
          date: DateTime.now().subtract(const Duration(days: 2)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '9',
          name: 'NextGen Systems',
          companyName: 'NextGen',
          stage: 'Proposal',
          phone: '+1234567898',
          latitude: -26.1641,
          longitude: 28.0073,
          date: DateTime.now().subtract(const Duration(days: 3)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
        Lead(
          id: '10',
          name: 'Elite Solutions',
          companyName: 'EliteSol',
          stage: 'Negotiation',
          phone: '+1234567899',
          latitude: -26.2541,
          longitude: 28.0973,
          date: DateTime.now().subtract(const Duration(days: 1)),
          activities: [],
          notesList: [],
          callLogs: [],
        ),
      ];
      _updateMarkers();
    });
  }

  Color _getMarkerColorForStage(String stage) {
    switch (stage.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'contacted':
        return Colors.orange;
      case 'qualified':
        return Colors.green;
      case 'proposal':
        return Colors.purple;
      case 'negotiation':
        return Colors.amber;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  double _getMarkerHueForStage(String stage) {
    switch (stage.toLowerCase()) {
      case 'new':
        return BitmapDescriptor.hueBlue;
      case 'contacted':
        return BitmapDescriptor.hueOrange;
      case 'qualified':
        return BitmapDescriptor.hueGreen;
      case 'proposal':
        return BitmapDescriptor.hueViolet;
      case 'negotiation':
        return BitmapDescriptor.hueYellow;
      case 'closed':
        return BitmapDescriptor.hueRose;
      default:
        return BitmapDescriptor.hueBlue;
    }
  }

  void _showLeadDetails(Lead lead) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              _getMarkerColorForStage(lead.stage ?? ''),
                          child: Text(
                            lead.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lead.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                lead.companyName ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Stage and Contact Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color:
                                    _getMarkerColorForStage(lead.stage ?? ''),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Stage: ${lead.stage ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                lead.phone,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          if (lead.email != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.email, color: Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  lead.email!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                          if (lead.date != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  'Last Contact: ${DateFormat('MMM d, y').format(lead.date!)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Implement call functionality
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('Call'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Implement email functionality
                            },
                            icon: const Icon(Icons.email),
                            label: const Text('Email'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _getDirections(lead, 'driving');
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text('Get Directions'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getDirections(Lead lead, String mode) async {
    if (_currentPosition == null) return;

    setState(() {
      _isNavigating = true;
    });

    try {
      final url = 'https://www.google.com/maps/dir/?api=1'
          '&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}'
          '&destination=${lead.latitude},${lead.longitude}'
          '&travelmode=$mode';

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch directions')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching directions: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
        _updateMarkers();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
    }
  }

  void _recenterMap() async {
    if (_currentPosition != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void _toggleLeads() {
    setState(() {
      _showLeads = !_showLeads;
      _updateMarkers();
    });
  }

  void _toggleTeam() {
    setState(() {
      _showTeam = !_showTeam;
      _updateMarkers();
    });
  }

  Future<void> _calculateRoute() async {
    if (_waypoints.length < 2) return;

    setState(() => _isCalculatingRoute = true);
    try {
      final origin = _waypoints.first;
      final destination = _waypoints.last;
      final waypoints = _waypoints.sublist(1, _waypoints.length - 1);

      final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}&'
        'waypoints=${waypoints.map((p) => 'via:${p.latitude},${p.longitude}').join('|')}&'
        'AIzaSyDEQuMizKGG3iBx96RZWckPjQso8lFQ6V4', // TODO: Add your API key
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final points =
              _decodePolyline(data['routes'][0]['overview_polyline']['points']);
          setState(() {
            _polylines.clear();
            _polylines.add(Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: AppColor.mainColor,
              width: 5,
            ));
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error calculating route: ${e.toString()}')),
      );
    } finally {
      setState(() => _isCalculatingRoute = false);
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _toggleRoutes() {
    setState(() {
      _showRoutes = !_showRoutes;
      if (!_showRoutes) {
        _polylines.clear();
        _waypoints.clear();
      } else {
        // TODO: Show route planning UI
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isNavigating) {
          setState(() {
            _isNavigating = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: const Text(
            'Lead Map',
            style: TextStyle(
              color: AppColor.cardBackground,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _showLeads ? Icons.people : Icons.people_outline,
                color: AppColor.cardBackground,
              ),
              onPressed: _toggleLeads,
              tooltip: 'Toggle Leads',
            ),
            IconButton(
              icon: Icon(
                _showTeam ? Icons.group : Icons.group_outlined,
                color: AppColor.cardBackground,
              ),
              onPressed: _toggleTeam,
              tooltip: 'Toggle Team',
            ),
            PopupMenuButton<String>(
              color: AppColor.cardBackground,
              icon: const Icon(
                Icons.filter_list,
                color: AppColor.cardBackground,
              ),
              onSelected: (String stage) {
                setState(() {
                  _selectedLeadStage = stage;
                  _updateMarkers();
                });
              },
              itemBuilder: (BuildContext context) => _leadStages.map((String stage) {
                return PopupMenuItem<String>(
                  value: stage,
                  child: Row(
                    children: [
                      if (stage != 'All')
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: _getMarkerColorForStage(stage),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                      Text(stage),
                    ],
                  ),
                );
              }).toList(),
            ),
            IconButton(
              icon: Icon(
                _showOnlyNearbyLeads ? Icons.location_on : Icons.location_off,
                color: AppColor.cardBackground,
              ),
              onPressed: () {
                setState(() {
                  _showOnlyNearbyLeads = !_showOnlyNearbyLeads;
                  _updateMarkers();
                });
              },
              tooltip: 'Toggle Nearby Leads',
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition != null
                    ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                    : _center,
                zoom: 12,
              ),
              markers: _markers,
              polylines: _polylines,
              circles: _geofences,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (_isNavigating)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Navigation in progress...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Return to this app when done',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_showOnlyNearbyLeads)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColor.mainColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nearby Leads',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.mainColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_nearbyRadius.round()} km',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_markers.where((m) => m.markerId.value.startsWith('lead_')).length} leads',
                                style: TextStyle(
                                  color: AppColor.mainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: AppColor.mainColor,
                            inactiveTrackColor: AppColor.mainColor.withOpacity(0.2),
                            thumbColor: AppColor.mainColor,
                            overlayColor: AppColor.mainColor.withOpacity(0.1),
                            valueIndicatorColor: AppColor.mainColor,
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          child: Slider(
                            value: _nearbyRadius,
                            min: 1,
                            max: 20,
                            divisions: 19,
                            label: '${_nearbyRadius.round()} km',
                            onChanged: (value) {
                              setState(() {
                                _nearbyRadius = value;
                                _updateMarkers();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
