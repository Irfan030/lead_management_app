import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';

import 'invoice_details_screen.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final List<Map<String, dynamic>> allInvoices = [
    {
      'status': 'Posted',
      'number': 'INV/2021/12/0004',
      'customer': 'Deco Addict',
      'amount': 365125.00,
    },
    {
      'status': 'Posted',
      'number': 'INV/2021/12/0003',
      'customer': 'Deco Addict',
      'amount': 143750.00,
    },
    {
      'status': 'Posted',
      'number': 'INV/2021/12/0002',
      'customer': 'Deco Addict',
      'amount': 169625.00,
    },
    {
      'status': 'Posted',
      'number': 'INV/2021/12/0001',
      'customer': 'Azure Interior',
      'amount': 365125.00,
    },
    {
      'status': 'Posted',
      'number': 'BNK/2021/01/0007',
      'customer': 'Azure Interior',
      'amount': 125000.00,
    },
  ];

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredInvoices = allInvoices
        .where(
          (invoice) =>
              invoice['number'].toString().toLowerCase().contains(
                searchText.toLowerCase(),
              ) ||
              invoice['customer'].toString().toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredInvoices.length,
                itemBuilder: (context, index) =>
                    _buildInvoiceContainer(filteredInvoices[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => searchText = value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _buildInvoiceContainer(Map<String, dynamic> invoice) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InvoiceDetailScreen(invoice: invoice),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Posted',
                style: TextStyle(
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
                    invoice['number'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    invoice['customer'],
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R ${invoice['amount'].toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
