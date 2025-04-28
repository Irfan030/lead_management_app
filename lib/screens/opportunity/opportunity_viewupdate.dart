import 'package:flutter/material.dart';

class OpportunityViewUpdateScreen extends StatelessWidget {
  final Map<String, dynamic> opportunity;

  const OpportunityViewUpdateScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View/Update Opportunity'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${opportunity['name']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Creation Date: ${opportunity['date']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Revenue: \$${opportunity['revenue']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Stage: ${opportunity['stage']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // You can implement Update functionality later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Update functionality not implemented.'),
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
