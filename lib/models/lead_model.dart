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
  final String? phone;
  final String? email_from;
  final String? contact_name;
  final String? partner_name;
  final String? description;
  final String? street;
  final String? city;
  final String? zip;
  final String? function;
  final String? website;
  final String? priority;
  final String? type;
  final String? stage;
  final String? address;
  final String? companyName;
  final String? imageUrl;
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
    this.phone,
    this.email_from,
    this.contact_name,
    this.partner_name,
    this.description,
    this.street,
    this.city,
    this.zip,
    this.function,
    this.website,
    this.priority,
    this.type,
    this.stage,
    this.address,
    this.companyName,
    this.imageUrl,
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
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email_from: json['email_from']?.toString(),
      contact_name: json['contact_name']?.toString(),
      partner_name: json['partner_name']?.toString(),
      description: json['description']?.toString(),
      street: json['street']?.toString(),
      city: json['city']?.toString(),
      zip: json['zip']?.toString(),
      function: json['function']?.toString(),
      website: json['website']?.toString(),
      priority: json['priority']?.toString(),
      type: json['type']?.toString(),
      stage: json['stage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email_from': email_from,
      'contact_name': contact_name,
      'partner_name': partner_name,
      'description': description,
      'street': street,
      'city': city,
      'zip': zip,
      'function': function,
      'website': website,
      'priority': priority,
      'type': type,
      'stage': stage,
    };
  }

  // @override
  // String toString() {
  //   return 'Lead(id: $id, name: $name, phone: $phone, email: $email)';
  // }
}
