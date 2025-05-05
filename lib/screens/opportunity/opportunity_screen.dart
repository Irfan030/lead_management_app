import 'package:flutter/material.dart';
import 'package:leads_management_app/models/dummy_leads.dart';
import 'package:leads_management_app/models/opportunity.dart';
import 'package:leads_management_app/theme/colors.dart';

import 'create_opportunity.dart';
import 'opportunity_viewupdate.dart';

class OpportunityScreen extends StatefulWidget {
  const OpportunityScreen({Key? key}) : super(key: key);

  @override
  State<OpportunityScreen> createState() => _OpportunityScreenState();
}

class _OpportunityScreenState extends State<OpportunityScreen> {
  final List<Opportunity> _opportunities = [
    Opportunity(
      id: '1',
      name: 'Enterprise Software Deal',
      lead: getDummyLeads()[0],
      date: '2023-01-01',
      stage: 'Proposal',
      expectedRevenue: 50000.00,
      probability: '70%',
    ),
    Opportunity(
      id: '2',
      name: 'Marketing Campaign',
      lead: getDummyLeads()[1],
      date: '2023-01-15',
      stage: 'Negotiation',
      expectedRevenue: 25000.00,
      probability: '50%',
    ),
    Opportunity(
      id: '3',
      name: 'Website Redesign',
      lead: getDummyLeads()[2],
      date: '2023-02-01',
      stage: 'Qualified',
      expectedRevenue: 15000.00,
      probability: '30%',
    ),
    Opportunity(
      id: '4',
      name: 'Mobile App Development',
      lead: getDummyLeads()[3],
      date: '2023-02-15',
      stage: 'New',
      expectedRevenue: 75000.00,
      probability: '20%',
    ),
    Opportunity(
      id: '5',
      name: 'Cloud Migration',
      lead: getDummyLeads()[4],
      date: '2023-03-01',
      stage: 'Closed Won',
      expectedRevenue: 100000.00,
      probability: '100%',
    ),
  ];
  String _searchQuery = '';

  List<Opportunity> get _filteredOpportunities {
    if (_searchQuery.isEmpty) return _opportunities;
    return _opportunities.where((opp) {
      final q = _searchQuery.toLowerCase();
      return opp.name.toLowerCase().contains(q) ||
          (opp.lead?.name.toLowerCase().contains(q) ?? false) ||
          (opp.stage?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, lead, or stage',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredOpportunities.length,
              itemBuilder: (context, index) {
                final opportunity = _filteredOpportunities[index];
                return Card(
                  color: AppColor.cardBackground,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OpportunityViewUpdateScreen(
                              opportunity: opportunity, leads: getDummyLeads()),
                        ),
                      );
                      if (result is Opportunity) {
                        setState(() {
                          final idx = _opportunities
                              .indexWhere((o) => o.id == result.id);
                          if (idx != -1) _opportunities[idx] = result;
                        });
                      } else if (result == 'delete') {
                        setState(() {
                          _opportunities
                              .removeWhere((o) => o.id == opportunity.id);
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  opportunity.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStageColor(
                                      opportunity.stage ?? 'New'),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  opportunity.stage ?? 'New',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.person,
                                  size: 18, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Text(
                                opportunity.lead?.name ?? 'N/A',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black87),
                              ),
                              const Spacer(),
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.blueGrey),
                              const SizedBox(width: 4),
                              Text(
                                opportunity.date ?? 'N/A',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.attach_money,
                                  size: 18, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                'R ${opportunity.expectedRevenue.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black87),
                              ),
                              const Spacer(),
                              const Icon(Icons.percent,
                                  size: 18, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                opportunity.probability ?? 'N/A',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.mainColor,
        onPressed: () async {
          final newOpportunity = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateOpportunityScreen(),
            ),
          );
          if (newOpportunity != null) {
            setState(() {
              _opportunities.add(newOpportunity as Opportunity);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'New':
        return Colors.blue;
      case 'Qualified':
        return Colors.orange;
      case 'Proposal':
      case 'Proposition':
        return Colors.teal;
      case 'Negotiation':
        return Colors.purple;
      case 'Closed Won':
      case 'Won':
        return Colors.green;
      case 'Closed Lost':
      case 'Lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
