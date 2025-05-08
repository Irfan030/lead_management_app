import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceRecord {
  final String type;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String? officeLocation;
  final int? lateness;
  final int? earliness;
  final Duration? breakDuration;
  final double? workingHours;

  AttendanceRecord({
    required this.type,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.officeLocation,
    this.lateness,
    this.earliness,
    this.breakDuration,
    this.workingHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'officeLocation': officeLocation,
      'lateness': lateness,
      'earliness': earliness,
      'breakDuration': breakDuration?.inMinutes,
      'workingHours': workingHours,
    };
  }
}

class AttendanceStats {
  final int totalDays;
  final int lateDays;
  final double averageWorkingHours;

  AttendanceStats({
    required this.totalDays,
    required this.lateDays,
    required this.averageWorkingHours,
  });
}

class AttendanceProvider with ChangeNotifier {
  bool _isCheckedIn = false;
  bool _isLoading = false;
  bool _isLocationLoading = false;
  Position? _currentPosition;
  String _statusMessage = 'Not checked in';
  final List<AttendanceRecord> _attendanceHistory = [];
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Today', 'This Week', 'This Month'];

  // Constructor
  AttendanceProvider() {
    addDummyData(); // Initialize with dummy data
  }

  // Getters
  bool get isCheckedIn => _isCheckedIn;
  bool get isLoading => _isLoading;
  bool get isLocationLoading => _isLocationLoading;
  Position? get currentPosition => _currentPosition;
  String get statusMessage => _statusMessage;
  List<AttendanceRecord> get attendanceHistory => _attendanceHistory;
  String get selectedFilter => _selectedFilter;
  List<String> get filters => _filters;
  List<AttendanceRecord> get filteredHistory => getFilteredRecords();
  AttendanceStats get stats => _calculateStats();

  // Office locations for geofencing
  final List<Map<String, dynamic>> _officeLocations = [
    {
      'name': 'Main Office',
      'latitude': 37.7749,
      'longitude': -122.4194,
      'radius': 100.0, // meters
    },
    {
      'name': 'Branch Office',
      'latitude': 37.7833,
      'longitude': -122.4167,
      'radius': 100.0,
    },
  ];

  // Working hours configuration
  final TimeOfDay _workStartTime = const TimeOfDay(hour: 9, minute: 0);
  final TimeOfDay _workEndTime = const TimeOfDay(hour: 17, minute: 0);

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<AttendanceRecord> getFilteredRecords() {
    final now = DateTime.now();
    return _attendanceHistory.where((record) {
      switch (_selectedFilter) {
        case 'Today':
          return record.timestamp.year == now.year &&
              record.timestamp.month == now.month &&
              record.timestamp.day == now.day;
        case 'This Week':
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 7));
          return record.timestamp.isAfter(startOfWeek) &&
              record.timestamp.isBefore(endOfWeek);
        case 'This Month':
          final startOfMonth = DateTime(now.year, now.month, 1);
          final endOfMonth = DateTime(now.year, now.month + 1, 0);
          return record.timestamp.isAfter(startOfMonth) &&
              record.timestamp.isBefore(endOfMonth);
        default:
          return true;
      }
    }).toList();
  }

  AttendanceStats _calculateStats() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    // Get all records for the current month
    final monthlyRecords = _attendanceHistory
        .where((record) =>
            record.timestamp.isAfter(startOfMonth) &&
            record.timestamp.isBefore(endOfMonth))
        .toList();

    // Sort records by timestamp
    monthlyRecords.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    int totalDays = 0;
    int lateDays = 0;
    double totalWorkingHours = 0;
    DateTime? lastCheckIn;

    for (var record in monthlyRecords) {
      if (record.type == 'Check In') {
        lastCheckIn = record.timestamp;
        if (record.lateness != null && record.lateness! > 0) {
          lateDays++;
        }
      } else if (record.type == 'Check Out' && lastCheckIn != null) {
        totalDays++;
        totalWorkingHours +=
            _calculateWorkingHours(lastCheckIn, record.timestamp);
        lastCheckIn = null;
      }
    }

    return AttendanceStats(
      totalDays: totalDays,
      lateDays: lateDays,
      averageWorkingHours: totalWorkingHours / (totalDays > 0 ? totalDays : 1),
    );
  }

  int? _calculateLateness(DateTime checkInTime) {
    final checkInTimeOfDay = TimeOfDay.fromDateTime(checkInTime);
    if (checkInTimeOfDay.hour > _workStartTime.hour ||
        (checkInTimeOfDay.hour == _workStartTime.hour &&
            checkInTimeOfDay.minute > _workStartTime.minute)) {
      return (checkInTimeOfDay.hour - _workStartTime.hour) * 60 +
          (checkInTimeOfDay.minute - _workStartTime.minute);
    }
    return null;
  }

  int? _calculateEarliness(DateTime checkOutTime) {
    final checkOutTimeOfDay = TimeOfDay.fromDateTime(checkOutTime);
    if (checkOutTimeOfDay.hour < _workEndTime.hour ||
        (checkOutTimeOfDay.hour == _workEndTime.hour &&
            checkOutTimeOfDay.minute < _workEndTime.minute)) {
      return (_workEndTime.hour - checkOutTimeOfDay.hour) * 60 +
          (_workEndTime.minute - checkOutTimeOfDay.minute);
    }
    return null;
  }

  double _calculateWorkingHours(DateTime checkIn, DateTime checkOut) {
    final duration = checkOut.difference(checkIn);
    return duration.inMinutes / 60.0;
  }

  String? _getNearestOffice(double latitude, double longitude) {
    double minDistance = double.infinity;
    String? nearestOffice;

    for (var office in _officeLocations) {
      final distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        office['latitude'],
        office['longitude'],
      );

      if (distance < minDistance && distance <= office['radius']) {
        minDistance = distance;
        nearestOffice = office['name'];
      }
    }

    return nearestOffice;
  }

  Future<void> checkLocationPermission() async {
    try {
      _isLocationLoading = true;
      notifyListeners();

      bool serviceEnabled;
      LocationPermission permission;

      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (e) {
        print('Error checking location service: $e');
        _statusMessage = 'Location services are disabled.';
        _isLocationLoading = false;
        notifyListeners();
        return;
      }

      if (!serviceEnabled) {
        _statusMessage = 'Location services are disabled.';
        _isLocationLoading = false;
        notifyListeners();
        return;
      }

      try {
        permission = await Geolocator.checkPermission();
      } catch (e) {
        print('Error checking permission: $e');
        _statusMessage = 'Error checking location permission.';
        _isLocationLoading = false;
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.denied) {
        try {
          permission = await Geolocator.requestPermission();
        } catch (e) {
          print('Error requesting permission: $e');
          _statusMessage = 'Error requesting location permission.';
          _isLocationLoading = false;
          notifyListeners();
          return;
        }

        if (permission == LocationPermission.denied) {
          _statusMessage = 'Location permissions are denied.';
          _isLocationLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _statusMessage = 'Location permissions are permanently denied.';
        _isLocationLoading = false;
        notifyListeners();
        return;
      }

      await getCurrentLocation();
    } catch (e) {
      print('Error in checkLocationPermission: $e');
      _statusMessage = 'Error initializing location services.';
      _isLocationLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      _isLocationLoading = true;
      notifyListeners();

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Location request timed out');
        },
      );

      _currentPosition = position;
      _statusMessage = _isCheckedIn ? 'Checked In' : 'Checked Out';
    } catch (e) {
      print('Error getting location: $e');
      if (e is TimeoutException) {
        _statusMessage = 'Location request timed out. Please try again.';
      } else {
        _statusMessage = 'Error getting location. Please try again.';
      }
      _currentPosition = null;
    } finally {
      _isLocationLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleAttendance(BuildContext context) async {
    if (_currentPosition == null) {
      await getCurrentLocation();

      if (_currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location not available. Please check your location settings and try again.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
    }

    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final isLate = !_isCheckedIn && _calculateLateness(now) != null;
      final isEarly = _isCheckedIn && _calculateEarliness(now) != null;

      // Calculate working hours if checking out
      double? workingHours;
      if (_isCheckedIn && _attendanceHistory.isNotEmpty) {
        final lastCheckIn = _attendanceHistory.last;
        workingHours = _calculateWorkingHours(lastCheckIn.timestamp, now);
      }

      final record = AttendanceRecord(
        type: _isCheckedIn ? 'Check Out' : 'Check In',
        timestamp: now,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        officeLocation: _getNearestOffice(
            _currentPosition!.latitude, _currentPosition!.longitude),
        lateness: isLate ? _calculateLateness(now) : null,
        earliness: isEarly ? _calculateEarliness(now) : null,
        workingHours: workingHours,
      );

      // Dummy API call
      await _sendAttendanceToAPI(record);

      _isCheckedIn = !_isCheckedIn;
      _statusMessage = _isCheckedIn ? 'Checked In' : 'Checked Out';
      _attendanceHistory.add(record);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Successfully ${_isCheckedIn ? "checked in" : "checked out"}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error in handleAttendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _sendAttendanceToAPI(AttendanceRecord record) async {
    // Dummy API call - replace with actual API integration
    await Future.delayed(const Duration(seconds: 1));
    print('Sending to API: ${record.toJson()}');
  }

  // Add some dummy data for testing
  void addDummyData() {
    final now = DateTime.now();
    final random = Random();

    // Add records for the past 30 days
    for (var i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));

      // Skip weekends
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        continue;
      }

      // Check in time (between 8:30 AM and 9:30 AM)
      final checkInHour = 8 + (random.nextBool() ? 0 : 1);
      final checkInMinute = random.nextInt(60);
      final checkInTime = DateTime(
        date.year,
        date.month,
        date.day,
        checkInHour,
        checkInMinute,
      );

      // Check out time (between 5:00 PM and 6:00 PM)
      final checkOutHour = 17 + (random.nextBool() ? 0 : 1);
      final checkOutMinute = random.nextInt(60);
      final checkOutTime = DateTime(
        date.year,
        date.month,
        date.day,
        checkOutHour,
        checkOutMinute,
      );

      // Add check in record
      _attendanceHistory.add(AttendanceRecord(
        type: 'Check In',
        timestamp: checkInTime,
        latitude: 37.7749 + (random.nextDouble() * 0.01),
        longitude: -122.4194 + (random.nextDouble() * 0.01),
        officeLocation: 'Main Office',
        lateness: _calculateLateness(checkInTime),
        workingHours: null,
      ));

      // Add check out record
      _attendanceHistory.add(AttendanceRecord(
        type: 'Check Out',
        timestamp: checkOutTime,
        latitude: 37.7749 + (random.nextDouble() * 0.01),
        longitude: -122.4194 + (random.nextDouble() * 0.01),
        officeLocation: 'Main Office',
        earliness: _calculateEarliness(checkOutTime),
        workingHours: _calculateWorkingHours(checkInTime, checkOutTime),
      ));
    }

    // Sort records by timestamp
    _attendanceHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }
}
