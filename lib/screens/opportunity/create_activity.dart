import 'package:flutter/material.dart';

class CreateActivityScreen extends StatelessWidget {
  const CreateActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController activityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Activity'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: activityController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe your new activity...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Dummy save action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Activity created successfully!'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Create Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
