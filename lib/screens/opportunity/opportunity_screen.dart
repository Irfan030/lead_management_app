import 'package:flutter/material.dart';
import 'package:leads_management_app/screens/opportunity/create_activity.dart';
import 'package:leads_management_app/screens/opportunity/log_internal_notes.dart';

import 'opportunity_viewupdate.dart';

class OpportunityListScreen extends StatefulWidget {
  const OpportunityListScreen({super.key});

  @override
  State<OpportunityListScreen> createState() => _OpportunityListScreenState();
}

class _OpportunityListScreenState extends State<OpportunityListScreen> {
  List<Map<String, dynamic>> opportunities = [
    {
      'name': 'Opportunity A',
      'date': '2024-04-01',
      'revenue': '5000',
      'stage': 'Proposition',
    },
    {
      'name': 'Opportunity B',
      'date': '2024-04-10',
      'revenue': '12000',
      'stage': 'Qualified',
    },
    {
      'name': 'Opportunity C',
      'date': '2024-04-20',
      'revenue': '3000',
      'stage': 'Won',
    },
  ];

  List<Map<String, dynamic>> filteredOpportunities = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredOpportunities = List.from(opportunities);
  }

  void searchOpportunities(String query) {
    final results = opportunities
        .where((opp) => opp['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredOpportunities = results;
      searchQuery = query;
    });
  }

  void showOpportunityMenu(
    BuildContext context,
    Map<String, dynamic> opportunity,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('View/Update'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      OpportunityViewUpdateScreen(opportunity: opportunity),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_add),
            title: const Text('Log an Internal Note'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LogInternalNoteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Mark as Won'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Handle mark as won
            },
          ),
          ListTile(
            leading: const Icon(Icons.cancel_outlined),
            title: const Text('Mark as Lost'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Handle mark as lost
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_task),
            title: const Text('Create Activity'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateActivityScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Color getStageColor(String stage) {
    switch (stage) {
      case 'Won':
        return Colors.green;
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        filled:
                            true, // Important: make sure it's true to show fillColor
                        fillColor: Colors.white, // White background inside
                        hintText: 'Search opportunities...',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: searchOpportunities,
                    ),
                  ),
                ),

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    icon: const Icon(Icons.sort),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOpportunities.length,
              itemBuilder: (context, index) {
                final opportunity = filteredOpportunities[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () => showOpportunityMenu(context, opportunity),
                    title: Text(opportunity['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Created on: ${opportunity['date']}'),
                        Text('Expected Revenue: \$${opportunity['revenue']}'),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: getStageColor(opportunity['stage']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        opportunity['stage'],
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
        backgroundColor: Colors.blue[900],
        onPressed: () {
          // TODO: Navigate to create new opportunity
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
