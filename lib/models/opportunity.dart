import 'package:leads_management_app/models/lead_model.dart';

// 1. First, create Opportunity Model
class Opportunity {
  final String id;
  final String name;
  final Lead? lead;
  final String? date;
  final String? stage;
  final double expectedRevenue;
  final String? probability;
  final String? description;
  final String? notes;

  Opportunity({
    required this.id,
    required this.name,
    this.lead,
    this.date,
    this.stage,
    required this.expectedRevenue,
    this.probability,
    this.description,
    this.notes,
  });
}
