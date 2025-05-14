import 'package:flutter/material.dart';
import 'package:leads_management_app/Repository/Repository.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/utils/color_utils.dart';
import 'package:leads_management_app/widgets/loader.dart';

import 'create_lead_screen.dart';
import 'lead_detail.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  Repository repository = Repository();

  List<Lead> leads = [];
  List<Lead> filteredLeads = [];
  String selectedStageFilter = 'All';
  String sortBy = 'Name';
  bool sortAscending = true;
  String searchQuery = '';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _leadList();
  }

  Future<void> _leadList() async {
    setState(() {
      isLoading = true;
    });

    try {
      selectedStageFilter = 'All';
      var body = {
        "fields": [
          "name",
          "phone",
          "email_from",
          "contact_name",
          "partner_name",
          "description",
          "street",
          "city",
          "zip",
          "function",
          "website",
          "priority",
          "type",
        ]
      };
      var param = {"model": "crm.lead", 'body': body};

      print("API Request Parameters: $param");
      var response = await repository.getLeads(param);
      print("API Response: $response");

      if (response != null && response is Map<String, dynamic>) {
        print("Response type: ${response.runtimeType}");
        print("Response keys: ${response.keys.toList()}");

        if (response["statusCode"] == 200 &&
            response['body'] != null &&
            response['body']['records'] != null) {
          final rawList = response['body']['records'] as List;
          print("Raw Records from API: $rawList");

          final fetchedLeads =
              rawList.map((item) => Lead.fromJson(item)).toList();
          print("Parsed Leads: $fetchedLeads");

          setState(() {
            leads = fetchedLeads;
            filteredLeads = List.from(leads);
          });
        } else {
          print("Invalid response structure or no records found");
          print("Response body: ${response['body']}");
        }
      } else {
        print("Invalid response format: $response");
      }
    } catch (e, stackTrace) {
      print("Error loading leads: $e");
      print("Stack trace: $stackTrace");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _searchLead(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void showStageFilterBottomSheet() {
    showModalBottomSheet(
      backgroundColor: AppColor.whiteColor,
      context: context,
      shape: const RoundedRectangleBorder(
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
        (a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return 1;
          if (b.date == null) return -1;
          return sortAscending
              ? a.date!.compareTo(b.date!)
              : b.date!.compareTo(a.date!);
        },
      );
    }

    setState(() {
      filteredLeads = temp;
    });
  }

  void _callLead(String phone) {}

  void _createNewLead() async {
    final newLead = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateLeadScreen()),
    );
    setState(() {
      _leadList();
    });
  }

  void _openLeadDetails(Lead lead) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeadDetailScreen(lead: lead)),
    );
    if (result == 'edit') {
      setState(() {
        _leadList();
      });
    } else if (result == 'delete') {
      setState(() {
        _leadList();
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
            child: RefreshIndicator(
              onRefresh: _leadList,
              child: isLoading
                  ? const Loader()
                  : filteredLeads.isEmpty
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
                                color: AppColor.whiteColor,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils
                                                        .getStageColor(
                                                      lead.stage ?? 'New',
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    lead.stage ?? 'New',
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
                                              lead.phone!,
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
                                                      _callLead(lead.phone!),
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
                                                  lead.date != null
                                                      ? _formatDate(lead.date!)
                                                      : '',
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
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}
