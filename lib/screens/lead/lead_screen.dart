import 'package:flutter/material.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';

import 'create_lead_screen.dart';
import 'lead_detail.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  List<Lead> leads = [];
  List<Lead> filteredLeads = [];
  String selectedStageFilter = 'All';
  String sortBy = 'Name';
  bool sortAscending = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    leads = getDummyLeads();
    filteredLeads = List.from(leads);
  }

  List<Lead> getDummyLeads() {
    return [
      Lead(
        name: 'Jons Miley',
        phone: '8563412547',
        stage: 'New',
        date: DateTime(2025, 2, 27),
        activities: [
          Activity(type: 'Call', desc: 'call meeting', date: '21-02-2025', icon: Icons.phone, color: Colors.red),
          Activity(type: 'Meeting', desc: 'Meeting with HR', date: '24-02-2025', icon: Icons.groups, color: Colors.blue),
        ],
        notesList: [
          Note(date: '24-02-2025', desc: 'Lead/Opportunity created'),
          Note(date: '21-02-2025', desc: 'Lead Enrichment (based on email address)\nNo company data found based on the email address or email address is one of an email provider. No credit was consumed.'),
        ],
        callLogs: [
          CallLog(type: 'Outgoing', name: 'Jons Miley', datetime: '27-02-2025 17:21:25', duration: '0m 5s', recording: true),
        ],
      ),
      Lead(
        name: "Dixit's Opportunity",
        phone: '9845632175',
        stage: 'Qualified',
        date: DateTime(2025, 2, 27),
        activities: [
          Activity(type: 'Call', desc: 'Arrange Call For Meeting', date: '24-02-2025', icon: Icons.phone, color: Colors.red),
          Activity(type: 'Email', desc: 'Send Email to HR', date: '25-02-2025', icon: Icons.email, color: Colors.green),
        ],
        notesList: [
          Note(date: '24-02-2025', desc: 'Lead/Opportunity created'),
        ],
        callLogs: [
          CallLog(type: 'Outgoing', name: "Dixit's Opportunity", datetime: '27-02-2025 11:26:48', duration: '1', recording: false),
        ],
      ),
      Lead(
        name: 'Rahul',
        phone: '9915364789',
        stage: 'Proposition',
        date: DateTime(2025, 2, 27),
        activities: [],
        notesList: [],
        callLogs: [],
      ),
      Lead(
        name: 'Manish Roy',
        phone: '8634597216',
        stage: 'Won',
        date: DateTime(2025, 2, 27),
        activities: [],
        notesList: [],
        callLogs: [],
      ),
      Lead(
        name: 'Anjali Sharma',
        phone: '7854129630',
        stage: 'New',
        date: DateTime(2025, 2, 28),
        activities: [],
        notesList: [],
        callLogs: [],
      ),
      Lead(
        name: 'Vikas Patel',
        phone: '9021547836',
        stage: 'Qualified',
        date: DateTime(2025, 2, 28),
        activities: [],
        notesList: [],
        callLogs: [],
      ),
      Lead(
        name: 'Neha Gupta',
        phone: '9765432180',
        stage: 'Proposition',
        date: DateTime(2025, 3, 1),
        activities: [],
        notesList: [],
        callLogs: [],
      ),
      Lead(
        name: 'Ramesh Kumar',
        phone: '8897456123',
        stage: 'Negotiation',
        date: DateTime(2025, 3, 1),
        activities: [],
        notesList: [],
        callLogs: [],
      ),
      Lead(
        name: 'Sonal Singh',
        phone: '9812345678',
        stage: 'Won',
        date: DateTime(2025, 3, 2),
        activities: [],
        notesList: [],
        callLogs: [],
      ),
      Lead(
        name: 'Amit Joshi',
        phone: '9123456789',
        stage: 'Lost',
        date: DateTime(2025, 3, 2),
        activities: [],
        notesList: [],
        callLogs: [],
      ),
    ];
  }

  void _searchLead(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void showStageFilterBottomSheet() {
    showModalBottomSheet(
      backgroundColor: AppColor.cardBackground,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Filter by Stage',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...[
                  'All',
                  'New',
                  'Qualified',
                  'Proposition',
                  'Won',
                  'Lost',
                  "Today's Expected Closing",
                  "Tomorrow's Expected Closing",
                ].map((stage) {
                  return ListTile(
                    title: Text(stage),
                    trailing: Radio<String>(
                      activeColor: AppColor.secondaryColor,

                      value: stage,
                      groupValue: selectedStageFilter,
                      onChanged: (value) {
                        Navigator.pop(context);
                        setState(() {
                          selectedStageFilter = value!;
                          applyFilters();
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedStageFilter = stage;
                        applyFilters();
                      });
                    },
                  );
                }).toList(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: ['Name', 'Date'].map((option) {
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

  void applyFilters() {
    List<Lead> temp = List.from(leads);

    // Filter by stage
    if (selectedStageFilter != 'All') {
      temp = temp.where((lead) => lead.stage == selectedStageFilter).toList();
    }

    // Apply search query
    if (searchQuery.isNotEmpty) {
      temp = temp
          .where(
            (lead) =>
                lead.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Sort
    if (sortBy == 'Name') {
      temp.sort(
        (a, b) =>
            sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
      );
    } else if (sortBy == 'Date') {
      temp.sort(
        (a, b) =>
            sortAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
      );
    }

    setState(() {
      filteredLeads = temp;
    });
  }

  void _callLead(String phone) {}

  void _createNewLead() async {
    final newLead = await Navigator.push<Lead>(
      context,
      MaterialPageRoute(builder: (context) => const CreateLeadScreen()),
    );
    if (newLead != null) {
      setState(() {
        leads.add(newLead);
        applyFilters();
      });
    }
  }

  void _openLeadDetails(Lead lead) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeadDetailScreen(lead: lead)),
    );

    if (result is Lead) {
      setState(() {
        final index = leads.indexOf(lead);
        leads[index] = result;
        applyFilters();
      });
    } else if (result == 'delete') {
      setState(() {
        leads.remove(lead);
        applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _searchLead,
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
                  onPressed: showStageFilterBottomSheet,
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
            child: filteredLeads.isEmpty
                ? const Center(
                    child: Text(
                      'No leads found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredLeads.length,
                    itemBuilder: (context, index) {
                      final lead = filteredLeads[index];
                      return GestureDetector(
                        onTap: () => _openLeadDetails(lead),
                        child: Card(
                          color: AppColor.cardBackground,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.blue[400],
                                  child: Text(
                                    lead.name.isNotEmpty
                                        ? lead.name[0].toUpperCase()
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              lead.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStageColor(lead.stage),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              lead.stage,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        lead.phone,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.phone,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                            onPressed: () =>
                                                _callLead(lead.phone),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.message,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                            onPressed: () {},
                                          ),

                                          const Spacer(),
                                          Text(
                                            _formatDate(lead.date),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
        backgroundColor: Colors.blue[800],
        onPressed: _createNewLead,
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
      case 'Proposition':
        return Colors.teal;
      case 'Won':
        return Colors.green;
      case 'Lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}
