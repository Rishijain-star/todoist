import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../const/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Nunito',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary:    AppColors.primaryColor,
      onPrimary:  AppColors.white,
      secondary:  AppColors.accentBlue,
      onSecondary: AppColors.white,
      background: AppColors.backgroundLight,
      onBackground: AppColors.textPrimary,
      surface:    AppColors.card,
      onSurface:  AppColors.textPrimary,
      error:      AppColors.red,
      onError:    AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLight),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderLight, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentBlue,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14, fontFamily: 'Nunito'),
      labelStyle: const TextStyle(color: AppColors.textSecondary, fontFamily: 'Nunito'),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.card,
      elevation: 0,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textMuted,
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'Nunito'),
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.borderLight, thickness: 1, space: 0),
    textTheme: const TextTheme(
      displayLarge:  TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontFamily: 'Nunito'),
      displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontFamily: 'Nunito'),
      headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      headlineMedium:TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      titleLarge:    TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 20, fontFamily: 'Nunito'),
      titleMedium:   TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Nunito'),
      titleSmall:    TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'Nunito'),
      bodyLarge:     TextStyle(color: AppColors.textPrimary, fontSize: 15, fontFamily: 'Nunito'),
      bodyMedium:    TextStyle(color: AppColors.textSecondary, fontSize: 13.5, fontFamily: 'Nunito'),
      bodySmall:     TextStyle(color: AppColors.textMuted, fontSize: 12, fontFamily: 'Nunito'),
      labelLarge:    TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13, fontFamily: 'Nunito'),
      labelMedium:   TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12, fontFamily: 'Nunito'),
      labelSmall:    TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 10, fontFamily: 'Nunito'),
    ),
  );

  // ─── DARK THEME ───────────────────────────────────────────────────────────
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Nunito',
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary:    AppColors.primaryColor,
      onPrimary:  AppColors.white,
      secondary:  AppColors.accentBlue,
      onSecondary: AppColors.white,
      background: AppColors.darkBackground,
      onBackground: AppColors.darkTextPrimary,
      surface:    AppColors.darkSurface,
      onSurface:  AppColors.darkTextPrimary,
      error:      AppColors.red,
      onError:    AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimary,
        side: const BorderSide(color: AppColors.darkBorder, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentBlue,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceElevated,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.darkTextMuted, fontSize: 14, fontFamily: 'Nunito'),
      labelStyle: const TextStyle(color: AppColors.darkTextSecondary, fontFamily: 'Nunito'),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.darkTextMuted,
      selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'Nunito'),
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.darkBorder, thickness: 1, space: 0),
    textTheme: const TextTheme(
      displayLarge:  TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w800, fontFamily: 'Nunito'),
      displayMedium: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w800, fontFamily: 'Nunito'),
      headlineLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      headlineMedium:TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700, fontFamily: 'Nunito'),
      titleLarge:    TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700, fontSize: 20, fontFamily: 'Nunito'),
      titleMedium:   TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Nunito'),
      titleSmall:    TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'Nunito'),
      bodyLarge:     TextStyle(color: AppColors.darkTextPrimary, fontSize: 15, fontFamily: 'Nunito'),
      bodyMedium:    TextStyle(color: AppColors.darkTextSecondary, fontSize: 13.5, fontFamily: 'Nunito'),
      bodySmall:     TextStyle(color: AppColors.darkTextMuted, fontSize: 12, fontFamily: 'Nunito'),
      labelLarge:    TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w700, fontSize: 13, fontFamily: 'Nunito'),
      labelMedium:   TextStyle(color: AppColors.darkTextSecondary, fontWeight: FontWeight.w600, fontSize: 12, fontFamily: 'Nunito'),
      labelSmall:    TextStyle(color: AppColors.darkTextMuted, fontWeight: FontWeight.w600, fontSize: 10, fontFamily: 'Nunito'),
    ),
  );
}
