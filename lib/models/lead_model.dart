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

  Activity(
      {required this.type,
      required this.desc,
      required this.date,
      required this.icon,
      required this.color});
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

  CallLog(
      {required this.type,
      required this.name,
      required this.datetime,
      required this.duration,
      required this.recording});
}

class Lead {
  final int? id;
  final String name;
  final String? address;
  final String? phone;
  final String? companyName;
  final String? email_from;
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
  final double? latitude;
  final double? longitude;

  Lead({
    this.id,
    required this.name,
    this.address,
    required this.phone,
    this.email_from,
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
    this.latitude,
    this.longitude,
  });
  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email_from: json['email_from'] is String ? json['email_from'] : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'phone': phone,
      'email_from': email_from,
    };
  }

  // @override
  // String toString() {
  //   return 'Lead(id: $id, name: $name, phone: $phone, email: $email)';
  // }
}
