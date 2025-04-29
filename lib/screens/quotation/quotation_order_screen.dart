// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:leads_management_app/screens/quotation/quotation_details_screen.dart'
//     show OrderDetailsScreen;
//
// class QuotationOrderScreen extends StatefulWidget {
//   @override
//   State<QuotationOrderScreen> createState() => _QuotationOrderScreenState();
// }
//
// class _QuotationOrderScreenState extends State<QuotationOrderScreen> {
//   final List<Map<String, dynamic>> allOrders = [
//     {
//       'type': 'Quotation',
//       'number': 'SO003',
//       'customer': 'Delta PC',
//       'amount': 377.50,
//     },
//     {
//       'type': 'Sale Order',
//       'number': 'SO004',
//       'customer': 'China Export',
//       'amount': 2240.00,
//     },
//     {
//       'type': 'Quotation',
//       'number': 'SO005',
//       'customer': 'Agrolait',
//       'amount': 405.00,
//     },
//     {
//       'type': 'Sale Order',
//       'number': 'SO006',
//       'customer': 'Think Big Systems',
//       'amount': 750.00,
//     },
//   ];
//
//   String searchText = '';
//   String filterType = 'All';
//   bool sortAsc = true;
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> filteredOrders = allOrders
//         .where(
//           (order) =>
//               (filterType == 'All' || order['type'] == filterType) &&
//               (order['customer'].toLowerCase().contains(
//                     searchText.toLowerCase(),
//                   ) ||
//                   order['number'].toLowerCase().contains(
//                     searchText.toLowerCase(),
//                   )),
//         )
//         .toList();
//
//     filteredOrders.sort(
//       (a, b) => sortAsc
//           ? a['amount'].compareTo(b['amount'])
//           : b['amount'].compareTo(a['amount']),
//     );
//
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildSearchAndFilterBar(),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: filteredOrders.length,
//                 itemBuilder: (context, index) =>
//                     _buildOrderCard(filteredOrders[index]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSearchAndFilterBar() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             onChanged: (value) => setState(() => searchText = value),
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.search),
//               hintText: "Search by customer/order no.",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               contentPadding: EdgeInsets.symmetric(horizontal: 12),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         PopupMenuButton<String>(
//           icon: Icon(Icons.filter_list),
//           onSelected: (value) => setState(() => filterType = value),
//           itemBuilder: (_) => [
//             PopupMenuItem(value: 'All', child: Text('All')),
//             PopupMenuItem(value: 'Quotation', child: Text('Quotation')),
//             PopupMenuItem(value: 'Sale Order', child: Text('Sale Order')),
//           ],
//         ),
//         IconButton(
//           icon: Icon(Icons.sort_by_alpha),
//           onPressed: () => setState(() => sortAsc = !sortAsc),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildOrderCard(Map<String, dynamic> order) {
//     final isQuotation = order['type'] == 'Quotation';
//
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Type Badge
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 color: isQuotation ? Colors.orange : Colors.lightBlue,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 order['type'],
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Info Column
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     order['number'],
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     order['customer'],
//                     style: GoogleFonts.poppins(color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '₹ ${order['amount'].toStringAsFixed(2)}',
//                     style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//             // Action Icons
//             Column(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.add, color: Colors.blue),
//                   onPressed: () => _createActivity(order),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.visibility_outlined, color: Colors.grey),
//                   onPressed: () => _viewDetails(order),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _createActivity(Map<String, dynamic> order) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Create activity for ${order['number']}")),
//     );
//   }
//
//   void _viewDetails(Map<String, dynamic> order) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leads_management_app/screens/quotation/quotation_details_screen.dart';

import 'create_activity.dart';

class QuotationOrderScreen extends StatefulWidget {
  @override
  State<QuotationOrderScreen> createState() => _QuotationOrderScreenState();
}

class _QuotationOrderScreenState extends State<QuotationOrderScreen> {
  final List<Map<String, dynamic>> allOrders = [
    {
      'type': 'Quotation',
      'number': 'SO003',
      'customer': 'Delta PC',
      'amount': 377.50,
    },
    {
      'type': 'Sale Order',
      'number': 'SO004',
      'customer': 'China Export',
      'amount': 2240.00,
    },
    {
      'type': 'Quotation',
      'number': 'SO005',
      'customer': 'Agrolait',
      'amount': 405.00,
    },
    {
      'type': 'Sale Order',
      'number': 'SO006',
      'customer': 'Think Big Systems',
      'amount': 750.00,
    },
  ];

  String searchText = '';
  String filterType = 'All';
  bool sortAsc = true;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredOrders = allOrders
        .where(
          (order) =>
              (filterType == 'All' || order['type'] == filterType) &&
              (order['customer'].toLowerCase().contains(
                    searchText.toLowerCase(),
                  ) ||
                  order['number'].toLowerCase().contains(
                    searchText.toLowerCase(),
                  )),
        )
        .toList();

    filteredOrders.sort(
      (a, b) => sortAsc
          ? a['amount'].compareTo(b['amount'])
          : b['amount'].compareTo(a['amount']),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchAndFilterBar(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _viewDetails(filteredOrders[index]),
                    child: _buildOrderCard(filteredOrders[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) => setState(() => searchText = value),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search by customer/order no.",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          onSelected: (value) => setState(() => filterType = value),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'All', child: Text('All')),
            PopupMenuItem(value: 'Quotation', child: Text('Quotation')),
            PopupMenuItem(value: 'Sale Order', child: Text('Sale Order')),
          ],
        ),
        IconButton(
          icon: Icon(sortAsc ? Icons.arrow_upward : Icons.arrow_downward),
          onPressed: () => setState(() => sortAsc = !sortAsc),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final isQuotation = order['type'] == 'Quotation';

    return Container(
      decoration: BoxDecoration(
        color: isQuotation ? Colors.orange.shade50 : Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isQuotation ? Colors.orange : Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order['type'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['number'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  order['customer'],
                  style: GoogleFonts.poppins(color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹ ${order['amount'].toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          // Action Icons
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () => _createActivity(order),
          ),
        ],
      ),
    );
  }

  void _createActivity(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateActivityScreen(), // placeholder
      ),
    );
  }

  void _viewDetails(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
    );
  }
}
