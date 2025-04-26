import 'package:flutter/material.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/screens/activity_screen.dart';
import 'package:leads_management_app/screens/contact_screen.dart';
import 'package:leads_management_app/screens/customer_screen.dart';
import 'package:leads_management_app/screens/dashboard.dart';
import 'package:leads_management_app/screens/opportunity_screen.dart';
import 'package:leads_management_app/screens/reports_screen.dart';
import 'package:leads_management_app/screens/splash_screen.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePath.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case RoutePath.customer:
        return MaterialPageRoute(builder: (_) => const CustomerScreen());
      case RoutePath.opportunity:
        return MaterialPageRoute(builder: (_) => OpportunityScreen());
      case RoutePath.quotation:
        return MaterialPageRoute(builder: (_) => QuotationScreen());
      case RoutePath.invoices:
        return MaterialPageRoute(builder: (_) => InvoicesScreen());
      case RoutePath.activity:
        return MaterialPageRoute(builder: (_) => ActivityScreen());
      case RoutePath.reports:
        return MaterialPageRoute(builder: (_) => ReportsScreen());
      case RoutePath.contactInfo:
        return MaterialPageRoute(builder: (_) => const ContactScreen());
      default:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
    }
  }
}
