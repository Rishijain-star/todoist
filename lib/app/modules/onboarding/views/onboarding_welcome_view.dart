import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingWelcomeView extends GetView<OnboardingController> {
  const OnboardingWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.goStep(0));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Obx(() => TaskererProgressBar(value: controller.progress)),
        centerTitle: true,
        actions: const [
          Icon(Icons.more_horiz, color: Colors.white54),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  fontFamily: 'Nunito',
                ),
              ),
              Text(
                'Taskerer!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentBlue,
                  fontFamily: 'Nunito',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your smart productivity companion',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  fontFamily: 'Nunito',
                ),
              ),
              const SizedBox(height: 40),

              // Bell Illustration
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Speech Bubble
                    Positioned(
                      top: -40,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Hey! Ready to be productive? 👋',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bell Icon
                    Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.notifications_rounded,
                              color: AppColors.primaryColor,
                              size: 120,
                            ),
                            // Eyes
                            Positioned(
                              top: 65,
                              left: 55,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 65,
                              right: 55,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            // Smile
                            Positioned(
                              top: 75,
                              child: Icon(
                                Icons.sentiment_satisfied_alt_rounded,
                                color: Colors.black.withOpacity(0.6),
                                size: 30,
                              ),
                            ),
                            // Badge
                            Positioned(
                              top: 25,
                              right: 25,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Hands
                            Positioned(
                              left: 10,
                              child: Icon(
                                Icons.assignment_turned_in_rounded,
                                color: AppColors.gold.withOpacity(0.8),
                                size: 32,
                              ),
                            ),
                            Positioned(
                              right: 10,
                              child: Icon(
                                Icons.front_hand_rounded,
                                color: AppColors.gold.withOpacity(0.8),
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom Dot
                    Positioned(
                      bottom: -10,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Stars
                    Positioned(
                      top: 10,
                      left: -20,
                      child: Icon(
                        Icons.star_rounded,
                        color: AppColors.gold,
                        size: 16,
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: -40,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.accentBlue,
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Help Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TASKERER CAN HELP YOU',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.textMuted,
                        letterSpacing: 1.2,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _HelpItem(
                      text: 'Organize the everyday chaos',
                      isDone: true,
                      delayMs: 0,
                    ),
                    const SizedBox(height: 12),
                    _HelpItem(
                      text: 'Focus on the right things',
                      isDone: true,
                      delayMs: 220,
                    ),
                    const SizedBox(height: 12),
                    _HelpItem(
                      text: 'Achieve goals & finish projects',
                      isDone: true,
                      delayMs: 440,
                    ),
                    const SizedBox(height: 12),
                    _HelpItem(
                      text: "Now it's your turn! ✨",
                      isDone: false,
                      delayMs: 660,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Get Started Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.nextFromWelcome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: AppColors.primaryColor.withOpacity(0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Get Started – It's Free 🔔",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final String text;
  final bool isDone;
  final int delayMs;

  const _HelpItem({
    required this.text,
    required this.isDone,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedHelpItem(text: text, isDone: isDone, delayMs: delayMs);
  }
}

class _AnimatedHelpItem extends StatefulWidget {
  final String text;
  final bool isDone;
  final int delayMs;

  const _AnimatedHelpItem({
    required this.text,
    required this.isDone,
    required this.delayMs,
  });

  @override
  State<_AnimatedHelpItem> createState() => _AnimatedHelpItemState();
}

class _AnimatedHelpItemState extends State<_AnimatedHelpItem> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isDone) return;
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (!mounted) return;
      setState(() => _checked = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _checked ? AppColors.green : Colors.transparent,
            border: Border.all(
              color: _checked ? AppColors.green : border,
              width: 1.5,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _checked
                ? const Icon(
                    Icons.check,
                    key: ValueKey('check'),
                    color: Colors.white,
                    size: 14,
                  )
                : const SizedBox(key: ValueKey('empty')),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              fontFamily: 'Nunito',
            ),
          ),
        ),
      ],
    );
  }
}
