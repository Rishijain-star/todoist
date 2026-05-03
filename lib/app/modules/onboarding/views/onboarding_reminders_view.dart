import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/user_assets.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingRemindersView extends GetView<OnboardingController> {
  const OnboardingRemindersView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.goStep(3));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final options = [
      (
        'Taskerer · Good morning! ☀️',
        'Hey Karan! You have 5 tasks lined up today. Let\'s crush them! 💪',
        true,
      ),
      ('Morning Kickstart', 'Daily summary to start your morning right', false),
      (
        'Evening Wind-down',
        'Review what\'s left before you call it a day',
        false,
      ),
      ('Smart Task Alerts', 'Nudges when a deadline is coming up', true),
    ];

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: TextButton(
          onPressed: () => controller.back(),
          child: Row(
            children: [
              Icon(
                Icons.chevron_left,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              Text(
                'Back',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        actions: [
          TextButton(
            onPressed: controller.submitReminders,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: AppColors.accentBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        title: Obx(() => TaskererProgressBar(value: controller.progress)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  children: [
                    const TextSpan(text: 'Never miss a\n'),
                    TextSpan(
                      text: 'reminder',
                      style: TextStyle(color: AppColors.gold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Let Taskerer handle the remembering for you',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Notification preview — dark text on light surface (readable on canvas).
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                  ),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            options[0].$1,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            options[0].$2,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Toggle Options
              Expanded(
                child: ListView.separated(
                  itemCount: options.length - 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, i) {
                    final opt = options[i + 1];
                    final icon = i == 0
                        ? Icons.wb_sunny_outlined
                        : (i == 2 ? Icons.calendar_today_outlined : null);
                    return Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.cardSecondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: i == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    UserAssets.navIconToday,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Icon(
                                  icon!,
                                  color: i == 0
                                      ? AppColors.gold
                                      : AppColors.gold,
                                  size: 20,
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opt.$1,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                opt.$2,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: opt.$3,
                          onChanged: (v) {},
                          activeTrackColor: AppColors.primaryColor
                              .withValues(alpha: 0.45),
                          activeThumbColor: AppColors.white,
                          inactiveTrackColor: isDark
                              ? AppColors.darkBorder
                              : AppColors.borderLight,
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'You can update these anytime in Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: controller.submitReminders,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Almost there! Continue →',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }
}
