import 'package:flutter/material.dart';
import 'package:leads_management_app/theme/colors.dart';
import 'package:leads_management_app/theme/sizeConfig.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Don't show default back button
      backgroundColor: AppColor.mainColor,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.cardBackground,
          fontSize: getProportionateScreenWidth(18), // Using your SizeConfig
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: AppColor.cardBackground,
          size: getProportionateScreenWidth(20),
        ),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + getProportionateScreenHeight(0));
}
