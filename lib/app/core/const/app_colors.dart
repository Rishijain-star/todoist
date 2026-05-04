import 'package:flutter/material.dart';

/// Taskerer color system: **5 core roles** (see `docs/design_system.md`).
/// Legacy names ([primaryColor], [card], etc.) stay for existing screens; new code
/// may prefer [brandPrimary], [surface], [textMuted], …
class AppColors {
  AppColors._();

  // ── Core palette (5 roles) + legacy primary scale ───
  static const Color primaryColor   = Color(0xFF1867E9);
  /// Brand / CTAs (alias of [primaryColor])
  static const Color brandPrimary   = primaryColor;
  /// App canvas (light) / cards
  static const Color surface = Color(0xFFFFFFFF);
  /// Main text (light)
  static const Color onSurface = Color(0xFF0C1A3A);
  /// Secondary & dividers — borders, de-emphasized text
  static const Color onSurfaceVariant = Color(0xFFA0AABF);

  // ── Primary tints (legacy) ──────────────────────────
  static const Color primaryMid     = Color(0xFF1B51A6);
  static const Color primaryDark    = Color(0xFF032B91);
  static const Color primaryDarkest = Color(0xFF0C2462);
  static const Color accentBlue     = Color(0xFF2A9FFB);
  /// Same as [accentBlue] — use in new code for clarity
  static const Color brandAccent    = accentBlue;
  static const Color primaryPale    = Color(0xFF54A4E8);
  static const Color primarySoftest = Color(0xFFA9D9F2);

  // ── Accent ──────────────────────────────────────────
  static const Color gold  = Color(0xFFF9A800);
  static const Color red   = Color(0xFFF13427);
  static const Color green = Color(0xFF43A047);
  static const Color white = Color(0xFFFFFFFF);
  /// Theme [ColorScheme.error]
  static const Color semanticError = red;

  // ── Light Theme ─────────────────────────────────────
  /// Global light canvas — soft white (not pure #FFFFFF); cards/sheets use [surface]/[card].
  static const Color canvasBackground    = Color(0xFFF7F8FA);
  static const Color backgroundLight     = canvasBackground;
  static const Color pageBackground      = Color(0xFFDDE4F0);
  static const Color card                = Color(0xFFFFFFFF);
  static const Color cardSecondary       = Color(0xFFF0F5FF);
  static const Color inputFieldBg        = Color(0xFFF7F9FC);
  static const Color borderLight         = Color(0xFFE2E8F4);
  /// Default borders / outlines (alias for [borderLight])
  static const Color borderDefault       = borderLight;
  static const Color borderLighter       = Color(0xFFEEF2FA);
  static const Color textPrimary         = Color(0xFF0C1A3A);
  static const Color textSecondary       = Color(0xFF64748B);
  static const Color textMuted           = Color(0xFFA0AABF);

  // ── Dark Theme ──────────────────────────────────────
  static const Color darkBackground      = Color(0xFF080D1A);
  static const Color darkSurface         = Color(0xFF0E1525);
  static const Color darkSurfaceElevated = Color(0xFF131D33);
  static const Color darkBorder          = Color(0xFF151C32);
  static const Color darkBorderLight     = Color(0xFF1A2340);
  static const Color darkTextPrimary     = Color(0xFFE6EAF2);
  static const Color darkTextSecondary   = Color(0xFFD0D7E5);
  static const Color darkTextMuted       = Color(0xFF5A6480);

  // ── Gradients ───────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, accentBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [primaryColor, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
