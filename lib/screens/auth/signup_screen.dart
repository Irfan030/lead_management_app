import 'package:flutter/material.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/defaultTextInput.dart';
import 'package:leads_management_app/widgets/loader.dart';
import 'package:leads_management_app/widgets/textbutton.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
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
              val: "Signup failed. Please try again.",
              color: AppColor.whiteColor,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
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
                const TitleWidget(
                  val: "Create Account",
                  fontSize: 24,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
                const SizedBox(height: 8),
                const TitleWidget(
                  letterSpacing: 0,
                  val: "Sign up to get started",
                  fontSize: 16,
                  color: AppColor.textSecondary,
                ),
                const SizedBox(height: 32),
                // Name Field
                DefaultTextInput(
                  hint: "Enter your name",
                  label: "Name",
                  controller: _nameController,
                  onChange: (value) {},
                  validator: true,
                  errorMsg: "Please enter your name",
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                // Phone Field
                DefaultTextInput(
                  hint: "Enter your phone number",
                  label: "Phone",
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  onChange: (value) {},
                  validator: true,
                  errorMsg: "Please enter a valid phone number",
                ),
                const SizedBox(height: 16),
                // Password Field
                DefaultTextInput(
                  hint: "Enter your password",
                  label: "Password",
                  obscureText: _obscurePassword,
                  controller: _passwordController,
                  onChange: (value) {},
                  validator: true,
                  errorMsg: "Please enter your password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Confirm Password Field
                DefaultTextInput(
                  hint: "Confirm your password",
                  label: "Confirm Password",
                  obscureText: _obscurePassword,
                  controller: _confirmPasswordController,
                  onChange: (value) {},
                  validator: true,
                  errorMsg: "Passwords do not match",
                ),
                const SizedBox(height: 32),
                // Sign Up Button
                _isLoading
                    ? const Center(child: Loader())
                    : TextButtonWidget(
                        text: "Sign Up",
                        letterSpacing: 0,
                        onPressed: _handleSignup,
                        backgroundColor: AppColor.mainColor,
                        textColor: AppColor.whiteColor,
                        fontSize: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: 8,
                      ),
                const SizedBox(height: 24),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TitleWidget(
                      val: "Already have an account?  ",
                      fontSize: 14,
                      letterSpacing: 0,
                      color: AppColor.textSecondary,
                    ),
                    TextButtonWidget(
                      text: "Login",
                      onPressed: () => Navigator.pop(context),
                      textColor: AppColor.mainColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
