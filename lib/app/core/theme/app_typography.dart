import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../const/app_colors.dart';

/// Global typography using **Inter**. Prefer these over ad-hoc [TextStyle]s.
///
/// Maps to [ThemeData.textTheme] roles — use [fromContext] for themed colors,
/// or [heading]/[body] etc. with explicit [Color] when needed (e.g. on gradients).
class AppTypography {
  AppTypography._();

  /// Large titles — screen titles, hero headlines.
  static TextStyle heading(Color color, {double fontSize = 28}) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.4,
        color: color,
      );

  /// Section titles, logo-adjacent emphasis.
  static TextStyle subheading(Color color, {double fontSize = 18}) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: -0.2,
        color: color,
      );

  /// Primary reading & UI copy.
  static TextStyle body(Color color, {double fontSize = 15}) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: color,
      );

  /// Captions, legal, meta — low emphasis.
  static TextStyle smallSecondary(Color color, {double fontSize = 12}) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color,
      );

  /// Styles resolved from [Theme] (light/dark aware).
  static AppTypographyContext fromContext(BuildContext context) =>
      AppTypographyContext._(Theme.of(context));
}

/// Typography tied to the current theme’s [TextTheme] and colors.
class AppTypographyContext {
  AppTypographyContext._(this._theme);

  final ThemeData _theme;

  TextStyle get heading =>
      _theme.textTheme.displaySmall ?? AppTypography.heading(_theme.colorScheme.onSurface);

  TextStyle get subheading =>
      _theme.textTheme.titleLarge ?? AppTypography.subheading(_theme.colorScheme.onSurface);

  TextStyle get body =>
      _theme.textTheme.bodyMedium ?? AppTypography.body(_theme.colorScheme.onSurface);

  TextStyle get smallSecondary =>
      _theme.textTheme.bodySmall ??
      AppTypography.smallSecondary(
        _theme.brightness == Brightness.dark
            ? AppColors.darkTextMuted
            : AppColors.textMuted,
      );
}
