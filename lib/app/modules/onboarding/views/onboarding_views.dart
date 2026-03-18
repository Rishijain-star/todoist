import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';

// shared state (in real app use GetX / Riverpod)
String _userName = '';
int _selectedGoal = -1;

// ═══════════════════════════════════════════════════
//  STEP 1 — Welcome
// ═══════════════════════════════════════════════════
class OnboardingWelcomeView extends StatelessWidget {
  const OnboardingWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: TaskererProgressBar(value: 1 / 3),
        centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // ── Icon ─────────────────────────────────────
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.card,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.accentBlue,
                    size: 60,
                  ),
                  Positioned(
                    bottom: 22,
                    right: 22,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            Text(
              'Taskerer can help you',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                fontFamily: 'Nunito',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // ── Check lines ───────────────────────────────
            _CheckLine(text: 'Organize the everyday chaos'),
            _CheckLine(text: 'Focus on the right things'),
            _CheckLine(text: 'Achieve goals & finish projects'),
            _CheckLine(text: 'Collaborate seamlessly with teams'),

            const Spacer(),

            GradientButton(
              label: "Get Started — It's Free",
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.pushNamed(context, '/onboarding-name'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  final String text;
  const _CheckLine({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.accentBlue,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  STEP 2 — Name
// ═══════════════════════════════════════════════════
class OnboardingNameView extends StatefulWidget {
  const OnboardingNameView({super.key});
  @override
  State<OnboardingNameView> createState() => _OnboardingNameViewState();
}

class _OnboardingNameViewState extends State<OnboardingNameView> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        title: TaskererProgressBar(value: 2 / 3),
        titleSpacing: 10,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/onboarding-goal'),
            child: const Text(
              'Skip',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "What's your name?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.gold,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Let's personalize your experience",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 32),

            // Avatar
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.accentBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
            ),

            const SizedBox(height: 28),
            TextField(
              controller: _ctrl,
              autofocus: true,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                fontFamily: 'Nunito',
              ),
              decoration: const InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            GradientButton(
              label: 'Next →',
              onPressed: _ctrl.text.isEmpty
                  ? null
                  : () {
                      _userName = _ctrl.text.trim();
                      Navigator.pushNamed(context, '/onboarding-goal');
                    },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  STEP 3 — Goal
// ═══════════════════════════════════════════════════
class OnboardingGoalView extends StatefulWidget {
  const OnboardingGoalView({super.key});
  @override
  State<OnboardingGoalView> createState() => _OnboardingGoalViewState();
}

class _OnboardingGoalViewState extends State<OnboardingGoalView> {
  int _sel = _selectedGoal;

  final _goals = const [
    _Goal(
      icon: Icons.person_rounded,
      color: AppColors.accentBlue,
      title: 'Stay on top of my day',
      subtitle: 'Personal tasks, habits & daily priorities sorted.',
    ),
    _Goal(
      icon: Icons.groups_rounded,
      color: AppColors.gold,
      title: 'Collaborate with a team',
      subtitle: 'Assign, track & finish work together seamlessly.',
    ),
    _Goal(
      icon: Icons.business_center_rounded,
      color: AppColors.green,
      title: 'Grow my business',
      subtitle: 'Manage clients, deadlines & projects like a pro.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        title: TaskererProgressBar(value: 3 / 3),
        titleSpacing: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "What's your main goal?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.gold,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Pick one — you can always change it later",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 24),

            // Goal cards
            ...List.generate(_goals.length, (i) {
              final g = _goals[i];
              final selected = _sel == i;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  isSelected: selected,
                  selectedBorderColor: AppColors.accentBlue,
                  onTap: () => setState(() => _sel = i),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: g.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(g.icon, color: g.color, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              g.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                                fontFamily: 'Nunito',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              g.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? AppColors.accentBlue
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.borderLight),
                            width: 1.5,
                          ),
                          color: selected
                              ? AppColors.accentBlue
                              : Colors.transparent,
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 12,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),
            GradientButton(
              label: 'Let\'s Go! →',
              onPressed: _sel == -1
                  ? null
                  : () {
                      _selectedGoal = _sel;
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Goal {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _Goal({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}
