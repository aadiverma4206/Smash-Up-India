import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkCard,
        primaryColor: AppColors.primary,
        dividerColor: AppColors.darkBorder,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.darkCard,
          error: AppColors.error,
          onSurface: AppColors.textPrimaryDark,
          onPrimary: Colors.white,
          surfaceContainerHighest: AppColors.darkInputBg,
          onSurfaceVariant: AppColors.textSecondaryDark,
        ),
        textTheme: AppTypography.textTheme(AppColors.textPrimaryDark),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkAppBar,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
          actionsIconTheme: IconThemeData(color: AppColors.textPrimaryDark),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.darkBorder, width: 1),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkBorder,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkCard,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          indicatorColor: AppColors.primary,
          dividerColor: AppColors.darkBorder,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: AppColors.primary.withAlpha(80),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimaryDark,
            side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkInputBg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          hintStyle:
              const TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
          labelStyle: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          prefixIconColor: AppColors.textSecondaryDark,
          suffixIconColor: AppColors.textSecondaryDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.darkBorder, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.darkBorder, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.8),
          ),
          errorMaxLines: 3,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.darkCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        useMaterial3: true,
      );

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.lightCard,
        primaryColor: AppColors.primary,
        dividerColor: AppColors.lightBorder,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.lightCard,
          error: AppColors.error,
          onSurface: AppColors.textPrimaryLight,
          onPrimary: Colors.white,
          surfaceContainerHighest: AppColors.lightInputBg,
          onSurfaceVariant: AppColors.textSecondaryLight,
        ),
        textTheme: AppTypography.textTheme(AppColors.textPrimaryLight),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBlueAppBar,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.lightBorder, width: 1),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.lightBorder,
          thickness: 1,
          space: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightCard,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryLight,
          indicatorColor: AppColors.primary,
          dividerColor: AppColors.lightBorder,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: AppColors.primary.withAlpha(80),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimaryLight,
            side: const BorderSide(color: AppColors.lightBorder, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightInputBg,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          hintStyle: const TextStyle(
              color: AppColors.textSecondaryLight, fontSize: 14),
          labelStyle: const TextStyle(
              color: AppColors.textPrimaryLight,
              fontSize: 14,
              fontWeight: FontWeight.w600),
          prefixIconColor: AppColors.textSecondaryLight,
          suffixIconColor: AppColors.textSecondaryLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.lightBorder, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.lightBorder, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error, width: 1.8),
          ),
          errorMaxLines: 3,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.lightCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        useMaterial3: true,
      );
}
