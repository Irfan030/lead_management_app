import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leads_management_app/widgets/defaultTextInput.dart';
import 'package:leads_management_app/widgets/textbutton.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';
import 'package:leads_management_app/widgets/loader.dart';

class ExampleFormScreen extends StatefulWidget {
  const ExampleFormScreen({super.key});

  @override
  State<ExampleFormScreen> createState() => _ExampleFormScreenState();
}

class _ExampleFormScreenState extends State<ExampleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _name = '';
  String _email = '';
  String _phone = '';

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        // Handle form submission
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleWidget(
          val: "Contact Form",
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TitleWidget(
                val: "Please fill in your details",
                fontSize: 16,
                color: Colors.grey[600]!,
              ),
              const SizedBox(height: 24),
              
              DefaultTextInput(
                hint: "Enter your name",
                label: "Name",
                onChange: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: true,
                errorMsg: "Please enter your name",
              ),
              const SizedBox(height: 16),
              
              DefaultTextInput(
                hint: "Enter your email",
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                onChange: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: true,
                errorMsg: "Please enter a valid email",
              ),
              const SizedBox(height: 16),
              
              DefaultTextInput(
                hint: "Enter your phone number",
                label: "Phone",
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChange: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
                validator: true,
                errorMsg: "Please enter a valid phone number",
              ),
              const SizedBox(height: 24),
              
              _isLoading
                  ? const Center(child: Loader())
                  : TextButtonWidget(
                      text: "Submit",
                      onPressed: _handleSubmit,
                      backgroundColor: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      fontSize: 16,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      borderRadius: 8,
                    ),
            ],
          ),
        ),
      ),
    );
  }
} 