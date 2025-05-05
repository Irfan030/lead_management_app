import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leads_management_app/models/quotation.dart';
import 'package:leads_management_app/providers/quotation_provider.dart';
import 'package:leads_management_app/screens/quotation/create_quotation.dart';
import 'package:leads_management_app/screens/quotation/quotation_details_screen.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:provider/provider.dart';

class QuotationOrderScreen extends StatefulWidget {
  const QuotationOrderScreen({Key? key}) : super(key: key);

  @override
  State<QuotationOrderScreen> createState() => _QuotationOrderScreenState();
}

class _QuotationOrderScreenState extends State<QuotationOrderScreen> {
  String searchText = '';
  String filterType = 'All';
  bool sortAsc = true;

  @override
  void initState() {
    super.initState();
    // Load data when screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuotationProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quotationProvider = context.watch<QuotationProvider>();
    final quotations = quotationProvider.quotations;
    final salesOrders = quotationProvider.salesOrders;
    final isLoading = quotationProvider.isLoading;
    final error = quotationProvider.error;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: () => quotationProvider.loadData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    List<dynamic> items = [];
    if (filterType == 'All') {
      items = [...quotations, ...salesOrders];
    } else if (filterType == 'Quotation') {
      items = quotations;
    } else {
      items = salesOrders;
    }

    items = items.where((item) {
      final number =
          item is Quotation ? item.number : (item as SalesOrder).number;
      return number.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    items.sort((a, b) {
      final amountA =
          a is Quotation ? a.totalAmount : (a as SalesOrder).totalAmount;
      final amountB =
          b is Quotation ? b.totalAmount : (b as SalesOrder).totalAmount;
      return sortAsc ? amountA.compareTo(amountB) : amountB.compareTo(amountA);
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.mainColor,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CreateQuotationScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchAndFilterBar(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => _viewDetails(item),
                    child: _buildItemCard(item),
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
              hintText: "Search by number",
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
            PopupMenuItem(value: 'Sales Order', child: Text('Sales Order')),
          ],
        ),
        IconButton(
          icon: Icon(sortAsc ? Icons.arrow_upward : Icons.arrow_downward),
          onPressed: () => setState(() => sortAsc = !sortAsc),
        ),
      ],
    );
  }

  Widget _buildItemCard(dynamic item) {
    final isQuotation = item is Quotation;
    final number = isQuotation ? item.number : (item as SalesOrder).number;
    final status = isQuotation ? item.status : item.status;
    final amount = isQuotation ? item.totalAmount : item.totalAmount;
    final date = isQuotation ? item.date : item.date;

    return Container(
      decoration: BoxDecoration(
        color: isQuotation ? Colors.orange.shade50 : Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isQuotation ? Colors.orange : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isQuotation ? 'Quotation' : 'Sales Order',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Status: $status',
            style: GoogleFonts.poppins(color: Colors.grey[700]),
          ),
          Text(
            'Date: ${date.toString().split(' ')[0]}',
            style: GoogleFonts.poppins(color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            'R ${amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _viewDetails(dynamic item) {
    if (item is Quotation) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuotationDetailsScreen(quotation: item),
        ),
      );
    } else {
      // TODO: Navigate to Sales Order Details Screen
    }
  }
}
