import 'package:flutter/material.dart';
import 'package:leads_management_app/screens/auth/login_screen.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';
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

  void _handleResendOTP() async {
    if (_canResend) {
      setState(() {
        _isLoading = true;
        _canResend = false;
        _resendTimer = 30;
      });

      try {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: TitleWidget(
                val: "OTP resent successfully",
                color: AppColor.whiteColor,
              ),
              backgroundColor: AppColor.successColor,
            ),
          );
          _startResendTimer();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: TitleWidget(
                val: "Failed to resend OTP. Please try again.",
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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
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
          padding: EdgeInsets.all(getProportionateScreenHeight(24)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleWidget(
                  val: "OTP Verification",
                  fontSize: getProportionateScreenHeight(24),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                  color: AppColor.textPrimary,
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                TitleWidget(
                  letterSpacing: 0,
                  val: "Enter the 6-digit code sent to your email",
                  fontSize: getProportionateScreenHeight(16),
                  color: AppColor.textSecondary,
                ),
                SizedBox(height: getProportionateScreenHeight(32)),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: getProportionateScreenHeight(50),
                    fieldWidth: getProportionateScreenHeight(40),
                    activeFillColor: AppColor.whiteColor,
                    activeColor: AppColor.mainColor,
                    selectedColor: AppColor.mainColor,
                    inactiveColor: Colors.grey[300],
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: false,
                  onCompleted: (v) {
                    _handleVerification();
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                  beforeTextPaste: (text) => true,
                ),
                SizedBox(height: getProportionateScreenHeight(32)),
                _isLoading
                    ? const Center(child: Loader())
                    : TextButtonWidget(
                        text: "Verify",
                        onPressed: _handleVerification,
                        backgroundColor: AppColor.mainColor,
                        textColor: AppColor.whiteColor,
                        fontSize: getProportionateScreenHeight(16),
                        padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(16),
                        ),
                        borderRadius: 8,
                      ),
                SizedBox(height: getProportionateScreenHeight(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleWidget(
                      val: "Didn't receive the code?  ",
                      fontSize: getProportionateScreenHeight(14),
                      letterSpacing: 0,
                      color: AppColor.textSecondary,
                    ),
                    TextButtonWidget(
                      letterSpacing: 0,
                      text: _canResend ? "Resend" : "Resend in $_resendTimer s",
                      onPressed: _handleResendOTP,
                      textColor: _canResend ? AppColor.mainColor : Colors.grey,
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
