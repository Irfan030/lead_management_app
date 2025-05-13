import 'package:flutter/material.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/size_config.dart';
import 'package:leads_management_app/widgets/loader.dart';
import 'package:leads_management_app/widgets/text_button.dart';
import 'package:leads_management_app/widgets/title_widget.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: TitleWidget(
          val: 'LEAD DETAILS',
          color: AppColor.whiteColor,
          fontSize: getProportionateScreenWidth(18),
          fontWeight: FontWeight.w600,
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
          unselectedLabelColor: AppColor.whiteColor.withOpacity(0.7),
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
      body: _isLoading
          ? const Loader()
          : Column(
              children: [
                _buildLeadHeader(),
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

  Widget _buildLeadHeader() {
    return Container(
      color: AppColor.scaffoldBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(
                  val: widget.lead.name,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStageColor(widget.lead.stage ?? 'New'),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TitleWidget(
                    val: widget.lead.stage ?? 'New',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onEditLead() async {
    setState(() => _isLoading = true);
    try {
      final updatedLead = await Navigator.push<Lead>(
        context,
        MaterialPageRoute(
          builder: (context) => CreateLeadScreen(lead: widget.lead),
        ),
      );
      if (updatedLead != null) {
        Navigator.pop(context, updatedLead);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onDeleteLead() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const TitleWidget(
          val: 'Delete Lead',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        content: const TitleWidget(
          val: 'Are you sure you want to delete this lead?',
          fontSize: 14,
        ),
        actions: [
          SizedBox(
            width: SizeConfig.screenWidth / 4,
            child: TextButtonWidget(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context, false),
            ),
          ),
          SizedBox(
            width: SizeConfig.screenWidth / 4,
            height: 35,
            child: TextButtonWidget(
              borderRadius: 15,
              text: 'Delete',
              textColor: Colors.white,
              backgroundColor: Colors.red,
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        Navigator.pop(context, 'delete');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildGeneralTab() {
    return Container(
      color: AppColor.scaffoldBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWidget(
              val: 'Personal Information',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.person,
              label: 'Contact Name',
              value: widget.lead.name,
            ),
            _buildInfoCard(
              icon: Icons.phone,
              label: 'Phone Number',
              value: widget.lead.phone,
              actions: [
                IconButton(
                  icon: const Icon(Icons.phone, color: Colors.blue),
                  onPressed: () => _makePhoneCall(widget.lead.phone),
                ),
                IconButton(
                  icon: const Icon(Icons.message, color: Colors.blue),
                  onPressed: () => _sendMessage(widget.lead.phone),
                ),
              ],
            ),
            if (widget.lead.email != null)
              _buildInfoCard(
                icon: Icons.email,
                label: 'Email',
                value: widget.lead.email!,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.email, color: Colors.blue),
                    onPressed: () => _sendEmail(widget.lead.email!),
                  ),
                ],
              ),
            if (widget.lead.companyName != null)
              _buildInfoCard(
                icon: Icons.business,
                label: 'Company Name',
                value: widget.lead.companyName!,
              ),
            if (widget.lead.address != null)
              _buildInfoCard(
                icon: Icons.location_on,
                label: 'Address',
                value: widget.lead.address!,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.map, color: Colors.blue),
                    onPressed: () => _openMap(widget.lead.address!),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            TitleWidget(
              val: 'Lead Details',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            _buildInfoCard(
              icon: Icons.label,
              label: 'Status',
              value: widget.lead.status.toString().split('.').last,
            ),
            _buildInfoCard(
              icon: Icons.local_offer,
              label: 'Tag',
              value: widget.lead.tag.toString().split('.').last,
            ),
            _buildInfoCard(
              icon: Icons.source,
              label: 'Source',
              value: widget.lead.source.toString().split('.').last,
            ),
            _buildInfoCard(
              icon: Icons.score,
              label: 'Lead Score',
              value: widget.lead.leadScore.toString(),
            ),
            if (widget.lead.followUpDate != null)
              _buildInfoCard(
                icon: Icons.calendar_today,
                label: 'Follow-up Date',
                value: _formatDate(widget.lead.followUpDate!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    List<Widget>? actions,
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
                  TitleWidget(
                    val: label,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 2),
                  TitleWidget(
                    val: value,
                    fontSize: 15,
                  ),
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
            child: TitleWidget(
              val: "Today's Activity",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700]!,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
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
                          color: activity.color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(activity.icon, color: activity.color, size: 32),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleWidget(
                              val: activity.type,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: activity.color,
                            ),
                            TitleWidget(
                              val: activity.desc,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TitleWidget(
                            val: 'End:-',
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          TitleWidget(
                            val: activity.date,
                            fontSize: 13,
                          ),
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
            TitleWidget(
              val: 'Completed Activity & Notes',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700]!,
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
                                  child: TitleWidget(
                                    val: day,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TitleWidget(
                                  val: month,
                                  fontSize: 11,
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
                                    TitleWidget(
                                      val: note.date,
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                TitleWidget(
                                  val: note.desc,
                                  fontSize: 14,
                                ),
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
            TitleWidget(
              val: 'Call-Recording',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700]!,
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
                              TitleWidget(
                                val: '${log.type} Call to ${log.name}',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              if (log.recording == true)
                                IconButton(
                                  icon: const Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.blue,
                                    size: 32,
                                  ),
                                  onPressed: () => _playRecording(log),
                                ),
                            ],
                          ),
                          TitleWidget(
                            val: log.datetime,
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          TitleWidget(
                            val: 'Duration: ${log.duration}',
                            fontSize: 13,
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

  // Action handlers
  void _makePhoneCall(String phone) {
    // TODO: Implement phone call functionality
  }

  void _sendMessage(String phone) {
    // TODO: Implement message functionality
  }

  void _sendEmail(String email) {
    // TODO: Implement email functionality
  }

  void _openMap(String address) {
    // TODO: Implement map functionality
  }

  void _playRecording(dynamic log) {
    // TODO: Implement recording playback
  }
}
