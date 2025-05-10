import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';
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
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutePath.dashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TitleWidget(
              val: "Login failed. Please try again.",
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: getProportionateScreenHeight(40)),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.mainColor.withAlphaDouble(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.business,
                      size: 60,
                      color: AppColor.mainColor,
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                const TitleWidget(
                  val: "Welcome Back!",
                  fontSize: 24,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
                const SizedBox(height: 8),
                const TitleWidget(
                  val: "Sign in to continue",
                  fontSize: 16,
                  letterSpacing: 0,
                  color: AppColor.textSecondary,
                ),
                SizedBox(height: getProportionateScreenHeight(32)),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButtonWidget(
                    letterSpacing: 0,
                    text: "Forgot Password?",
                    onPressed: () {
                      Navigator.pushNamed(context, RoutePath.forgotPassword);
                    },
                    textColor: AppColor.mainColor,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(24)),
                _isLoading
                    ? const Center(child: Loader())
                    : TextButtonWidget(
                        text: "Login",
                        onPressed: _handleLogin,
                        backgroundColor: AppColor.mainColor,
                        textColor: AppColor.whiteColor,
                        fontSize: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: 8,
                      ),
                SizedBox(height: getProportionateScreenHeight(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TitleWidget(
                      letterSpacing: 0,
                      val: "Don't have an account? ",
                      fontSize: 14,
                      color: AppColor.textSecondary,
                    ),
                    TextButtonWidget(
                      letterSpacing: 0,
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
