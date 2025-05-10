import 'package:flutter/material.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/screens/attendance/attendance_history_screen.dart';
import 'package:leads_management_app/screens/attendance/attendance_screen.dart';
import 'package:leads_management_app/screens/auth/forgot_password_screen.dart';
import 'package:leads_management_app/screens/auth/login_screen.dart';
import 'package:leads_management_app/screens/auth/otp_verification_screen.dart';
import 'package:leads_management_app/screens/auth/signup_screen.dart';
import 'package:leads_management_app/screens/auth/splash_screen.dart';
import 'package:leads_management_app/screens/dashboard.dart';
import 'package:leads_management_app/screens/invoice/invoices_screen.dart';
import 'package:leads_management_app/screens/lead/lead_screen.dart';
import 'package:leads_management_app/screens/maps/map_screens.dart';
import 'package:leads_management_app/screens/quotation/quotation_order_screen.dart';
import 'package:leads_management_app/screens/report/reports_screen.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePath.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RoutePath.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case RoutePath.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RoutePath.otpVerification:
        return MaterialPageRoute(builder: (_) => const OtpVerificationScreen());
      case RoutePath.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case RoutePath.lead:
        return MaterialPageRoute(builder: (_) => const LeadListScreen());
      case RoutePath.quotation:
        return MaterialPageRoute(builder: (_) => const QuotationOrderScreen());
      case RoutePath.invoices:
        return MaterialPageRoute(builder: (_) => const InvoicesScreen());
      case RoutePath.reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case RoutePath.attendance:
        return MaterialPageRoute(
          builder: (_) => const AttendanceScreen(),
        );

      case RoutePath.attendanceHistory:
        return MaterialPageRoute(
          builder: (_) => const AttendanceHistoryScreen(),
        );

      case RoutePath.map:
        return MaterialPageRoute(
          builder: (_) => const MapScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
