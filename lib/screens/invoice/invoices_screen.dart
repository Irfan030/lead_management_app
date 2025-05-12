import 'package:flutter/material.dart';
import 'package:leads_management_app/route/route_path.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/size_config.dart';
import 'package:leads_management_app/widgets/default_drop_down.dart';
import 'package:leads_management_app/widgets/default_text_input.dart';
import 'package:leads_management_app/widgets/loader.dart';
import 'package:leads_management_app/widgets/text_button_with_icon.dart';
import 'package:leads_management_app/widgets/title_widget.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  bool _isLoading = false;
  String _searchText = '';
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'This Month', 'Last Month', 'Custom'];
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allInvoices = [
    {
      'status': 'Posted',
      'number': 'INV/2021/12/0004',
      'customer': 'Deco Addict',
      'amount': 365125.00,
      'date': '2021-12-15',
    },
    {
      'status': 'Posted',
      'number': 'INV/2021/12/0003',
      'customer': 'Deco Addict',
      'amount': 143750.00,
      'date': '2021-12-10',
    },
    {
      'status': 'Posted',
      'number': 'INV/2021/12/0002',
      'customer': 'Deco Addict',
      'amount': 169625.00,
      'date': '2021-12-05',
    },
    {
      'status': 'Posted',
      'number': 'INV/2021/12/0001',
      'customer': 'Azure Interior',
      'amount': 365125.00,
      'date': '2021-12-01',
    },
    {
      'status': 'Posted',
      'number': 'BNK/2021/01/0007',
      'customer': 'Azure Interior',
      'amount': 125000.00,
      'date': '2021-01-15',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInvoices() async {
    setState(() => _isLoading = true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading invoices: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> get _filteredInvoices {
    return _allInvoices.where((invoice) {
      final matchesSearch = invoice['number']
              .toString()
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          invoice['customer']
              .toString()
              .toLowerCase()
              .contains(_searchText.toLowerCase());

      if (!matchesSearch) return false;

      switch (_selectedFilter) {
        case 'This Month':
          final now = DateTime.now();
          final invoiceDate = DateTime.parse(invoice['date']);
          return invoiceDate.year == now.year && invoiceDate.month == now.month;
        case 'Last Month':
          final now = DateTime.now();
          final lastMonth = DateTime(now.year, now.month - 1);
          final invoiceDate = DateTime.parse(invoice['date']);
          return invoiceDate.year == lastMonth.year &&
              invoiceDate.month == lastMonth.month;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: Loader())
          : Column(
              children: [
                _buildSearchAndFilter(),
                Expanded(
                  child: _filteredInvoices.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredInvoices.length,
                          itemBuilder: (context, index) =>
                              _buildInvoiceContainer(_filteredInvoices[index]),
                        ),
                ),
              ],
            ),
      floatingActionButton: TextButtonWithIcon(
        text: 'New Invoice',
        onPressed: () {},
        icon: Icons.add,
        backgroundColor: AppColor.mainColor,
        textColor: Colors.white,
        borderRadius: 12,
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        children: [
          DefaultTextInput(
            controller: _searchController,
            hint: 'Search by invoice number or customer',
            label: 'Search',
            onChange: (value) => setState(() => _searchText = value),
            prefixIcon: const Icon(Icons.search, color: AppColor.mainColor),
          ),
          SizedBox(height: getProportionateScreenHeight(12)),
          DefaultDropDown<String>(
            hint: 'Select Filter',
            label: 'Filter',
            value: _selectedFilter,
            listValues: _filters,
            onChange: (value) => setState(() => _selectedFilter = value),
            getDisplayText: (value) => value,
            getValue: (value) => value,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: getProportionateScreenWidth(64),
            color: Colors.grey[400],
          ),
          SizedBox(height: getProportionateScreenHeight(16)),
          const TitleWidget(
            val: 'No Invoices Found',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          SizedBox(height: getProportionateScreenHeight(8)),
          const TitleWidget(
            val: 'Try adjusting your search or filter',
            fontSize: 14,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceContainer(Map<String, dynamic> invoice) {
    return Card(
      color: AppColor.whiteColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _navigateToInvoiceDetails(invoice),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TitleWidget(
                      val: invoice['number'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStatusBadge(invoice['status']),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              TitleWidget(
                val: invoice['customer'],
                fontSize: 14,
                color: Colors.grey,
              ),
              SizedBox(height: getProportionateScreenHeight(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(
                    val: 'R ${invoice['amount'].toStringAsFixed(2)}',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.mainColor,
                  ),
                  TextButtonWithIcon(
                    text: 'View Details',
                    onPressed: () => _navigateToInvoiceDetails(invoice),
                    icon: Icons.arrow_forward,
                    iconSize: 16,
                    fontSize: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    switch (status.toLowerCase()) {
      case 'posted':
        badgeColor = Colors.green;
        break;
      case 'draft':
        badgeColor = Colors.orange;
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TitleWidget(
        val: status,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: badgeColor,
      ),
    );
  }

  void _navigateToInvoiceDetails(Map<String, dynamic> invoice) {
    Navigator.pushNamed(
      context,
      RoutePath.invoicesDetails,
      arguments: invoice,
    );
  }
}
