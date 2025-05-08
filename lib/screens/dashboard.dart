import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leads_management_app/menu/menu_widget.dart';
import 'package:leads_management_app/screens/quotation/quotation_order_screen.dart';
import 'package:leads_management_app/screens/report/reports_screen.dart';
import 'package:leads_management_app/theme/colors.dart';

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
              title: Text(
                _currentScreen,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
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
                });
                _key.currentState?.closeSlider();
              }
            },
          ),
          child: body,
        ),
      ),
    );
  }

  Widget _getScreen(String screen) {
    switch (screen) {
      case 'Customer':
        return const LeadListScreen();
      case 'Opportunity':
        return const OpportunityScreen();
      case 'Quotation/Order':
        return const QuotationOrderScreen();
      case 'Invoices':
        return const InvoicesScreen();
      case 'Activity':
        return ActivityScreen();
      case 'Reports':
        return const ReportsScreen();
      case 'Leads':
        return const LeadListScreen();
      case 'Map':
        return const MapScreen();
      case 'Attendance':
        return const AttendanceScreen();
      case 'Dashboard':
      default:
        return _dashboardBody();
    }
  }

  Widget _dashboardBody() {
    List<Map<String, dynamic>> stats = [
      {
        "icon": Icons.group,
        "label": "Total Leads",
        "count": 5,
        "color": AppColor.mainColor,
      },
      {
        "icon": Icons.person_add_alt_1,
        "label": "New Leads",
        "count": 5,
        "color": AppColor.secondaryColor,
      },
      {
        "icon": Icons.person_off,
        "label": "Lost Leads",
        "count": 0,
        "color": Colors.deepPurple,
      },
      {
        "icon": Icons.event_available,
        "label": "Today Activities",
        "count": 2,
        "color": AppColor.successColor,
      },
      {
        "icon": Icons.schedule,
        "label": "Overdue Activities",
        "count": 0,
        "color": AppColor.errorColor,
      },
      {
        "icon": Icons.upcoming,
        "label": "Upcoming Activities",
        "count": 1,
        "color": Colors.orange,
      },
    ];

    return Container(
      color: AppColor.scaffoldBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Mitchell !",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
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
          ],
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
            color: Colors.grey.withOpacity(0.2),
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
            Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add your logout logic here
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
