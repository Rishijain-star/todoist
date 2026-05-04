import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/user_assets.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../routes/app_pages.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingWelcomeView extends GetView<OnboardingController> {
  const OnboardingWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.goStep(0));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() => TaskererProgressBar(value: controller.progress)),
        centerTitle: true,
        actions: [
          Icon(Icons.more_horiz, color: textColor.withValues(alpha: 0.35)),
          SizedBox(width: 16.w),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final heroH = (constraints.maxHeight * 0.34).clamp(180.0, 280.0);
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24.w,
                4.h,
                24.w,
                20.h + bottomInset + 8,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: GoogleFonts.inter(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.5,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Taskerer!',
                      style: GoogleFonts.inter(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: -0.5,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Your smart productivity companion',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Lottie hero (replaces bell / speech bubble)
                    Center(
                      child: SizedBox(
                        height: heroH,
                        width: double.infinity,
                        child: Lottie.asset(
                          UserAssets.onboardingWelcomeLottie,
                          fit: BoxFit.contain,
                          repeat: true,
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Feature card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20.r, 18.r, 20.r, 18.r),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.surface,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.borderLight,
                        ),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TASKERER CAN HELP YOU',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          const _HelpItem(
                            text: 'Organize the everyday chaos',
                            isDone: true,
                          ),
                          SizedBox(height: 10.h),
                          const _HelpItem(
                            text: 'Focus on the right things',
                            isDone: true,
                          ),
                          SizedBox(height: 10.h),
                          const _HelpItem(
                            text: 'Achieve goals & finish projects',
                            isDone: true,
                          ),
                          SizedBox(height: 10.h),
                          const _HelpItem(
                            text: "Now it's your turn! ✨",
                            isDone: false,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    GradientButton(
                      label: 'Get Started',
                      onPressed: () => controller.nextFromWelcome(),
                    ),
                    SizedBox(height: 10.h),
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Get.offAllNamed(Routes.AUTH_WELCOME),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign In',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brandPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String text;
  final bool isDone;

  const _HelpItem({
    required this.text,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Icon(
            isDone ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isDone ? AppColors.brandPrimary : AppColors.textMuted,
            size: 22.r,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: isDone ? FontWeight.w600 : FontWeight.w500,
              height: 1.35,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
