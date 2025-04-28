import 'package:flutter/material.dart';

class LogInternalNoteScreen extends StatelessWidget {
  const LogInternalNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Internal Note'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Write your internal note here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Dummy save action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note logged successfully!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
