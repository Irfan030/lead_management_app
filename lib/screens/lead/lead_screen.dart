import 'package:flutter/material.dart';
import 'package:leads_management_app/models/dummy_leads.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/size_config.dart';
import 'package:leads_management_app/utils/color_utils.dart';
import 'package:leads_management_app/widgets/loader.dart';
import 'package:leads_management_app/widgets/text_button_with_icon.dart';
import 'package:leads_management_app/widgets/title_widget.dart';

import 'create_lead_screen.dart';
import 'lead_detail.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  bool _isLoading = false;
  List<Lead> _leads = [];
  List<Lead> _filteredLeads = [];
  String _selectedStageFilter = 'All';
  final String _sortBy = 'Name';
  bool _sortAscending = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _stages = [
    'All',
    'New',
    'Qualified',
    'Proposition',
    'Won',
    'Lost',
    "Today's Expected Closing",
    "Tomorrow's Expected Closing",
  ];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLeads() async {
    setState(() => _isLoading = true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      _leads = getDummyLeads();
      _applyFilters();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading leads: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _searchLead(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _showStageFilterBottomSheet() {
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
                const TitleWidget(
                  val: 'Filter by Stage',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                ..._stages.map((stage) {
                  return ListTile(
                    title: TitleWidget(val: stage),
                    trailing: Radio<String>(
                      activeColor: AppColor.secondaryColor,
                      value: stage,
                      groupValue: _selectedStageFilter,
                      onChanged: (value) {
                        Navigator.pop(context);
                        setState(() {
                          _selectedStageFilter = value!;
                          _applyFilters();
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedStageFilter = stage;
                        _applyFilters();
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

  void _toggleSortOrder() {
    setState(() {
      _sortAscending = !_sortAscending;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Lead> temp = List.from(_leads);

    // Filter by stage
    if (_selectedStageFilter != 'All') {
      temp = temp.where((lead) => lead.stage == _selectedStageFilter).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where(
            (lead) =>
                lead.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                lead.phone.contains(_searchQuery),
          )
          .toList();
    }

    // Sort
    if (_sortBy == 'Name') {
      temp.sort(
        (a, b) => _sortAscending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name),
      );
    } else if (_sortBy == 'Date') {
      temp.sort(
        (a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return 1;
          if (b.date == null) return -1;
          return _sortAscending
              ? a.date!.compareTo(b.date!)
              : b.date!.compareTo(a.date!);
        },
      );
    }

    setState(() {
      _filteredLeads = temp;
    });
  }

  void _callLead(String phone) {
    // TODO: Implement phone call functionality
  }

  void _createNewLead() async {
    final newLead = await Navigator.push<Lead>(
      context,
      MaterialPageRoute(builder: (context) => const CreateLeadScreen()),
    );
    if (newLead != null) {
      setState(() {
        _leads.add(newLead);
        _applyFilters();
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
        final index = _leads.indexOf(lead);
        _leads[index] = result;
        _applyFilters();
      });
    } else if (result == 'delete') {
      setState(() {
        _leads.remove(lead);
        _applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: _isLoading
          ? const Center(child: Loader())
          : Column(
              children: [
                _buildSearchAndFilter(),
                Expanded(
                  child: _filteredLeads.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredLeads.length,
                          itemBuilder: (context, index) =>
                              _buildLeadCard(_filteredLeads[index]),
                        ),
                ),
              ],
            ),
      floatingActionButton: TextButtonWithIcon(
        text: 'New Lead',
        onPressed: _createNewLead,
        icon: Icons.add,
        backgroundColor: AppColor.mainColor,
        textColor: Colors.white,
        borderRadius: 12,
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
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
            onPressed: _showStageFilterBottomSheet,
          ),
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            onPressed: _toggleSortOrder,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: getProportionateScreenWidth(64),
            color: Colors.grey[400],
          ),
          SizedBox(height: getProportionateScreenHeight(16)),
          const TitleWidget(
            val: 'No Leads Found',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          const TitleWidget(
            val: 'Try adjusting your search or filter',
            fontSize: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildLeadCard(Lead lead) {
    return Card(
      color: AppColor.whiteColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _openLeadDetails(lead),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue[400],
                child: TitleWidget(
                  val: lead.name.isNotEmpty ? lead.name[0].toUpperCase() : '',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                          child: TitleWidget(
                            val: lead.name,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                ColorUtils.getStageColor(lead.stage ?? 'New'),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TitleWidget(
                            val: lead.stage ?? 'New',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    TitleWidget(
                      val: lead.phone,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.blue,
                            size: 20,
                          ),
                          onPressed: () => _callLead(lead.phone),
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
                        TitleWidget(
                          val: lead.date != null
                              ? _formatDate(lead.date!)
                              : 'N/A',
                          fontSize: 12,
                          color: Colors.grey,
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
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}
