import 'package:flutter/material.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/defaultTextInput.dart';
import 'package:leads_management_app/widgets/loader.dart';
import 'package:leads_management_app/widgets/textbutton.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutePath.otpVerification);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TitleWidget(
              val: "Failed to send reset link. Please try again.",
              color: Colors.white,
            ),
            backgroundColor: AppColor.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleWidget(
                  val: "Forgot Password",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                const SizedBox(height: 8),
                TitleWidget(
                  val: "Enter your email to reset your password",
                  fontSize: 16,
                  color: Colors.grey[600]!,
                ),
                const SizedBox(height: 32),
                // Email Field
                DefaultTextInput(
                  hint: "Enter your email",
                  label: "Email",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  onChange: (value) {},
                  validator: true,
                  errorMsg: "Please enter a valid email",
                ),
                const SizedBox(height: 32),
                // Reset Password Button
                _isLoading
                    ? const Center(child: Loader())
                    : TextButtonWidget(
                        text: "Send Reset Link",
                        onPressed: _handleResetPassword,
                        backgroundColor: AppColor.mainColor,
                        textColor: Colors.white,
                        fontSize: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: 8,
                      ),
                const SizedBox(height: 24),
                // Back to Login
                Center(
                  child: TextButtonWidget(
                    text: "Back to Login",
                    onPressed: () => Navigator.pop(context),
                    textColor: AppColor.mainColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
