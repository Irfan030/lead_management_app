import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leads_management_app/theme/colors.dart';

import 'create_opportunity.dart';
import 'opportunity_viewupdate.dart';

class OpportunityListScreen extends StatefulWidget {
  const OpportunityListScreen({super.key});

  @override
  State<OpportunityListScreen> createState() => _OpportunityListScreenState();
}

class _OpportunityListScreenState extends State<OpportunityListScreen> {
  List<Map<String, dynamic>> opportunities = [
    {
      'name': 'Interest in your products',
      'date': '2021-12-30',
      'revenue': 2000.00,
      'probability': '100.0%',
      'customer': 'Deco Addict',
      'stage': 'Won',
    },
    {
      'name': 'Modern Open Space',
      'date': '2021-12-29',
      'revenue': 4500.00,
      'probability': '60.0%',
      'customer': 'Unknown',
      'stage': 'Proposition',
    },
    {
      'name': 'Office Design and Architecture',
      'date': '2021-12-28',
      'revenue': 9000.00,
      'probability': '3.45%',
      'customer': 'Ready Mat',
      'stage': 'Proposition',
    },
    {
      'name': 'Info about services',
      'date': '2021-12-31',
      'revenue': 25000.00,
      'probability': '30.0%',
      'customer': 'Deco Addict',
      'stage': 'Qualified',
    },
  ];

  List<Map<String, dynamic>> filteredOpportunities = [];
  String searchQuery = '';
  String selectedStageFilter = 'All';
  bool sortAscending = true;
  String sortBy = 'Name'; // new: sort by Name, Revenue, or Date

  @override
  void initState() {
    super.initState();
    filteredOpportunities = List.from(opportunities);
  }

  void searchOpportunities(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void applyFilters() {
    List<Map<String, dynamic>> result = opportunities
        .where(
          (opp) =>
              opp['name'].toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    if (selectedStageFilter != 'All') {
      result = result
          .where((opp) => opp['stage'] == selectedStageFilter)
          .toList();
    }

    result.sort((a, b) {
      int comparison;
      switch (sortBy) {
        case 'Revenue':
          comparison = (a['revenue'] as double).compareTo(b['revenue']);
          break;
        case 'Date':
          comparison = DateTime.parse(
            a['date'],
          ).compareTo(DateTime.parse(b['date']));
          break;
        case 'Name':
        default:
          comparison = a['name'].compareTo(b['name']);
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

  void showOpportunityMenu(
    BuildContext context,
    Map<String, dynamic> opportunity,
  ) {
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
                final updatedOpp = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        OpportunityViewUpdateScreen(opportunity: opportunity),
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
                  opportunity['stage'] = 'Won';
                  applyFilters();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Mark as Lost'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  opportunity['stage'] = 'Lost';
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
      default:
        return Colors.grey;
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
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          onTap: () => showOpportunityMenu(context, opp),
                          title: Text(
                            opp['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(opp['customer']),
                              Text(opp['date']),
                              Text(
                                '${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(opp['revenue'])} (${opp['probability']})',
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: getStageColor(opp['stage']),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              opp['stage'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateOpportunityScreen(
                onOpportunityCreated: (newOpp) {
                  setState(() {
                    opportunities.add(newOpp);
                    applyFilters();
                  });
                },
              ),
            ),
          );
        },
        backgroundColor: AppColor.mainColor,
        foregroundColor: AppColor.borderColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
