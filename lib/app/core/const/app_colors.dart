import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Blue Scale ──────────────────────────────
  static const Color primaryColor   = Color(0xFF1867E9);
  static const Color primaryMid     = Color(0xFF1B51A6);
  static const Color primaryDark    = Color(0xFF032B91);
  static const Color primaryDarkest = Color(0xFF0C2462);
  static const Color accentBlue     = Color(0xFF2A9FFB);
  static const Color primaryPale    = Color(0xFF54A4E8);
  static const Color primarySoftest = Color(0xFFA9D9F2);

  // ── Accent ──────────────────────────────────────────
  static const Color gold  = Color(0xFFF9A800);
  static const Color red   = Color(0xFFF13427);
  static const Color green = Color(0xFF43A047);
  static const Color white = Color(0xFFFFFFFF);

  // ── Light Theme ─────────────────────────────────────
  static const Color backgroundLight     = Color(0xFFF0F4FA);
  static const Color pageBackground      = Color(0xFFDDE4F0);
  static const Color card                = Color(0xFFFFFFFF);
  static const Color cardSecondary       = Color(0xFFF0F5FF);
  static const Color inputFieldBg        = Color(0xFFF7F9FC);
  static const Color borderLight         = Color(0xFFE2E8F4);
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
