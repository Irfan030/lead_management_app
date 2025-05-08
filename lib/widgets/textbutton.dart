import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final double fontSize;
  final String fontFamily;
  final double letterSpacing;
  final TextAlign textAlign;

  const TextButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = AppColor.textPrimary,
    this.fontSize = 14,
    this.fontFamily = "PoppinsRegular",
    this.letterSpacing = 1.0,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
