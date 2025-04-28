import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/models/customer_model.dart';
import 'package:leads_management_app/screens/customer/customer_form.dart';
import 'package:leads_management_app/theme/colors.dart';

import 'customer_detail.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  bool _isAscending =
      true; // Track sorting order (true = ascending, false = descending)

  @override
  void initState() {
    super.initState();
    customers = getDummyCustomers();
    filteredCustomers = customers;
  }

  List<Customer> getDummyCustomers() {
    return [
      Customer(
        name: 'Deco Addict, Addison Olson',
        address:
            '77 Santa Barbara Rd, Pleasant Hill, California (US) 94523, United States',
        phone: '1234567890',
        imageUrl: AppData.profile,
      ),
      Customer(
        name: 'Azure Interior',
        address:
            '4557 De Silva St, Fremont, California (US) 94538, United States',
        phone: '9876543210',
        imageUrl: AppData.profile,
      ),
      Customer(
        name: 'Ready Mat, Billy Fox',
        address:
            '7500 W Linne Road, Tracy, California (US) 95304, United States',
        phone: '6677889900',
        imageUrl: AppData.profile,
      ),
      Customer(
        name: 'Azure Interior, Brandon Freeman',
        address:
            '4557 De Silva St, Fremont, California (US) 94538, United States',
        phone: '1122334455',
        imageUrl: AppData.profile,
      ),
      Customer(
        name: 'Azure Interior',
        address:
            '4557 De Silva St, Fremont, California (US) 94538, United States',
        phone: '9876543210',
        imageUrl: AppData.profile,
      ),
      Customer(
        name: 'YourCompany, Chester Reed',
        address:
            '250 Executive Park Blvd, Suite 3300, San Francisco, California (US) 94134, United States',
        phone: '4433221100',
        imageUrl: AppData.profile,
      ),
      Customer(
        name: 'Ready Mat, Billy Fox',
        address:
            '7500 W Linne Road, Tracy, California (US) 95304, United States',
        phone: '6677889900',
        imageUrl: AppData.profile,
      ),
    ];
  }

  void _searchCustomer(String query) {
    setState(() {
      filteredCustomers = customers
          .where(
            (customer) =>
                customer.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColor.scaffoldBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort Customers',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              RadioListTile<bool>(
                title: const Text('Sort A-Z'),
                value: true,
                groupValue: _isAscending, // The current sorting order
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      _isAscending = value;
                    });
                    _sortCustomers(ascending: value);
                    Navigator.pop(context);
                  }
                },
                activeColor: Colors.blue,
                selected: _isAscending, // Track the selected value
                secondary: Icon(
                  Icons.arrow_upward,
                  color: Colors.blue.shade700,
                ),
              ),
              RadioListTile<bool>(
                title: const Text('Sort Z-A'),
                value: false,
                groupValue: _isAscending, // The current sorting order
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      _isAscending = value;
                    });
                    _sortCustomers(ascending: value);
                    Navigator.pop(context);
                  }
                },
                activeColor: Colors.blue,
                selected: !_isAscending, // Track the selected value
                secondary: Icon(
                  Icons.arrow_downward,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sortCustomers({required bool ascending}) {
    setState(() {
      filteredCustomers.sort(
        (a, b) =>
            ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
      );
    });
  }

  void _callCustomer(String phone) {
    print('Calling $phone...');
  }

  void _emailCustomer(String email) {
    print('Sending email to $email...');
  }

  void _createNewCustomer() async {
    final newCustomer = await Navigator.push<Customer>(
      context,
      MaterialPageRoute(builder: (context) => const CustomerFormScreen()),
    );

    if (newCustomer != null) {
      setState(() {
        customers.add(newCustomer);
        filteredCustomers = customers;
      });
    }
  }

  void _openCustomerDetails(Customer customer) async {
    final updatedCustomer = await Navigator.push<Customer>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailScreen(customer: customer),
      ),
    );

    if (updatedCustomer != null) {
      setState(() {
        final index = customers.indexOf(customer);
        customers[index] = updatedCustomer;
        filteredCustomers = customers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled:
                          true, // Important: make sure it's true to show fillColor
                      fillColor: Colors.white, // White background inside
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: _searchCustomer,
                  ),
                ),

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showSortDialog,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return GestureDetector(
                  onTap: () => _openCustomerDetails(customer),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      border: Border.all(color: AppColor.mainColor, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(
                            customer.imageUrl ?? AppData.profile,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                customer.address,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.phone,
                                color: AppColor.iconColor,
                              ),
                              onPressed: () => _callCustomer(customer.phone),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.email,
                                color: AppColor.iconColor,
                              ),
                              onPressed: () =>
                                  _emailCustomer('dummyemail@example.com'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.mainColor,
        onPressed: _createNewCustomer,
        child: const Icon(Icons.add, color: AppColor.iconColor),
      ),
    );
  }
}
