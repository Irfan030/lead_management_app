import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';

class Loader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final Color? backgroundColor;
  final bool isLinear;

  const Loader({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 2.0,
    this.color = AppColor.mainColor,
    this.backgroundColor,
    this.isLinear = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLinear) {
      return LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: backgroundColor,
        minHeight: strokeWidth,
      );
    }
    
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: backgroundColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
