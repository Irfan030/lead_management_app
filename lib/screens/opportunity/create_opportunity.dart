// import 'package:flutter/material.dart';
//
// class CreateOpportunityScreen extends StatefulWidget {
//   final Function(Map<String, dynamic>) onCreate;
//
//   const CreateOpportunityScreen({super.key, required this.onCreate});
//
//   @override
//   State<CreateOpportunityScreen> createState() =>
//       _CreateOpportunityScreenState();
// }
//
// class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
//   final List<String> fakeCustomers = [
//     'Deco Addict',
//     'Ready Mat',
//     'Interior Hub',
//     'Style Studio',
//     'DesignPro Ltd',
//   ];
//
//   String? selectedCustomer;
//
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController opportunityController = TextEditingController();
//   final TextEditingController revenueController = TextEditingController(
//     text: '0',
//   );
//   final TextEditingController probabilityController = TextEditingController(
//     text: '0',
//   );
//   final TextEditingController customerController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController closingDateController = TextEditingController();
//
//   DateTime? selectedDate;
//
//   Future<void> pickDate() async {
//     DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2030),
//     );
//     if (date != null) {
//       setState(() {
//         selectedDate = date;
//         closingDateController.text = "${date.year}-${date.month}-${date.day}";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Opportunity'),
//         backgroundColor: Colors.blue[900],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               buildTextField('Opportunity *', opportunityController),
//               buildTextField(
//                 'Expected Revenue (\$)',
//                 revenueController,
//                 keyboard: TextInputType.number,
//               ),
//               buildTextField(
//                 'Probability (%)',
//                 probabilityController,
//                 keyboard: TextInputType.number,
//               ),
//               DropdownButtonFormField<String>(
//                 value: selectedCustomer,
//                 items: fakeCustomers.map((name) {
//                   return DropdownMenuItem(value: name, child: Text(name));
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedCustomer = value!;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Customer',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               buildTextField(
//                 'Email',
//                 emailController,
//                 keyboard: TextInputType.emailAddress,
//               ),
//               buildTextField(
//                 'Phone',
//                 phoneController,
//                 keyboard: TextInputType.phone,
//               ),
//               buildTextField(
//                 'Expected Closing Date',
//                 closingDateController,
//                 readOnly: true,
//                 onTap: pickDate,
//               ),
//               const SizedBox(height: 20),
//
//               ElevatedButton(
//                 onPressed: () {
//                   widget.onCreate({
//                     'name': opportunityController.text,
//                     'date': closingDateController.text,
//                     'revenue': revenueController.text,
//                     'probability': '${probabilityController.text}%',
//                     'customer': selectedCustomer ?? customerController.text,
//                     'stage': 'New',
//                   });
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[800],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                 ),
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTextField(
//     String label,
//     TextEditingController controller, {
//     bool readOnly = false,
//     VoidCallback? onTap,
//     TextInputType keyboard = TextInputType.text,
//     IconData? suffixIcon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         readOnly: readOnly,
//         onTap: onTap,
//         keyboardType: keyboard,
//         validator: (value) {
//           if (label.contains('*') && (value == null || value.isEmpty)) {
//             return 'This field is required';
//           }
//           return null;
//         },
//         decoration: InputDecoration(
//           labelText: label,
//           suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:leads_management_app/widgets/appbar.dart';

class CreateOpportunityScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onOpportunityCreated;

  const CreateOpportunityScreen({
    super.key,
    required this.onOpportunityCreated,
  });

  @override
  State<CreateOpportunityScreen> createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  String opportunityName = '';
  String expectedRevenue = '';
  String probability = '';
  String customer = '';
  String email = '';
  String phone = '';
  String stage = 'Proposition';
  DateTime? expectedClosingDate;

  List<String> stageOptions = [
    'New',
    'Qualified',
    'Proposition',
    'Won',
    'Lost',
  ];
  List<String> customerSuggestions = [
    'Deco Addict',
    'Ready Mat',
    'Flex Design',
    'Bright Interiors',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Opportunity'),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Opportunity *'),
                onChanged: (val) => opportunityName = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Expected Revenue (\$)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) => expectedRevenue = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Probability (%)'),
                keyboardType: TextInputType.number,
                onChanged: (val) => probability = val,
              ),
              const SizedBox(height: 16),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return customerSuggestions.where(
                    (option) => option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                onSelected: (val) => customer = val,
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Customer',
                        ),
                        onChanged: (val) => customer = val,
                      );
                    },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (val) => email = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                onChanged: (val) => phone = val,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: stage,
                items: stageOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => stage = val);
                  }
                },
                decoration: const InputDecoration(labelText: 'Stage'),
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Expected Closing Date'),
                subtitle: Text(
                  expectedClosingDate != null
                      ? expectedClosingDate.toString().split(' ')[0]
                      : 'Tap to select date',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => expectedClosingDate = picked);
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final newOpportunity = {
                      'name': opportunityName,
                      'date':
                          expectedClosingDate?.toString().split(' ')[0] ?? '',
                      'revenue': expectedRevenue,
                      'probability': '$probability%',
                      'customer': customer,
                      'stage': stage,
                    };

                    widget.onOpportunityCreated(newOpportunity);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
