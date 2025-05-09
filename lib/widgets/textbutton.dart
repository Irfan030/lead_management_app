import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color? backgroundColor;
  final double fontSize;
  final String fontFamily;
  final double letterSpacing;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isDisabled;

  const TextButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = AppColor.textPrimary,
    this.backgroundColor,
    this.fontSize = 14,
    this.fontFamily = "PoppinsRegular",
    this.letterSpacing = 1.0,
    this.textAlign = TextAlign.center,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        padding: padding ?? EdgeInsets.zero,
        minimumSize: Size(width ?? 0, height ?? 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color:
              isDisabled ? textColor.withAlpha((0.5 * 255).round()) : textColor,
          fontSize: fontSize,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
