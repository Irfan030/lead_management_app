import 'package:flutter/material.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/screens/customer/customer_screen.dart';
import 'package:leads_management_app/screens/dashboard.dart';
import 'package:leads_management_app/screens/invoice/invoices_screen.dart';
import 'package:leads_management_app/screens/quotation/quotation_order_screen.dart';
import 'package:leads_management_app/screens/reports_screen.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case RoutePath.splash:
      //   return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePath.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case RoutePath.customer:
        return MaterialPageRoute(builder: (_) => const CustomerListScreen());

      case RoutePath.quotation:
        return MaterialPageRoute(builder: (_) => QuotationOrderScreen());
      case RoutePath.invoices:
        return MaterialPageRoute(builder: (_) => InvoicesScreen());

      case RoutePath.reports:
        return MaterialPageRoute(builder: (_) => ReportsScreen());

      default:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
    }
  }
}
