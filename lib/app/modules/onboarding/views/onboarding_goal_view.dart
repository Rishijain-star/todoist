import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingGoalView extends GetView<OnboardingController> {
  const OnboardingGoalView({super.key});
  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.goStep(2));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final goals = [
      (
        'Stay on top of my day',
        'Personal tasks, habits & daily priorities sorted.',
        Icons.person_outline_rounded,
      ),
      (
        'Collaborate with a team',
        'Assign, track & finish work together seamlessly.',
        Icons.people_outline_rounded,
      ),
      (
        'Grow my business',
        'Manage clients, deadlines & projects like a pro.',
        Icons.trending_up_rounded,
      ),
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
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
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
                    fontFamily: 'Nunito',
                    color: textColor,
                  ),
                  children: [
                    const TextSpan(text: "What's your\nmain "),
                    TextSpan(
                      text: 'goal?',
                      style: TextStyle(color: AppColors.gold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Pick one — you can always change it later",
                style: TextStyle(
                  fontSize: 15,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Obx(() {
                  final sel = controller.selectedGoal.value;
                  return ListView.separated(
                    itemCount: goals.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (ctx, i) {
                      final g = goals[i];
                      final selected = sel == i;
                      return GestureDetector(
                        onTap: () => controller.selectedGoal.value = i,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryColor.withOpacity(0.1)
                                : (isDark
                                      ? AppColors.darkSurfaceElevated
                                      : AppColors.card),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? AppColors.accentBlue
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : AppColors.borderLight),
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primaryColor
                                      : (isDark
                                            ? AppColors.darkSurface
                                            : AppColors.cardSecondary),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  g.$3,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.accentBlue,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      g.$1,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      g.$2,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.darkTextMuted
                                            : AppColors.textSecondary,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.accentBlue
                                        : (isDark
                                              ? AppColors.darkTextMuted
                                              : AppColors.textMuted),
                                    width: selected ? 6 : 1.5,
                                  ),
                                  color: selected
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.submitGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue →',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
