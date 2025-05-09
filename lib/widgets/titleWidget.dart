import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';

class TitleWidget extends StatelessWidget {
  final String val;
  final Color color;
  final double fontSize;
  final String fontFamily;
  final double letterSpacing;
  final TextOverflow? overflow;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? height;

  const TitleWidget({
    super.key,
    required this.val,
    this.color = AppColor.textPrimary,
    this.fontSize = 14,
    this.fontFamily = "PoppinsRegular",
    this.letterSpacing = 1.0,
    this.overflow,
    this.textAlign = TextAlign.left,
    this.decoration,
    this.fontWeight,
    this.maxLines,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      val,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        decoration: decoration,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}
