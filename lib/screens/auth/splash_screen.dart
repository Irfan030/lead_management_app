import 'package:flutter/material.dart';
import 'package:leads_management_app/constant.dart';
import 'package:leads_management_app/screens/auth/sharedPreference.dart';
import 'package:leads_management_app/theme/colors.dart';

import '../../route/route_path.dart';
import '../../widgets/title_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );

    _controller!.forward();

    // Future.delayed(const Duration(seconds: 3), () {
    //   if (mounted) {
    //     Navigator.pushReplacementNamed(context, RoutePath.login);
    //   }
    // });
    _checkAuth();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: Center(
        child: FadeTransition(
          opacity: _animation!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.business,
                  size: 80,
                  color: AppColor.mainColor,
                ),
              ),
              const SizedBox(height: 24),
              const TitleWidget(
                val: "Leads Management",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor,
              ),
              const SizedBox(height: 8),
              TitleWidget(
                val: "Manage your leads efficiently",
                fontSize: 16,
                color: ColorAlphaExtension(Colors.white).withAlphaDouble(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    var session = await SharedPreference.getStringValue(AppData.session);
    var userId = await SharedPreference.getStringValue(AppData.userDetials);
    if (session != null &&
        session != "" &&
        session.isNotEmpty &&
        userId != null &&
        userId != "" &&
        userId.isNotEmpty) {
      Navigator.pushReplacementNamed(context, RoutePath.dashboard);
    } else {
      Navigator.pushReplacementNamed(context, RoutePath.login);
    }
  }
}

extension ColorAlphaExtension on Color {
  Color withAlphaDouble(double value) {
    assert(value >= 0.0 && value <= 1.0, 'Alpha must be between 0.0 and 1.0');
    return withAlpha((value * 255).round());
  }
}
