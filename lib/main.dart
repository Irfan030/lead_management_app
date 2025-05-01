import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leads_management_app/route/app_routes.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the status bar color and brightness
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Change to your preferred color
      statusBarIconBrightness:
          Brightness.light, // For white icons on a dark bar
      statusBarBrightness: Brightness.dark, // iOS specific
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MaterialApp(
      title: 'Lead Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: RoutePath.dashboard,
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
