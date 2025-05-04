import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/theme/colors.dart';

class MenuWidget extends StatelessWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key? key, required this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_DrawerItem> drawerItems = [
      _DrawerItem('Dashboard', Icons.dashboard),
      _DrawerItem('Leads', Icons.people_alt_outlined),
      _DrawerItem('Opportunity', Icons.business_center_outlined),
      _DrawerItem('Quotation/Order', Icons.receipt_long_outlined),
      _DrawerItem('Invoices', Icons.request_quote_outlined),
      _DrawerItem('Activity', Icons.timeline_outlined),
      _DrawerItem('Reports', Icons.bar_chart_outlined),
      _DrawerItem('Contact', Icons.contact_mail_outlined),
    ];

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColor.mainColor,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 40),

                  CircleAvatar(
                    radius: 40,

                    backgroundImage: AssetImage(AppData.profile),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Mitchell Admin',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColor.cardBackground,
                      fontWeight: FontWeight.bold,
                    ),
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
                  return _buildMenuItem(item.title, item.icon);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton.icon(
                onPressed: () => onItemClick('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor, // Button background
                  foregroundColor: AppColor.cardBackground,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
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
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
  _DrawerItem(this.title, this.icon);
}
