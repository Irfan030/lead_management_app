import 'package:flutter/material.dart';
import 'package:leads_management_app/Repository/Repository.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
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
  String selectedTypeFilter = 'All';
  String selectedPriorityFilter = 'All';

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
      searchQuery = query.toLowerCase();
      applyFilters();
    });
  }

  String getPriorityLabel(String? priority) {
    switch (priority) {
      case '1':
        return 'Low';
      case '2':
        return 'Medium';
      case '3':
        return 'High';
      default:
        return 'Low';
    }
  }

  String getPriorityValue(String label) {
    switch (label) {
      case 'High':
        return '3';
      case 'Medium':
        return '2';
      case 'Low':
        return '1';
      default:
        return '1';
    }
  }

  Widget buildPriorityStars(String? priority) {
    final count = int.tryParse(priority ?? '1') ?? 1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          index < count ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  void showFilterBottomSheet() {
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
                  'Filter Leads',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Filter by Type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    'All',
                    'Contact',
                    'Opportunity',
                    'Other',
                  ].map((type) {
                    return FilterChip(
                      label: Text(type),
                      selected: selectedTypeFilter == type,
                      onSelected: (selected) {
                        setState(() {
                          selectedTypeFilter = selected ? type : 'All';
                          applyFilters();
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Filter by Priority',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    'All',
                    'High',
                    'Medium',
                    'Low',
                  ].map((priority) {
                    return FilterChip(
                      label: Text(priority),
                      selected: selectedPriorityFilter == priority,
                      onSelected: (selected) {
                        setState(() {
                          selectedPriorityFilter = selected ? priority : 'All';
                          applyFilters();
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
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
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort Leads',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Name'),
              trailing: Radio<String>(
                value: 'Name',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                    applyFilters();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Company'),
              trailing: Radio<String>(
                value: 'Company',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                    applyFilters();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Type'),
              trailing: Radio<String>(
                value: 'Type',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                    applyFilters();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Priority'),
              trailing: Radio<String>(
                value: 'Priority',
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = value!;
                    applyFilters();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
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

    // Filter by type
    if (selectedTypeFilter != 'All') {
      temp = temp.where((lead) {
        final type = lead.type?.toLowerCase() ?? '';
        final selectedType = selectedTypeFilter.toLowerCase();
        return type == selectedType;
      }).toList();
    }

    // Filter by priority
    if (selectedPriorityFilter != 'All') {
      temp = temp.where((lead) {
        final priority = lead.priority ?? '1';
        final selectedPriority = getPriorityValue(selectedPriorityFilter);
        return priority == selectedPriority;
      }).toList();
    }

    // Apply search query
    if (searchQuery.isNotEmpty) {
      temp = temp.where((lead) {
        return lead.name.toLowerCase().contains(searchQuery) ||
            (lead.phone?.toLowerCase().contains(searchQuery) ?? false) ||
            (lead.email_from?.toLowerCase().contains(searchQuery) ?? false) ||
            (lead.contact_name?.toLowerCase().contains(searchQuery) ?? false) ||
            (lead.partner_name?.toLowerCase().contains(searchQuery) ?? false);
      }).toList();
    }

    // Sort
    switch (sortBy) {
      case 'Name':
        temp.sort((a, b) => sortAscending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'Company':
        temp.sort((a, b) {
          final aCompany = a.partner_name ?? '';
          final bCompany = b.partner_name ?? '';
          return sortAscending
              ? aCompany.compareTo(bCompany)
              : bCompany.compareTo(aCompany);
        });
        break;
      case 'Type':
        temp.sort((a, b) {
          final aType = a.type ?? '';
          final bType = b.type ?? '';
          return sortAscending
              ? aType.compareTo(bType)
              : bType.compareTo(aType);
        });
        break;
      case 'Priority':
        temp.sort((a, b) {
          final aPriority = int.tryParse(a.priority ?? '1') ?? 1;
          final bPriority = int.tryParse(b.priority ?? '1') ?? 1;
          return sortAscending
              ? aPriority.compareTo(bPriority)
              : bPriority.compareTo(aPriority);
        });
        break;
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
                      hintText: 'Search by name, phone, email, company...',
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
                  onPressed: showFilterBottomSheet,
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
                  ? const Center(child: Loader())
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
                              child: _buildLeadListItem(lead),
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

  Widget _buildLeadListItem(Lead lead) {
    return Card(
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
                lead.name.isNotEmpty ? lead.name[0].toUpperCase() : '',
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          getPriorityLabel(lead.priority),
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lead.phone ?? '',
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
                        onPressed: () => _callLead(lead.phone!),
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
