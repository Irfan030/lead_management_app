import 'package:leads_management_app/models/lead_model.dart';

// 1. First, create Opportunity Model
class Opportunity {
  final String name;
  final Lead? lead;
  final String date;
  final String stage;
  final double expectedRevenue;

  Opportunity({
    required this.name,
    this.lead,
    required this.date,
    required this.stage,
    required this.expectedRevenue,
  });
}
