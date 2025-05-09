import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leads_management_app/providers/quotation_provider.dart';
import 'package:leads_management_app/route/app_routes.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';
import 'package:provider/provider.dart';
import 'package:leads_management_app/providers/attendance_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the status bar color and brightness
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColor.mainColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColor.scaffoldBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuotationProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: MaterialApp(
        title: 'Lead Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColor.mainColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.mainColor,
            primary: AppColor.mainColor,
            secondary: AppColor.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.mainColor,
            foregroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColor.mainColor,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: AppColor.scaffoldBackground,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
          ),
          scaffoldBackgroundColor: AppColor.scaffoldBackground,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.mainColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.errorColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        initialRoute: RoutePath.splash,
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}
