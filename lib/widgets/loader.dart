import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: AppColor.mainColor);
  }
}
