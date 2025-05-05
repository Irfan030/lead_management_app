import 'package:flutter/material.dart';

enum LeadStatus { newLead, contacted, converted }

enum LeadTag { hot, cold, interested, notInterested }

enum LeadSource { facebook, website, referral, other }

class Activity {
  final String type;
  final String desc;
  final String date;
  final IconData icon;
  final Color color;

  Activity({required this.type, required this.desc, required this.date, required this.icon, required this.color});
}

class Note {
  final String date;
  final String desc;

  Note({required this.date, required this.desc});
}

class CallLog {
  final String type;
  final String name;
  final String datetime;
  final String duration;
  final bool recording;

  CallLog({required this.type, required this.name, required this.datetime, required this.duration, required this.recording});
}

class Lead {
  final String id;
  final String name;
  final String? address;
  final String phone;
  final String? companyName;
  final String? email;
  final String? imageUrl;
  final String? stage;
  final DateTime? date;
  final LeadStatus? status;
  final LeadTag? tag;
  final LeadSource? source;
  final List<String> notes;
  final DateTime? followUpDate;
  final int leadScore;
  final List<Activity> activities;
  final List<Note> notesList;
  final List<CallLog> callLogs;

  Lead({
    required this.id,
    required this.name,
    this.address,
    required this.phone,
    this.email,
    this.companyName,
    this.imageUrl,
    this.stage,
    this.date,
    this.status = LeadStatus.newLead,
    this.tag = LeadTag.cold,
    this.source = LeadSource.other,
    this.notes = const [],
    this.followUpDate,
    this.leadScore = 0,
    this.activities = const [],
    this.notesList = const [],
    this.callLogs = const [],
  });
}
