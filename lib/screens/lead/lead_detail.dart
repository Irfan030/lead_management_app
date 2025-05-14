import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/size_config.dart';

import '../../Repository/Repository.dart';
import 'create_lead_screen.dart';

class LeadDetailScreen extends StatefulWidget {
  final Lead lead;

  const LeadDetailScreen({super.key, required this.lead});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Repository repository = Repository();
  bool isLoading = false;
  Lead? detailedLead;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    setState(() {
      detailedLead = widget.lead;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.mainColor,
        elevation: 0,
        title: Text(
          'Lead Details',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.whiteColor,
            size: getProportionateScreenWidth(20),
          ),
          onPressed: Navigator.of(context).pop,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _onEditLead,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _onDeleteLead,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColor.scaffoldBackground,
          unselectedLabelColor: AppColor.whiteColor.withAlphaDouble(0.7),
          indicatorColor: AppColor.scaffoldBackground,
          indicatorWeight: 3.5,
          tabs: const [
            Tab(text: 'General'),
            Tab(text: 'Activity'),
            Tab(text: 'Notes'),
            Tab(text: 'Call-Log'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColor.scaffoldBackground,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detailedLead?.name ?? widget.lead.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStageColor(detailedLead?.stage ??
                              widget.lead.stage ??
                              'New'),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          detailedLead?.stage ?? widget.lead.stage ?? 'New',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGeneralTab(),
                _buildActivityTab(),
                _buildNotesTab(),
                _buildCallLogTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onEditLead() async {
    final updatedLead = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateLeadScreen(lead: widget.lead),
      ),
    );
    if (updatedLead != null) {
      Navigator.pop(context, 'edit');
    }
  }

  void _onDeleteLead() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lead'),
        content: const Text('Are you sure you want to delete this lead?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      var param = {"model": "crm.lead", 'id': widget.lead.id};
      final response = await repository.deleteLead(param);
      print("response delete : ${response}");
      if (response["statusCode"] == 200 &&
          response['body'] != null &&
          response['body']['Resource deleted'] is List &&
          response['body']['Resource deleted'].isNotEmpty) {
        Navigator.pop(context, 'delete');
        AppData.showSnackBar(context, 'Lead Deleted successfully!');
        return;
      } else {
        AppData.showSnackBar(context, 'Failed to delete Lead.');
      }
    }
  }

  Widget _buildGeneralTab() {
    final lead = detailedLead ?? widget.lead;
    print("Building General Tab with Lead: $lead");

    String cleanDescription(String? text) {
      if (text == null) return '';
      // Remove HTML tags
      return text.replaceAll(RegExp(r'<[^>]*>'), '');
    }

    Widget buildPriorityStars(String? priority) {
      final count = int.tryParse(priority ?? '0') ?? 0;
      return Row(
        children: List.generate(3, (index) {
          return Icon(
            index < count ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
      );
    }

    return Container(
      color: AppColor.scaffoldBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            _infoCard(
              icon: Icons.person,
              label: 'Name',
              value: lead.name,
            ),
            if (lead.contact_name != null && lead.contact_name!.isNotEmpty)
              _infoCard(
                icon: Icons.person_outline,
                label: 'Contact Person',
                value: lead.contact_name!,
              ),
            if (lead.phone != null && lead.phone!.isNotEmpty)
              _infoCard(
                icon: Icons.phone,
                label: 'Phone Number',
                value: lead.phone!,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.message, color: Colors.blue),
                    onPressed: () {},
                  ),
                ],
              ),
            if (lead.email_from != null && lead.email_from!.isNotEmpty)
              _infoCard(
                icon: Icons.email,
                label: 'Email',
                value: lead.email_from!,
              ),
            if (lead.function != null && lead.function!.isNotEmpty)
              _infoCard(
                icon: Icons.work,
                label: 'Function',
                value: lead.function!,
              ),
            const SizedBox(height: 16),
            const Text(
              'Company Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            if (lead.partner_name != null && lead.partner_name!.isNotEmpty)
              _infoCard(
                icon: Icons.business,
                label: 'Company Name',
                value: lead.partner_name!,
              ),
            if (lead.website != null && lead.website!.isNotEmpty)
              _infoCard(
                icon: Icons.language,
                label: 'Website',
                value: lead.website!,
              ),
            if (lead.type != null && lead.type!.isNotEmpty)
              _infoCard(
                icon: Icons.category,
                label: 'Type',
                value: lead.type!,
              ),
            if (lead.priority != null && lead.priority!.isNotEmpty)
              _infoCard(
                icon: Icons.priority_high,
                label: 'Priority',
                value: '',
                customValue: buildPriorityStars(lead.priority),
              ),
            const SizedBox(height: 16),
            const Text(
              'Address Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            if (lead.street != null && lead.street!.isNotEmpty)
              _infoCard(
                icon: Icons.location_on,
                label: 'Street',
                value: lead.street!,
              ),
            if (lead.city != null && lead.city!.isNotEmpty)
              _infoCard(
                icon: Icons.location_city,
                label: 'City',
                value: lead.city!,
              ),
            if (lead.zip != null && lead.zip!.isNotEmpty)
              _infoCard(
                icon: Icons.local_post_office,
                label: 'ZIP Code',
                value: lead.zip!.trim(),
              ),
            const SizedBox(height: 16),
            const Text(
              'Additional Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            if (lead.description != null && lead.description!.isNotEmpty)
              _infoCard(
                icon: Icons.description,
                label: 'Description',
                value: cleanDescription(lead.description),
              ),
            if (lead.stage != null && lead.stage!.isNotEmpty)
              _infoCard(
                icon: Icons.label,
                label: 'Stage',
                value: lead.stage!,
              ),
            if (lead.date != null)
              _infoCard(
                icon: Icons.calendar_today,
                label: 'Created Date',
                value: _formatDate(lead.date!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    List<Widget>? actions,
    Widget? customValue,
  }) {
    return Card(
      color: AppColor.whiteColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  customValue ??
                      Text(value, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
            if (actions != null) ...actions,
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTab() {
    final activities = widget.lead.activities;
    return Container(
      color: AppColor.scaffoldBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              "Today's Activity",
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final a = activities[index];
                return Card(
                  color: AppColor.whiteColor,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 70,
                        decoration: BoxDecoration(
                          color: a.color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(a.icon, color: a.color, size: 32),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.type,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: a.color,
                                fontSize: 16,
                              ),
                            ),
                            Text(a.desc, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'End:-',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(a.date, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesTab() {
    final notes = widget.lead.notesList;
    return Container(
      color: AppColor.scaffoldBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Activity & Notes',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final dateParts = note.date.split('-');
                  final day = dateParts[0];
                  final month = _monthName(int.parse(dateParts[1]));
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 32,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  month,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          if (index < notes.length - 1)
                            Container(
                              width: 2,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          color: AppColor.whiteColor,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    Text(
                                      note.date,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(note.desc),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallLogTab() {
    final callLogs = widget.lead.callLogs;
    return Container(
      color: AppColor.scaffoldBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Call-Recording',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: callLogs.length,
                itemBuilder: (context, index) {
                  final log = callLogs[index];
                  return Card(
                    color: AppColor.whiteColor,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${log.type} Call to ${log.name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              if (log.recording == true)
                                IconButton(
                                  icon: const Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.blue,
                                    size: 32,
                                  ),
                                  onPressed: () {},
                                ),
                            ],
                          ),
                          Text(
                            log.datetime,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Duration: ${log.duration}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month];
  }
}
