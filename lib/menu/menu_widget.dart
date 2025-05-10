import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';

class MenuWidget extends StatelessWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key? key, required this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_DrawerItem> drawerItems = [
      _DrawerItem('Dashboard', Icons.dashboard_outlined, RoutePath.dashboard),
      _DrawerItem('Leads', Icons.people_alt_outlined, RoutePath.lead),
      _DrawerItem(
          'Opportunity', Icons.trending_up_outlined, RoutePath.opportunity),
      _DrawerItem(
          'Quotation/Order', Icons.description_outlined, RoutePath.quotation),
      _DrawerItem('Invoices', Icons.receipt_long_outlined, RoutePath.invoices),
      _DrawerItem('Activity', Icons.event_note_outlined, RoutePath.activity),
      _DrawerItem('Reports', Icons.analytics_outlined, RoutePath.reports),
      _DrawerItem(
          'Attendance', Icons.calendar_today_outlined, RoutePath.attendance),
      _DrawerItem('Map', Icons.location_on_outlined, RoutePath.map),
    ];

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColor.mainColor,
              child: const Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 40),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(AppData.profile),
                  ),
                  SizedBox(height: 10),
                  TitleWidget(
                    val: 'Mitchell Admin',
                    fontSize: 20,
                    color: AppColor.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  final item = drawerItems[index];
                  return _buildMenuItem(item.title, item.icon, item.route);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () => onItemClick('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor,
                  foregroundColor: AppColor.whiteColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const TitleWidget(
                  val: "Logout",
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, String route) {
    return SafeArea(
      child: InkWell(
        onTap: () => onItemClick(title),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.black87),
              const SizedBox(width: 20),
              Expanded(
                child: TitleWidget(
                  val: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem {
  final String title;
  final IconData icon;
  final String route;
  _DrawerItem(this.title, this.icon, this.route);
}
