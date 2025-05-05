import 'package:flutter/material.dart';
import 'package:leads_management_app/models/lead_model.dart';
import 'package:leads_management_app/models/opportunity.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/appbar.dart';

import 'create_opportunity.dart';

class OpportunityViewUpdateScreen extends StatelessWidget {
  final Opportunity opportunity;
  final List<Lead> leads;

  const OpportunityViewUpdateScreen(
      {Key? key, required this.opportunity, required this.leads})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: const CustomAppBar(title: 'Opportunity Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: AppColor.cardBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        opportunity.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStageColor(opportunity.stage ?? 'New'),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        opportunity.stage ?? 'New',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _infoRow(Icons.person, 'Lead', opportunity.lead?.name ?? 'N/A'),
                _infoRow(
                    Icons.calendar_today, 'Date', opportunity.date ?? 'N/A'),
                _infoRow(Icons.attach_money, 'Expected Revenue',
                    'R ${opportunity.expectedRevenue.toStringAsFixed(2)}'),
                _infoRow(Icons.percent, 'Probability',
                    opportunity.probability ?? 'N/A'),
                if (opportunity.description != null &&
                    opportunity.description!.isNotEmpty)
                  _infoRow(Icons.description, 'Description',
                      opportunity.description!),
                if (opportunity.notes != null && opportunity.notes!.isNotEmpty)
                  _infoRow(Icons.note, 'Notes', opportunity.notes!),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800]),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateOpportunityScreen(
                                // Pass current values to pre-fill
                                key: Key(opportunity.id),
                              ),
                            ),
                          );
                          if (updated != null && updated is Opportunity) {
                            Navigator.pop(context, updated);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700]),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Opportunity'),
                              content: const Text(
                                  'Are you sure you want to delete this opportunity?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
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
                            Navigator.pop(context, 'delete');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'New':
        return Colors.blue;
      case 'Qualified':
        return Colors.orange;
      case 'Proposal':
      case 'Proposition':
        return Colors.teal;
      case 'Negotiation':
        return Colors.purple;
      case 'Closed Won':
      case 'Won':
        return Colors.green;
      case 'Closed Lost':
      case 'Lost':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
