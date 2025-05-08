import 'package:flutter/material.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/screens/dashboard.dart';
import 'package:leads_management_app/screens/invoice/invoices_screen.dart';
import 'package:leads_management_app/screens/lead/lead_screen.dart';
import 'package:leads_management_app/screens/quotation/quotation_order_screen.dart';
import 'package:leads_management_app/screens/report/reports_screen.dart';
import 'package:leads_management_app/screens/attendance/attendance_screen.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case RoutePath.splash:
      //   return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePath.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case RoutePath.lead:
        return MaterialPageRoute(builder: (_) => const LeadListScreen());

      case RoutePath.quotation:
        return MaterialPageRoute(builder: (_) => QuotationOrderScreen());
      case RoutePath.invoices:
        return MaterialPageRoute(builder: (_) => InvoicesScreen());

      case RoutePath.reports:
        return MaterialPageRoute(builder: (_) => ReportsScreen());

      case RoutePath.attendance:
        return MaterialPageRoute(
          builder: (_) => const AttendanceScreen(),
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
