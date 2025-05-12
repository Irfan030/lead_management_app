import 'package:flutter/material.dart';

class Activity {
  final String type;
  final String desc;
  final DateTime dateTime;
  final bool isCompleted;
  final IconData icon;
  final Color color;
  final String? assignedTo;

  Activity({
    required this.type,
    required this.desc,
    required this.dateTime,
    this.isCompleted = false,
    required this.icon,
    required this.color,
    this.assignedTo,
  });
} 