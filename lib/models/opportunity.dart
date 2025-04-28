// 1. First, create Opportunity Model
class Opportunity {
  final String name;
  final String company;
  final String date;
  final String stage;
  final double expectedRevenue;

  Opportunity({
    required this.name,
    required this.company,
    required this.date,
    required this.stage,
    required this.expectedRevenue,
  });
}
