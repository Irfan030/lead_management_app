// import 'package:flutter/material.dart';
// import 'package:leads_management_app/models/customer_model.dart';
// import 'package:leads_management_app/screens/customer/customer_form.dart';
//
// class CustomerDetailScreen extends StatelessWidget {
//   final Customer customer;
//
//   const CustomerDetailScreen({super.key, required this.customer});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Customer'),
//         backgroundColor: Colors.blue[900],
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () async {
//               final updatedCustomer = await Navigator.push<Customer>(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CustomerFormScreen(customer: customer),
//                 ),
//               );
//
//               if (updatedCustomer != null) {
//                 Navigator.pop(context, updatedCustomer);
//               }
//             },
//           ),
//           IconButton(icon: const Icon(Icons.star), onPressed: () {}),
//           IconButton(icon: const Icon(Icons.receipt_long), onPressed: () {}),
//           IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
//           IconButton(icon: const Icon(Icons.contacts), onPressed: () {}),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: customer.imageUrl != null
//                       ? AssetImage(customer.imageUrl!)
//                       : null,
//                   child: customer.imageUrl == null
//                       ? const Icon(Icons.person, size: 50)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Radio(
//                     value: 'individual',
//                     groupValue: 'individual',
//                     onChanged: (value) {},
//                   ),
//                   const Text('Individual'),
//                   const SizedBox(width: 20),
//                   Radio(
//                     value: 'company',
//                     groupValue: 'individual',
//                     onChanged: (value) {},
//                   ),
//                   const Text('Company'),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 customer.companyName ?? 'Deco Addict',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               buildDetailField('Name', customer.name),
//               buildDetailField('Email', customer.email ?? 'Not Provided'),
//               buildDetailField('Phone', customer.phone),
//               buildDetailField('Mobile', customer.phone ?? ''),
//               buildDetailField('Address', customer.address),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildDetailField(String title, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 8),
//         Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//         const SizedBox(height: 4),
//         TextField(
//           enabled: false,
//           decoration: InputDecoration(
//             hintText: value,
//             border: const UnderlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:leads_management_app/models/customer_model.dart';

import 'customer_form.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  String selectedType = 'individual'; // Default selection

  @override
  void initState() {
    super.initState();
    // Set default from customer
    if (widget.customer.companyName == true) {
      selectedType = 'company';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Customer'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue[900],
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildIconButton(Icons.edit, 'Edit', () async {
                    final updatedCustomer = await Navigator.push<Customer>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CustomerFormScreen(customer: widget.customer),
                      ),
                    );

                    if (updatedCustomer != null) {
                      Navigator.pop(context, updatedCustomer);
                    }
                  }),
                  buildIconButton(Icons.star, 'Opportunity', () {
                    // Navigate to Opportunity Screen
                  }),
                  buildIconButton(Icons.receipt_long, 'Invoices', () {
                    // Navigate to Invoices Screen
                  }),
                  buildIconButton(Icons.shopping_cart, 'Sales', () {
                    // Navigate to Sales Screen
                  }),
                  buildIconButton(Icons.contacts, 'Contacts', () {
                    // Navigate to Contacts Screen
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: widget.customer.imageUrl != null
                            ? AssetImage(widget.customer.imageUrl!)
                            : null,
                        child: widget.customer.imageUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          activeColor: Colors.blue[900],
                          value: 'individual',
                          groupValue: selectedType,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                        const Text('Individual'),
                        const SizedBox(width: 20),
                        Radio(
                          activeColor: Colors.blue[900],
                          value: 'company',
                          groupValue: selectedType,
                          onChanged: (value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                        const Text('Company'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.customer.companyName ?? 'Deco Addict',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildDetailField('Name', widget.customer.name),
                  buildDetailField(
                    'Email',
                    widget.customer.email ?? 'Not Provided',
                  ),
                  buildDetailField('Phone', widget.customer.phone),
                  buildDetailField('Address', widget.customer.address),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.blue[900], size: 30),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildDetailField(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: value,
            border: const UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
