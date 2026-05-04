import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../const/app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Inter-based text theme. Semantic roles: display/headline ≈ heading, title ≈ subheading,
  /// body* ≈ body, bodySmall/labelSmall ≈ secondary.
  static TextTheme _interTextTheme({
    required Color onSurface,
    required Color labelSecondary,
    required Color muted,
  }) {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        color: onSurface,
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
      ),
      displayMedium: GoogleFonts.inter(
        color: onSurface,
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
      ),
      displaySmall: GoogleFonts.inter(
        color: onSurface,
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
      ),
      headlineMedium: GoogleFonts.inter(
        color: onSurface,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.inter(
        color: onSurface,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.inter(
        color: onSurface,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(
        color: onSurface,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.inter(
        color: onSurface,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: GoogleFonts.inter(
        color: muted,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.inter(
        color: labelSecondary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.inter(
        color: muted,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.light(
      primary: AppColors.brandPrimary,
      onPrimary: AppColors.white,
      secondary: AppColors.brandAccent,
      onSecondary: AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.semanticError,
      onError: AppColors.white,
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
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: AppColors.borderDefault),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderDefault, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        textStyle: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.brandAccent,
        textStyle: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputFieldBg,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.brandPrimary, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(
        color: AppColors.textMuted,
        fontSize: 14.sp,
      ),
      labelStyle: GoogleFonts.inter(
        color: AppColors.textSecondary,
        fontSize: 14.sp,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      selectedItemColor: AppColors.brandPrimary,
      unselectedItemColor: AppColors.textMuted,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
      ),
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme:
        const DividerThemeData(color: AppColors.borderDefault, thickness: 1, space: 0),
    textTheme: _interTextTheme(
      onSurface: AppColors.textPrimary,
      labelSecondary: AppColors.textSecondary,
      muted: AppColors.textMuted,
    ),
  );

  static ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.brandPrimary,
      onPrimary: AppColors.white,
      secondary: AppColors.brandAccent,
      onSecondary: AppColors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.semanticError,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
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
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.brandPrimary, width: 1.5),
      ),
      hintStyle: GoogleFonts.inter(
        color: AppColors.darkTextMuted,
        fontSize: 14.sp,
      ),
      labelStyle: GoogleFonts.inter(
        color: AppColors.darkTextSecondary,
        fontSize: 14.sp,
      ),
    ),
    dividerTheme:
        const DividerThemeData(color: AppColors.darkBorder, thickness: 1, space: 0),
    textTheme: _interTextTheme(
      onSurface: AppColors.darkTextPrimary,
      labelSecondary: AppColors.darkTextSecondary,
      muted: AppColors.darkTextMuted,
    ),
  );
}
