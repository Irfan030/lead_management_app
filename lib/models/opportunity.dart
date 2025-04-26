class Opportunity {
  final String id;
  final String name;
  final String customer;
  final double amount;
  final String stage;
  final DateTime expectedClose;

  Opportunity({
    required this.id,
    required this.name,
    required this.customer,
    required this.amount,
    required this.stage,
    required this.expectedClose,
  });
}
