import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final AnimationController _rotateCtrl;
  late final AnimationController _exitFadeCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _angle;
  late final Animation<double> _brandOpacity;
  late final Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();
    // Scale-up completes in 200ms; full rotation is longer for a smooth, modern feel.
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _exitFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOutCubic),
    );
    _angle = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotateCtrl, curve: Curves.easeInOutCubic),
    );
    _brandOpacity = CurvedAnimation(
      parent: _rotateCtrl,
      curve: const Interval(0.12, 0.45, curve: Curves.easeOut),
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitFadeCtrl, curve: Curves.easeInOut),
    );

    _rotateCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _exitFadeCtrl.forward();
      }
    });

    _scaleCtrl.forward();
    _rotateCtrl.forward();
    Get.find<SplashController>();
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _rotateCtrl.dispose();
    _exitFadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBackground : AppColors.backgroundLight;
    final titleColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final taglineColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _scaleCtrl,
          _rotateCtrl,
          _exitFadeCtrl,
        ]),
        builder: (context, _) {
          final scale = _scale.value;
          final angle = _angle.value;
          final shellOpacity =
              _exitFadeCtrl.isDismissed ? 1.0 : _exitOpacity.value;

          return Opacity(
            opacity: shellOpacity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: angle,
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/taskerer_logo_small.png',
                        width: 108.r,
                        height: 108.r,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  FadeTransition(
                    opacity: _brandOpacity,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                          letterSpacing: -0.5,
                        ),
                        children: [
                          TextSpan(
                            text: 'Task',
                            style: TextStyle(color: titleColor),
                          ),
                          TextSpan(
                            text: 'er',
                            style: TextStyle(color: AppColors.accentBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  FadeTransition(
                    opacity: _brandOpacity,
                    child: Text(
                      'Plan It. Track It. Finish It.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: taglineColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),
                  FadeTransition(
                    opacity: _brandOpacity,
                    child: const _PulseDots(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PulseDots extends StatefulWidget {
  const _PulseDots();

  @override
  State<_PulseDots> createState() => _PulseDotsState();
}

class _PulseDotsState extends State<_PulseDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final v = ((_c.value - i * 0.2).abs() < 0.3) ? 1.0 : 0.4;
            return Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: v),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
