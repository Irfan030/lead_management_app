import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leads_management_app/menu/menu_widget.dart';

import '../widgets/pie_chart_widget.dart';

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
    Widget body;
    switch (_currentScreen) {
      case 'Leads':
        body = const LeadsScreen();
        break;
      case 'Reports':
        body = const ReportsScreen();
        break;
      default:
        body = _dashboardBody();
    }

    return Scaffold(
      body: SliderDrawer(
        key: _key,
        sliderOpenSize: 200,
        appBar: SliderAppBar(
          config: SliderAppBarConfig(
            title: Text(
              _currentScreen,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            drawerIconColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        slider: MenuWidget(
          onItemClick: (title) {
            setState(() {
              _currentScreen = title;
            });
            _key.currentState?.closeSlider();
          },
        ),
        child: body,
      ),
    );
  }

  Widget _dashboardBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileCard(),
          _buildMyOpportunityCard(),
          _buildTopOpportunities(),
          const SizedBox(height: 20),
          const PieChartWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff4facfe), Color(0xff00f2fe)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 4)),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/images/user.jpg"),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mitchell Admin",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "07-Feb-2022",
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyOpportunityCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Text(
                "My Opportunity",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _opportunityStat("Created", "21", Colors.blue.shade600),
                  _opportunityStat("Won", "1", Colors.green.shade600),
                  _opportunityStat("Ratio", "4.8%", Colors.orange.shade600),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _opportunityStat(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildTopOpportunities() {
    List<Map<String, String>> topList = [
      {"name": "Modernize old offices", "amount": "99,755.00"},
      {"name": "Trelian New Offices", "amount": "88,715.00"},
      {"name": "Need 20 Desks", "amount": "60,000.00"},
      {"name": "Design New Shelves", "amount": "54,587.00"},
      {"name": "Quote for 35 windows", "amount": "44,437.00"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Top 5 Opportunity",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              ...topList.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          e["name"]!,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                      Text(
                        "\$${e["amount"]}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
