import 'package:flutter/material.dart';
import 'package:leads_management_app/models/quotation.dart';
import 'package:leads_management_app/providers/quotation_provider.dart';
import 'package:leads_management_app/screens/quotation/create_quotation.dart';
import 'package:leads_management_app/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class QuotationDetailsScreen extends StatelessWidget {
  final Quotation quotation;

  const QuotationDetailsScreen({Key? key, required this.quotation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Quotation Details'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Center(
            child: SizedBox(
              width: isWide ? 600 : double.infinity,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Header Section
                  _buildHeaderSection(),
                  const SizedBox(height: 20),

                  // Customer Information
                  _buildCustomerSection(),
                  const SizedBox(height: 20),

                  // Product Lines
                  _buildProductLinesSection(),
                  const SizedBox(height: 20),

                  // Totals
                  _buildTotalsSection(),
                  const SizedBox(height: 20),

                  // Notes and Terms
                  _buildNotesAndTermsSection(),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                quotation.number,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(quotation.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  quotation.status,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow("Date", quotation.date.toString().split(' ')[0]),
          _buildInfoRow(
              "Valid Until", quotation.validUntil.toString().split(' ')[0]),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customer Information",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          if (quotation.lead != null) ...[
            _buildInfoRow("Customer", quotation.lead!.name),
            _buildInfoRow("Email", quotation.lead!.email_from),
            _buildInfoRow("Phone", quotation.lead!.phone),
          ],
          if (quotation.opportunity != null) ...[
            _buildInfoRow("Opportunity", quotation.opportunity!.name),
            _buildInfoRow("Expected Revenue",
                "R ${quotation.opportunity!.expectedRevenue}"),
          ],
        ],
      ),
    );
  }

  Widget _buildProductLinesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Product Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          ...quotation.lines.map((line) => _buildProductLine(line)).toList(),
        ],
      ),
    );
  }

  Widget _buildProductLine(QuotationLine line) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.productName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(line.description),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Qty: ${line.quantity}"),
              Text("Unit Price: R ${line.unitPrice}"),
              Text("Tax: ${line.taxRate}%"),
              Text("Subtotal: R ${line.subtotal.toStringAsFixed(2)}"),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildTotalsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          _buildTotalRow("Subtotal",
              "R ${(quotation.totalAmount - quotation.totalTax).toStringAsFixed(2)}"),
          _buildTotalRow("Tax", "R ${quotation.totalTax.toStringAsFixed(2)}"),
          const Divider(),
          _buildTotalRow(
              "Total", "R ${quotation.totalAmount.toStringAsFixed(2)}",
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildNotesAndTermsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Notes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(quotation.notes),
          const SizedBox(height: 16),
          const Text(
            "Terms and Conditions",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(quotation.termsAndConditions),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateQuotationScreen(
                      quotation: quotation,
                    ),
                  ),
                );
                if (updated != null && updated is Quotation) {
                  await context
                      .read<QuotationProvider>()
                      .updateQuotation(updated);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Quotation'),
                    content: const Text(
                        'Are you sure you want to delete this quotation?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await context
                      .read<QuotationProvider>()
                      .deleteQuotation(quotation.id);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                // TODO: Generate PDF and share
                await Share.share(
                    'Quotation: ${quotation.number}\nTotal: ₹${quotation.totalAmount.toStringAsFixed(2)}');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.grey;
      case 'sent':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'expired':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
