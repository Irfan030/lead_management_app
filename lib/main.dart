import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leads_management_app/providers/quotation_provider.dart';
import 'package:leads_management_app/route/app_routes.dart';
import 'package:leads_management_app/route/routePath.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';
import 'package:provider/provider.dart';

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
      ],
      child: MaterialApp(
        title: 'Lead Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColor.mainColor,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: AppColor.scaffoldBackground,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
          ),
          scaffoldBackgroundColor: AppColor.scaffoldBackground,
        ),
        initialRoute: RoutePath.dashboard,
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}
