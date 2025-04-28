import 'package:flutter/material.dart';
import 'package:leads_management_app/models/customer_model.dart';
import 'package:leads_management_app/screens/customer/customer_form.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Customer'),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedCustomer = await Navigator.push<Customer>(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerFormScreen(customer: customer),
                ),
              );

              if (updatedCustomer != null) {
                Navigator.pop(context, updatedCustomer);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            customer.imageUrl != null
                ? CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(50),
                      ),
                      child: Image.asset(customer.imageUrl!),
                    ),
                  )
                : const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(height: 16),
            Text(
              customer.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(customer.address),
            const SizedBox(height: 8),
            Text(customer.phone),
          ],
        ),
      ),
    );
  }
}
