import 'package:flutter/material.dart';

import '../models/opportunity.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityCard({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  opportunity.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Badge(
                  backgroundColor: _getBadgeColor(opportunity.stage),
                  child: Text(opportunity.stage),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              opportunity.customer,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${opportunity.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Closes ${_formatDate(opportunity.expectedClose)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor(String stage) {
    switch (stage) {
      case 'New':
        return Colors.blue;
      case 'Qualified':
        return Colors.green;
      case 'Proposal':
        return Colors.orange;
      case 'Negotiation':
        return Colors.purple;
      case 'Won':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays < 0) {
      return '${difference.inDays.abs()} days ago';
    } else if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays < 7) {
      return 'in ${difference.inDays} days';
    } else {
      return 'on ${date.day}/${date.month}/${date.year}';
    }
  }
}
