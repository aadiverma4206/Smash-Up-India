import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Deep Royal Blue matching Smash Up India Logo)
  static const Color primary = Color(0xFF1D4ED8); // Vibrant Royal Blue
  static const Color primaryDark = Color(0xFF1E40AF); // Deep Royal Blue
  static const Color primaryLight = Color(0xFF3B82F6); // Light Blue Accent
  static const Color secondary = Color(0xFFFFB300); // Gold Accent
  static const Color accent = Color(0xFF2563EB); // Bright Blue Accent
  static const Color vibrantRed = Color(0xFFFF3B30); // Red Accent

  // AppBar & Action Colors (Light Mode & Dark Mode)
  static const Color lightBlueAppBar =
      Color(0xFF01163C); // Updated to match requested deep navy
  static const Color lightBlueBg =
      Color(0xFFE0F2FE); // Soft Light Blue Background
  static const Color lightBlueBorder = Color(0xFF93C5FD); // Light Blue Border
  static const Color darkAppBar =
      Color(0xFF01163C); // Updated to match requested deep navy

  // Neutral Colors - Dark Mode (Deep Pitch Dark Navy Blue - Even darker than reference)
  static const Color darkBackground =
      Color(0xFF040812); // Pitch Dark Navy Background
  static const Color darkCard =
      Color(0xFF0A1424); // Rich Dark Navy Surface Card
  static const Color darkInputBg = Color(0xFF101E32); // Input Field Fill Navy
  static const Color darkBorder = Color(0xFF1A2E4C); // Subtle Navy Border Color

  // Neutral Colors - Light Mode
  static const Color lightBackground = Color(0xFFF8FAFC); // Clean Light Slate
  static const Color lightCard = Color(0xFFFFFFFF); // Pure White Surface
  static const Color lightInputBg = Color(0xFFF1F5F9); // Light Gray Input
  static const Color lightBorder = Color(0xFFE2E8F0); // Subtle Light Border

  // Text Colors - Dark Mode
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Crisp White Slate
  static const Color textSecondaryDark =
      Color(0xFF94A3B8); // Muted Secondary Slate Blue
  static const Color textMutedDark = Color(0xFF64748B); // Muted Dark Text

  // Text Colors - Light Mode
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFB300);

  // Hero Image Overlay Gradient
  static const List<Color> heroGradientDark = [
    Colors.transparent,
    Color(0xCC040812),
    Color(0xFF040812),
  ];

  static const List<Color> heroGradientLight = [
    Colors.transparent,
    Color(0x99F8FAFC),
    Color(0xFFF8FAFC),
  ];
}

extension ThemeContextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get backgroundColor =>
      isDark ? AppColors.darkBackground : AppColors.lightBackground;
  Color get cardColor => isDark ? AppColors.darkCard : AppColors.lightCard;
  Color get inputBgColor =>
      isDark ? AppColors.darkInputBg : AppColors.lightInputBg;
  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;
  Color get textPrimary =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  Color get textSecondary =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get textMuted =>
      isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
}
