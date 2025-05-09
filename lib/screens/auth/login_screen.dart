import 'package:flutter/material.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/defaultTextInput.dart';
import 'package:leads_management_app/widgets/loader.dart';
import 'package:leads_management_app/widgets/textbutton.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Test credentials
  static const String testEmail = 'admin@example.com';
  static const String testPassword = 'admin123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutePath.dashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TitleWidget(
              val: "Login failed. Please try again.",
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.business,
                      size: 60,
                      color: AppColor.mainColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Welcome Text
                const TitleWidget(
                  val: "Welcome Back!",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                const SizedBox(height: 8),
                TitleWidget(
                  val: "Sign in to continue",
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
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButtonWidget(
                    text: "Forgot Password?",
                    onPressed: () {
                      Navigator.pushNamed(context, RoutePath.forgotPassword);
                    },
                    textColor: AppColor.mainColor,
                  ),
                ),
                const SizedBox(height: 24),
                // Login Button
                _isLoading
                    ? const Center(child: Loader())
                    : TextButtonWidget(
                        text: "Login",
                        onPressed: _handleLogin,
                        backgroundColor: AppColor.mainColor,
                        textColor: Colors.white,
                        fontSize: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: 8,
                      ),
                const SizedBox(height: 24),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleWidget(
                      val: "Don't have an account? ",
                      fontSize: 14,
                      color: Colors.grey[600]!,
                    ),
                    TextButtonWidget(
                      text: "Sign Up",
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePath.signup);
                      },
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
