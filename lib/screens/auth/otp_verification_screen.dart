import 'package:flutter/material.dart';
import 'package:leads_management_app/screens/auth/login_screen.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/widgets/loader.dart';
import 'package:leads_management_app/widgets/textbutton.dart';
import 'package:leads_management_app/widgets/titleWidget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _currentOTP = '';
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
            _startResendTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  void _handleVerification() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: TitleWidget(
              val: "Invalid OTP. Please try again.",
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

  void _handleResendOTP() async {
    if (_canResend) {
      setState(() {
        _isLoading = true;
        _canResend = false;
        _resendTimer = 30;
      });

      try {
        // TODO: Implement your resend OTP logic here
        await Future.delayed(const Duration(seconds: 2)); // Simulated API call

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TitleWidget(
                val: "OTP resent successfully",
                color: Colors.white,
              ),
              backgroundColor: AppColor.successColor,
            ),
          );
          _startResendTimer();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: TitleWidget(
                val: "Failed to resend OTP. Please try again.",
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
                  val: "OTP Verification",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                const SizedBox(height: 8),
                TitleWidget(
                  val: "Enter the 6-digit code sent to your email",
                  fontSize: 16,
                  color: Colors.grey[600]!,
                ),
                const SizedBox(height: 32),
                // OTP Input Fields
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    activeColor: AppColor.mainColor,
                    selectedColor: AppColor.mainColor,
                    inactiveColor: Colors.grey[300],
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: false,
                  onCompleted: (v) {
                    _currentOTP = v;
                    _handleVerification();
                  },
                  onChanged: (value) {
                    setState(() {
                      _currentOTP = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                ),
                const SizedBox(height: 32),
                // Verify Button
                _isLoading
                    ? const Center(child: Loader())
                    : TextButtonWidget(
                        text: "Verify",
                        onPressed: _handleVerification,
                        backgroundColor: AppColor.mainColor,
                        textColor: Colors.white,
                        fontSize: 16,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: 8,
                      ),
                const SizedBox(height: 24),
                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleWidget(
                      val: "Didn't receive the code? ",
                      fontSize: 14,
                      color: Colors.grey[600]!,
                    ),
                    TextButtonWidget(
                      text: _canResend
                          ? "Resend"
                          : "Resend in $_resendTimer s",
                      onPressed: _handleResendOTP,
                      textColor: _canResend
                          ? AppColor.mainColor
                          : Colors.grey,
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