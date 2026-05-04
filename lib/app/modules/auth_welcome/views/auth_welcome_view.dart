import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/config/dev_auth_config.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/user_assets.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/marketing_shell_layout.dart';
import '../../../routes/app_pages.dart';

class AuthWelcomeView extends StatefulWidget {
  const AuthWelcomeView({super.key});

  @override
  State<AuthWelcomeView> createState() => _AuthWelcomeViewState();
}

class _AuthWelcomeViewState extends State<AuthWelcomeView> {
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;

  void _showEmailOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final iconMuted =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        // Explicit sheet theme so ListTile labels never inherit wrong onSurface (white-on-white).
        return Theme(
          data: Theme.of(context).copyWith(
            listTileTheme: ListTileThemeData(
              iconColor: iconMuted,
              textColor: labelColor,
              titleTextStyle: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.card,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).padding.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BottomSheetHandle(),
                const SizedBox(height: 8),
                _EmailOption(
                  icon: Icons.edit_outlined,
                  label: 'Sign up with Email',
                  labelColor: labelColor,
                  iconColor: iconMuted,
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(Routes.AUTH_EMAIL_SIGNUP);
                  },
                ),
                Divider(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                  height: 1,
                  indent: 18,
                  endIndent: 18,
                ),
                _EmailOption(
                  icon: Icons.mail_outline_rounded,
                  label: 'Log in with Email',
                  labelColor: labelColor,
                  iconColor: iconMuted,
                  onTap: () {
                    Navigator.pop(context);
                    Get.toNamed(Routes.AUTH_EMAIL_LOGIN);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onBg = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
      body: SafeArea(
        child: MarketingShellLayout(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.white,
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Taskerer',
              style: GoogleFonts.inter(
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
                color: AppColors.brandPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            _WelcomeHeadline(
              baseColor: onBg,
              accentColor: AppColors.brandPrimary,
            ),
          ],
        ),
        hero: _TimeManagementHero(isDark: isDark),
        actions: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GradientButton(
              label: 'Continue with Email',
              height: 44,
              icon: const Icon(
                Icons.mail_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => _showEmailOptions(context),
            ),
            SizedBox(height: 12.h),
            SocialButton(
              label: 'Continue with Google',
              icon: _GoogleIcon(),
              isLoading: _isGoogleLoading,
              onPressed: () async {
                // TODO(dev): Replace with real OAuth — see [DevAuthConfig].
                if (DevAuthConfig.shouldBypassAuth) {
                  DevAuthConfig.navigateAfterLoggedIn();
                  return;
                }
                setState(() => _isGoogleLoading = true);
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) setState(() => _isGoogleLoading = false);
              },
            ),
            SizedBox(height: 12.h),
            SocialButton(
              label: 'Continue with Facebook',
              icon: _FacebookIcon(),
              isLoading: _isFacebookLoading,
              onPressed: () async {
                // TODO(dev): Replace with real OAuth — see [DevAuthConfig].
                if (DevAuthConfig.shouldBypassAuth) {
                  DevAuthConfig.navigateAfterLoggedIn();
                  return;
                }
                setState(() => _isFacebookLoading = true);
                await Future.delayed(const Duration(seconds: 2));
                if (mounted) setState(() => _isFacebookLoading = false);
              },
            ),
          ],
        ),
        footer: _WelcomeLegalFooter(isDark: isDark),
      ),
      ),
    );
  }
}

/// Illustration height ~**37%** of screen (reference-style balance), width capped.
class _TimeManagementHero extends StatelessWidget {
  const _TimeManagementHero({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        // ~35–40% of viewport height, stable on tall and short phones
        final targetH = (screenH * 0.375).clamp(240.0, 380.0);
        return Center(
          child: SizedBox(
            width: maxW,
            height: targetH,
            child: Image.asset(
              UserAssets.timeManagementPana,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Two-line headline: original copy + last word larger & brand-colored.
class _WelcomeHeadline extends StatelessWidget {
  const _WelcomeHeadline({
    required this.baseColor,
    required this.accentColor,
  });

  final Color baseColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final baseSize = 25.sp;
    final accentSize = 30.sp;
    final base = GoogleFonts.inter(
      fontSize: baseSize,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.35,
      color: baseColor,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Your plans, tasks, and calendar—\n',
            style: base,
          ),
          TextSpan(
            text: 'connected.',
            style: base.copyWith(
              fontSize: accentSize,
              fontWeight: FontWeight.w800,
              color: accentColor,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.left,
      maxLines: 2,
    );
  }
}

/// Legal line with tappable underlined links (wire URLs when ready).
class _WelcomeLegalFooter extends StatefulWidget {
  const _WelcomeLegalFooter({required this.isDark});

  final bool isDark;

  @override
  State<_WelcomeLegalFooter> createState() => _WelcomeLegalFooterState();
}

class _WelcomeLegalFooterState extends State<_WelcomeLegalFooter> {
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = _openTerms;
    _privacyTap = TapGestureRecognizer()..onTap = _openPrivacy;
  }

  void _openTerms() {
    // TODO: Get.toNamed WebView or url_launcher
  }

  void _openPrivacy() {
    // TODO: same
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final muted = widget.isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final linkColor =
        widget.isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final baseStyle = GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: muted,
    );
    final linkStyle = baseStyle.copyWith(
      color: linkColor,
      decoration: TextDecoration.underline,
      decorationColor: linkColor,
    );

    return Center(
      child: Text.rich(
        TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(
              text:
                  'By continuing with the options above, you agree to Taskerer\'s ',
            ),
            TextSpan(
              text: 'Terms of Service',
              style: linkStyle,
              recognizer: _termsTap,
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: linkStyle,
              recognizer: _privacyTap,
            ),
            const TextSpan(text: '.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _EmailOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color labelColor;
  final Color iconColor;

  const _EmailOption({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.labelColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: labelColor,
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    const colors = [
      Color(0xFF4285F4),
      Color(0xFF34A853),
      Color(0xFFFBBC05),
      Color(0xFFEA4335),
    ];
    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        (i * math.pi * 2 / 4) - math.pi / 4,
        math.pi * 2 / 4,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.22,
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(c.dx, c.dy - r * 0.3, r, r * 0.6),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FacebookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          'f',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
