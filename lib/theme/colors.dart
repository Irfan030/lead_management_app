import 'package:flutter/material.dart' hide Colors;

class AppColor {
  // Primary colors
  static const Color mainColor = Color(0xFF1976D2); // Strong Blue (Primary)
  static const Color secondaryColor = Color(
    0xFF64B5F6,
  ); // Light Blue (Secondary)
  static const Color accentColor = Color(
    0xFF42A5F5,
  ); // Medium Blue (Buttons, Highlights)

  // Backgrounds
  static const Color scaffoldBackground = Color(
    0xFFF5F7FA,
  ); // Light grey-blue background
  static const Color whiteColor = Color(0xFFFFFFFF); // Pure White for cards

  // Text colors
  static const Color textPrimary = Color(
    0xFF212121,
  ); // Dark Grey/Black87 (for main text)
  static const Color textSecondary = Color(
    0xFF757575,
  ); // Grey600 (for subtitles, hints)

  // Border and divider colors
  static const Color dividerColor = Color(0xFFBDBDBD); // Light Grey Divider
  static const Color borderColor = Color(
    0xFFE0E0E0,
  ); // Light Border for fields/cards

  // Icon colors
  static const Color iconColor = Color(0xFF424242); // Dark Grey Icons

  // Other Utility colors
  static const Color errorColor = Color(0xFFE53935); // Red for errors
  static const Color successColor = Color(0xFF43A047); // Green for success
}
