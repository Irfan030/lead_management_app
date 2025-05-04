import 'package:flutter/material.dart';
import 'package:leads_management_app/models/dummy_leads.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/models/opportunity.dart';
import 'package:leads_management_app/theme/colors.dart';

import 'create_opportunity.dart';
import 'opportunity_viewupdate.dart';

class OpportunityListScreen extends StatefulWidget {
  const OpportunityListScreen({super.key});

  @override
  State<OpportunityListScreen> createState() => _OpportunityListScreenState();
}

class _OpportunityListScreenState extends State<OpportunityListScreen> {
  List<Lead> leads = [];
  List<Opportunity> opportunities = [];
  List<Opportunity> filteredOpportunities = [];
  String searchQuery = '';
  String selectedStageFilter = 'All';
  bool sortAscending = true;
  String sortBy = 'Name';

  @override
  void initState() {
    super.initState();
    leads = getDummyLeads();
    opportunities = [
      Opportunity(
        name: 'Interest in your products',
        lead: leads.isNotEmpty ? leads[0] : null,
        date: '2021-12-30',
        stage: 'Won',
        expectedRevenue: 2000.00,
      ),
      Opportunity(
        name: 'Modern Open Space',
        lead: leads.length > 1 ? leads[1] : null,
        date: '2021-12-29',
        stage: 'Proposition',
        expectedRevenue: 4500.00,
      ),
      Opportunity(
        name: 'Office Design and Architecture',
        lead: leads.length > 2 ? leads[2] : null,
        date: '2021-12-28',
        stage: 'Proposition',
        expectedRevenue: 9000.00,
      ),
      Opportunity(
        name: 'Info about services',
        lead: leads.length > 3 ? leads[3] : null,
        date: '2021-12-31',
        stage: 'Qualified',
        expectedRevenue: 25000.00,
      ),
    ];
    filteredOpportunities = List.from(opportunities);
  }

  void searchOpportunities(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void applyFilters() {
    List<Opportunity> result = opportunities
        .where(
          (opp) => opp.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    if (selectedStageFilter != 'All') {
      result = result.where((opp) => opp.stage == selectedStageFilter).toList();
    }

    result.sort((a, b) {
      int comparison;
      switch (sortBy) {
        case 'Revenue':
          comparison = a.expectedRevenue.compareTo(b.expectedRevenue);
          break;
        case 'Date':
          comparison = DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
          break;
        case 'Name':
        default:
          comparison = a.name.compareTo(b.name);
      }
      return sortAscending ? comparison : -comparison;
    });

    setState(() {
      filteredOpportunities = result;
    });
  }

  void showStageFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Stage'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children:
                [
                  'All',
                  'New',
                  'Qualified',
                  'Proposition',
                  'Won',
                  'Lost',
                  "Today's Expected Closing",
                  "Tomorrow's Expected Closing",
                ].map((stage) {
                  return RadioListTile(
                    title: Text(stage),
                    value: stage,
                    groupValue: selectedStageFilter,
                    onChanged: (value) {
                      Navigator.pop(context);
                      setState(() {
                        selectedStageFilter = value.toString();
                        applyFilters();
                      });
                    },
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  void showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: ['Name', 'Revenue', 'Date'].map((option) {
          return ListTile(
            title: Text('Sort by $option'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                sortBy = option;
                applyFilters();
              });
            },
          );
        }).toList(),
      ),
    );
  }

  void toggleSortOrder() {
    setState(() {
      sortAscending = !sortAscending;
      applyFilters();
    });
  }

  void showOpportunityMenu(BuildContext context, Opportunity opportunity) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min, // <-- important
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View/Update'),
              onTap: () async {
                final updatedOpp = await Navigator.push<Opportunity>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OpportunityViewUpdateScreen(
                      opportunity: opportunity,
                      leads: leads,
                    ),
                  ),
                );
                if (updatedOpp != null) {
                  Navigator.pop(context); // Close bottom sheet
                  setState(() {
                    final index = opportunities.indexOf(opportunity);
                    if (index != -1) {
                      opportunities[index] = updatedOpp;
                      applyFilters();
                    }
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Mark as Won'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  final index = opportunities.indexOf(opportunity);
                  if (index != -1) {
                    opportunities[index] = Opportunity(
                      name: opportunity.name,
                      lead: opportunity.lead,
                      date: opportunity.date,
                      stage: 'Won',
                      expectedRevenue: opportunity.expectedRevenue,
                    );
                    applyFilters();
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Mark as Lost'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  final index = opportunities.indexOf(opportunity);
                  if (index != -1) {
                    opportunities[index] = Opportunity(
                      name: opportunity.name,
                      lead: opportunity.lead,
                      date: opportunity.date,
                      stage: 'Lost',
                      expectedRevenue: opportunity.expectedRevenue,
                    );
                    applyFilters();
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  opportunities.remove(opportunity);
                  applyFilters();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Color getStageColor(String stage) {
    switch (stage) {
      case 'Won':
        return Colors.green;
      case 'Lost':
        return Colors.red;
      case 'Proposition':
        return Colors.orange;
      case 'Qualified':
        return Colors.blue;
      case 'New':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _addOpportunity() async {
    final newOpp = await Navigator.push<Opportunity>(
      context,
      MaterialPageRoute(builder: (_) => CreateOpportunityScreen(leads: leads)),
    );
    if (newOpp != null) {
      setState(() {
        opportunities.add(newOpp);
        applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: searchOpportunities,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list_alt),
                  onPressed: showStageFilterDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: showSortOptions,
                ),
                IconButton(
                  icon: Icon(
                    sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  onPressed: toggleSortOrder,
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredOpportunities.isEmpty
                ? const Center(
                    child: Text(
                      'No opportunities found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOpportunities.length,
                    itemBuilder: (context, index) {
                      final opp = filteredOpportunities[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: getStageColor(opp.stage),
                                width: 6,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: getStageColor(opp.stage),
                              child: Icon(Icons.work, color: Colors.white),
                            ),
                            title: Text(
                              opp.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lead: ${opp.lead?.name ?? '-'}'),
                                Text(
                                  'Revenue: \$${opp.expectedRevenue.toStringAsFixed(2)}',
                                ),
                                Text('Date: ${opp.date}'),
                              ],
                            ),
                            trailing: Chip(
                              label: Text(opp.stage),
                              backgroundColor: getStageColor(
                                opp.stage,
                              ).withOpacity(0.15),
                              labelStyle: TextStyle(
                                color: getStageColor(opp.stage),
                              ),
                            ),
                            onTap: () => showOpportunityMenu(context, opp),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOpportunity,
        backgroundColor: AppColor.mainColor,
        foregroundColor: AppColor.borderColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
