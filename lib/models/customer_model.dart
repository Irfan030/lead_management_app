enum LeadStatus { newLead, contacted, converted }

enum LeadTag { hot, cold, interested, notInterested }

enum LeadSource { facebook, website, referral, other }

class Customer {
  final String name;
  final String address;
  final String phone;
  final String? companyName;
  final String? email;
  final String? imageUrl;
  final LeadStatus status;
  final LeadTag tag;
  final LeadSource source;
  final List<String> notes;
  final DateTime? followUpDate;
  final int leadScore;

  Customer({
    required this.name,
    required this.address,
    required this.phone,
    this.email,
    this.companyName,
    this.imageUrl,
    this.status = LeadStatus.newLead,
    this.tag = LeadTag.cold,
    this.source = LeadSource.other,
    this.notes = const [],
    this.followUpDate,
    this.leadScore = 0,
  });
}
