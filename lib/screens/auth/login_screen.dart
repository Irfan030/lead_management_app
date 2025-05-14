import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leads_management_app/Repository/AuthRepository.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/screens/auth/sharedPreference.dart';
import 'package:leads_management_app/screens/auth/splash_screen.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/loader.dart';

import '../../route/route_path.dart';
import '../../theme/size_config.dart';
import '../../widgets/default_text_input.dart';
import '../../widgets/text_button.dart';
import '../../widgets/title_widget.dart';

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
  String email = "admin", password = "admin";
  bool loader = false;
  Authrepository authrepository = Authrepository();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = email;
    _passwordController.text = password;
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    var response;
    try {
      var params = {
        "email": email,
        "password": password,
        "db": AppData.dbName,
      };
      response = await authrepository.login(params);
      if (response["statusCode"] == 200 &&
          response['body']["Status"] == "auth successful") {
        await SharedPreference.addStringToSF(
            AppData.session, response['body']['api-key'] ?? '');
        await SharedPreference.addStringToSF(
            AppData.userDetials, jsonEncode(response['body']));
        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutePath.dashboard);
        }
      } else {
        AppData.handleHtmlResponse(context, response.toString());
        return;
      }
    } catch (e) {
      if (mounted) {
        AppData.showSnackBar(
          context,
          "Unexpected error: ${e.toString()}",
          backgroundColor: AppColor.errorColor,
        );
        return;
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
                      color: ColorAlphaExtension(AppColor.mainColor)
                          .withAlphaDouble(0.1),
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
                  onChange: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  value: email,
                  validator: true,
                  errorMsg: "Please enter a valid email",
                ),
                const SizedBox(height: 16),
                DefaultTextInput(
                  hint: "Enter your password",
                  label: "Password",
                  obscureText: _obscurePassword,
                  controller: _passwordController,
                  onChange: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  value: password,
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
