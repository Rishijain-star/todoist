import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';

/// Floating snackbars that stay readable on light/dark backgrounds.
void showAuthSnackBar(
  BuildContext context, {
  required String message,
  bool isError = true,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isError
              ? Colors.white
              : (isDark ? Colors.white : AppColors.textPrimary),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        MediaQuery.viewPaddingOf(context).bottom + 24,
      ),
      backgroundColor: isError
          ? AppColors.red
          : (isDark ? AppColors.darkSurfaceElevated : AppColors.card),
      duration: Duration(seconds: message.length > 80 ? 6 : 4),
    ),
  );
}

bool isValidEmailFormat(String email) {
  final e = email.trim();
  if (e.isEmpty) return false;
  return RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(e);
}
