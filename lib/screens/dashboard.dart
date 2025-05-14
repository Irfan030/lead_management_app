import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:leads_management_app/menu/menu_widget.dart';
import 'package:leads_management_app/screens/quotation/quotation_order_screen.dart';
import 'package:leads_management_app/screens/report/reports_screen.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leads_management_app/widgets/text_button.dart';
import 'package:leads_management_app/widgets/title_widget.dart';

import 'activity/activity_screen.dart';
import 'attendance/attendance_screen.dart';
import 'invoice/invoices_screen.dart';
import 'lead/lead_screen.dart';
import 'maps/map_screens.dart';
import 'opportunity/opportunity_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  String _currentScreen = 'Dashboard';
  bool _isLoading = false;
  final GlobalKey _screenKey = GlobalKey();
  Map<String, dynamic> _dashboardData = {
    'totalLeads': 0,
    'newLeads': 0,
    'lostLeads': 0,
    'todayActivities': 0,
    'overdueActivities': 0,
    'upcomingActivities': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace with your actual API call
      await Future.delayed(const Duration(seconds: 1)); // Simulated API delay

      // Simulated data - replace with actual API response
      setState(() {
        _dashboardData = {
          'totalLeads': 5,
          'newLeads': 5,
          'lostLeads': 0,
          'todayActivities': 2,
          'overdueActivities': 0,
          'upcomingActivities': 1,
        };
      });
    } catch (e) {
      // Handle error
      debugPrint('Error loading dashboard data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _getScreen(_currentScreen);

    return Scaffold(
      body: SafeArea(
        child: SliderDrawer(
          key: _key,
          sliderOpenSize: 200,
          isDraggable: false,
          appBar: SliderAppBar(
            config: SliderAppBarConfig(
              title: TitleWidget(
                val: _currentScreen,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              backgroundColor: AppColor.mainColor,
              drawerIconColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
          ),
          slider: MenuWidget(
            onItemClick: (title) {
              if (title == 'Logout') {
                _showLogoutConfirmation();
              } else {
                setState(() {
                  _currentScreen = title;
                  _screenKey.currentState?.setState(() {});
                });
                _key.currentState?.closeSlider();
              }
            },
          ),
          child: KeyedSubtree(
            key: _screenKey,
            child: body,
          ),
        ),
      ),
    );
  }

  Widget _getScreen(String screen) {
    switch (screen) {
      case 'Dashboard':
        return _dashboardBody();
      case 'Leads':
        return const LeadListScreen();
      case 'Opportunity':
        return const OpportunityScreen();
      case 'Quotation/Order':
        return const QuotationOrderScreen();
      case 'Invoices':
        return const InvoicesScreen();
      case 'Activity':
        return const ActivityScreen();
      case 'Reports':
        return const ReportsScreen();
      case 'Attendance':
        return const AttendanceScreen();
      case 'Map':
        return const MapScreen();
      default:
        return _dashboardBody();
    }
  }

  Widget _dashboardBody() {
    if (_isLoading) {
      return const Center(child: Loader());
    }

    List<Map<String, dynamic>> stats = [
      {
        "icon": Icons.group,
        "label": "Total Leads",
        "count": _dashboardData['totalLeads'],
        "color": AppColor.mainColor,
      },
      {
        "icon": Icons.person_add_alt_1,
        "label": "New Leads",
        "count": _dashboardData['newLeads'],
        "color": AppColor.secondaryColor,
      },
      {
        "icon": Icons.person_off,
        "label": "Lost Leads",
        "count": _dashboardData['lostLeads'],
        "color": Colors.deepPurple,
      },
      {
        "icon": Icons.event_available,
        "label": "Today Activities",
        "count": _dashboardData['todayActivities'],
        "color": AppColor.successColor,
      },
      {
        "icon": Icons.schedule,
        "label": "Overdue Activities",
        "count": _dashboardData['overdueActivities'],
        "color": AppColor.errorColor,
      },
      {
        "icon": Icons.upcoming,
        "label": "Upcoming Activities",
        "count": _dashboardData['upcomingActivities'],
        "color": Colors.orange,
      },
    ];

    return Container(
      color: AppColor.scaffoldBackground,
      child: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: TitleWidget(
                  val: "Mitchell !",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  return _buildStatCard(
                    icon: stats[index]["icon"],
                    label: stats[index]["label"],
                    count: stats[index]["count"],
                    color: stats[index]["color"],
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.2 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            TitleWidget(
              val: count.toString(),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            const SizedBox(height: 8),
            TitleWidget(
              val: label,
              fontSize: 14,
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(
          val: "Quick Actions",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextButtonWidget(
                text: "Add New Lead",
                onPressed: () {
                  // Navigate to add lead screen
                },
                backgroundColor: AppColor.mainColor,
                textColor: Colors.white,
                fontSize: 14,
                padding: const EdgeInsets.symmetric(vertical: 12),
                borderRadius: 8,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextButtonWidget(
                text: "Create Quotation",
                onPressed: () {
                  // Navigate to create quotation screen
                },
                backgroundColor: AppColor.mainColor,
                textColor: Colors.white,
                fontSize: 14,
                padding: const EdgeInsets.symmetric(vertical: 12),
                borderRadius: 8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const TitleWidget(
          val: 'Confirm Logout',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: const TitleWidget(
          val: 'Are you sure you want to logout?',
          fontSize: 14,
        ),
        actions: [
          TextButtonWidget(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            textColor: Colors.grey,
          ),
          TextButtonWidget(
            text: 'Logout',
            onPressed: () async {
              Navigator.of(context).pop();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              // Add your logout logic here
              Navigator.of(context).pushReplacementNamed('/login');
            },
            textColor: AppColor.errorColor,
          ),
        ],
      ),
    );
  }
}
