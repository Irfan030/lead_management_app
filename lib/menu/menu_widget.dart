// import 'package:flutter/material.dart';
//
// class MenuWidget extends StatelessWidget {
//   final Function(String) onItemClick;
//
//   const MenuWidget({Key? key, required this.onItemClick}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             // Profile Picture
//             CircleAvatar(
//               radius: 40,
//               backgroundImage: AssetImage(
//                 'assets/images/user.jpg',
//               ), // your local image
//               // or use NetworkImage('your_image_url') if online
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Nikhil',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),
//
//             // Menu Items
//             _drawerItem(
//               icon: Icons.home,
//               text: 'Home',
//               onTap: () => onItemClick('Home'),
//             ),
//             _drawerItem(
//               icon: Icons.add_circle_outline,
//               text: 'Add Post',
//               onTap: () => onItemClick('Add Post'),
//             ),
//             _drawerItem(
//               icon: Icons.notifications_none,
//               text: 'Notification',
//               onTap: () => onItemClick('Notification'),
//             ),
//             _drawerItem(
//               icon: Icons.favorite_border,
//               text: 'Likes',
//               onTap: () => onItemClick('Likes'),
//             ),
//             _drawerItem(
//               icon: Icons.settings,
//               text: 'Setting',
//               onTap: () => onItemClick('Setting'),
//             ),
//
//             const Spacer(),
//
//             // Logout Item
//             _drawerItem(
//               icon: Icons.logout,
//               text: 'LogOut',
//               onTap: () => onItemClick('LogOut'),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _drawerItem({
//     required IconData icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(
//         text,
//         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//       onTap: onTap,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';

class MenuWidget extends StatelessWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key? key, required this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_DrawerItem> drawerItems = [
      _DrawerItem('Dashboard', Icons.dashboard),
      _DrawerItem('Customer', Icons.people_alt_outlined),
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
            const SizedBox(height: 40),
            // Profile Picture
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                AppData.profile,
              ), // Use your own image
            ),
            const SizedBox(height: 10),
            const Text(
              'Nikhil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Menu Items
            Expanded(
              child: ListView.builder(
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  final item = drawerItems[index];
                  return _buildMenuItem(item.title, item.icon);
                },
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: ElevatedButton.icon(
                onPressed: () => onItemClick('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
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
    return InkWell(
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
    );
  }
}

class _DrawerItem {
  final String title;
  final IconData icon;
  _DrawerItem(this.title, this.icon);
}
