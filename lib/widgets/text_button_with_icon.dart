import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';

class TextButtonWithIcon extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final double? iconSize;
  final double? fontSize;
  final Color? textColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final bool isLoading;

  const TextButtonWithIcon({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.fontSize,
    this.textColor,
    this.backgroundColor,
    this.borderRadius,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: iconSize ?? getProportionateScreenWidth(18),
              height: iconSize ?? getProportionateScreenWidth(18),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.mainColor,
              ),
            )
          : Icon(
              icon,
              size: iconSize ?? getProportionateScreenWidth(18),
              color: textColor ?? AppColor.mainColor,
            ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? getProportionateScreenWidth(14),
          color: textColor ?? AppColor.mainColor,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
    );
  }
} 