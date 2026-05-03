import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karan/app/routes/app_pages.dart';
import 'package:karan/app/services/local_storage_services/local_storage_services.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notifications = true;
  bool _weekStartMonday = true;
  bool _soundEffects = false;
  bool _badgeCount = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // ── Profile Card ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: AppCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryColor, AppColors.accentBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'R',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalStorageService().getUserName().isEmpty
                              ? 'Karan'
                              : LocalStorageService().getUserName(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          LocalStorageService().getEmailId().isEmpty
                              ? 'user@user.com'
                              : LocalStorageService().getEmailId(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Free badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      'FREE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Upgrade to Pro banner
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.9),
                      AppColors.accentBlue,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upgrade to Pro',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Unlock reminders, themes & more',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Display & Layout ─────────────────────────
          _SectionLabel(label: 'Display', isDark: isDark),

          _NavSettingsRow(
            icon: Icons.dashboard_customize_outlined,
            iconColor: AppColors.primaryColor,
            label: 'Display & Layout',
            isDark: isDark,
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const DisplaySettingsSheet(),
            ),
          ),

          _NavSettingsRow(
            icon: Icons.color_lens_outlined,
            iconColor: AppColors.accentBlue,
            label: 'Theme',
            value: isDark ? 'Dark' : 'Light',
            isDark: isDark,
            onTap: () {},
          ),

          _NavSettingsRow(
            icon: Icons.translate_rounded,
            iconColor: AppColors.gold,
            label: 'Language',
            value: 'English',
            isDark: isDark,
            onTap: () {},
          ),

          // ── Notifications ────────────────────────────
          _SectionLabel(label: 'Notifications', isDark: isDark),

          _ToggleSettingsRow(
            icon: Icons.notifications_outlined,
            iconColor: AppColors.primaryColor,
            label: 'Push Notifications',
            isDark: isDark,
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),

          _ToggleSettingsRow(
            icon: Icons.volume_up_outlined,
            iconColor: AppColors.accentBlue,
            label: 'Sound Effects',
            isDark: isDark,
            value: _soundEffects,
            onChanged: (v) => setState(() => _soundEffects = v),
          ),

          _ToggleSettingsRow(
            icon: Icons.notifications_active_outlined,
            iconColor: AppColors.primaryColor,
            label: 'Badge Count',
            isDark: isDark,
            value: _badgeCount,
            onChanged: (v) => setState(() => _badgeCount = v),
          ),

          // ── General ──────────────────────────────────
          _SectionLabel(label: 'General', isDark: isDark),

          _ToggleSettingsRow(
            icon: Icons.calendar_today_outlined,
            iconColor: AppColors.green,
            label: 'Week starts on Monday',
            isDark: isDark,
            value: _weekStartMonday,
            onChanged: (v) => setState(() => _weekStartMonday = v),
          ),

          _NavSettingsRow(
            icon: Icons.manage_accounts_outlined,
            iconColor: AppColors.primaryColor,
            label: 'Google Account',
            value: 'Connected',
            isDark: isDark,
            onTap: () {},
          ),

          _NavSettingsRow(
            icon: Icons.security_outlined,
            iconColor: AppColors.gold,
            label: 'Privacy & Security',
            isDark: isDark,
            onTap: () {},
          ),

          _NavSettingsRow(
            icon: Icons.backup_outlined,
            iconColor: AppColors.accentBlue,
            label: 'Backup & Sync',
            isDark: isDark,
            onTap: () {},
          ),

          // ── Support ──────────────────────────────────
          _SectionLabel(label: 'Support', isDark: isDark),

          _NavSettingsRow(
            icon: Icons.help_outline_rounded,
            iconColor: AppColors.accentBlue,
            label: 'Help & Feedback',
            isDark: isDark,
            onTap: () {},
          ),

          _NavSettingsRow(
            icon: Icons.star_outline_rounded,
            iconColor: AppColors.gold,
            label: 'Rate Taskerer',
            isDark: isDark,
            onTap: () {},
          ),

          _NavSettingsRow(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.textMuted,
            label: 'About',
            value: 'v1.0.0',
            isDark: isDark,
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Sign Out
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: OutlinedButton(
              onPressed: () async {
                await LocalStorageService().logout();
                Get.offAllNamed(Routes.SPLASH);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.2,
                ),
                foregroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
        ),
      ),
    );
  }
}

// ─── Toggle Row ───────────────────────────────────────────────────────────────
class _ToggleSettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSettingsRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.card,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.borderLight,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: const Color(0x061867E9),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryColor,
              trackColor: WidgetStateProperty.resolveWith(
                (s) => s.contains(WidgetState.selected)
                    ? AppColors.primaryColor.withOpacity(0.3)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Nav Row ─────────────────────────────────────────────────────────────────
class _NavSettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? value;
  final bool isDark;
  final VoidCallback onTap;

  const _NavSettingsRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isDark,
    required this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.card,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: const Color(0x061867E9),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (value != null) ...[
                Text(
                  value!,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  DISPLAY SETTINGS SHEET
// ═══════════════════════════════════════════════════
class DisplaySettingsSheet extends StatefulWidget {
  const DisplaySettingsSheet({super.key});

  @override
  State<DisplaySettingsSheet> createState() => _DisplaySettingsSheetState();
}

class _DisplaySettingsSheetState extends State<DisplaySettingsSheet> {
  final _settingsCtrl = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final currentLayout = _settingsCtrl.layout.value;
      final currentShowCompleted = _settingsCtrl.showCompleted.value;

      return Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
            ),
          ),
        ),
        child: Column(
          children: [
            const BottomSheetHandle(),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
              child: Row(
                children: [
                  Text(
                    'Display',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 14,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              height: 1,
            ),

            // Scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Layout ────────────────────────────
                  _SheetSectionLabel(label: 'LAYOUT', isDark: isDark),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _LayoutCard(
                        icon: Icons.view_list_rounded,
                        label: 'List',
                        index: 0,
                        selected: currentLayout,
                        isDark: isDark,
                        onTap: (v) => _settingsCtrl.setLayout(v),
                      ),
                      const SizedBox(width: 8),
                      _LayoutCard(
                        icon: Icons.view_kanban_outlined,
                        label: 'Board',
                        index: 1,
                        selected: currentLayout,
                        isDark: isDark,
                        onTap: (v) => _settingsCtrl.setLayout(v),
                      ),
                      const SizedBox(width: 8),
                      _LayoutCard(
                        icon: Icons.calendar_view_month_rounded,
                        label: 'Calendar',
                        index: 2,
                        selected: currentLayout,
                        isDark: isDark,
                        onTap: (v) => _settingsCtrl.setLayout(v),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Divider(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.borderLight,
                  ),

                  // ── Completed toggle ──────────────────
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 16,
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Completed tasks',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Switch.adaptive(
                        value: currentShowCompleted,
                        onChanged: (v) => _settingsCtrl.setShowCompleted(v),
                        activeColor: AppColors.primaryColor,
                      ),
                    ],
                  ),

                  Divider(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.borderLight,
                  ),

                  // ── Sort ──────────────────────────────
                  _SheetSectionLabel(label: 'SORT', isDark: isDark),
                  const SizedBox(height: 8),

                  _OptionGroup(
                    isDark: isDark,
                    children: [
                      _OptionTile(
                        label: 'Grouping',
                        value: _settingsCtrl.grouping.value,
                        isDark: isDark,
                        onTap: () {},
                      ),
                      _OptionTile(
                        label: 'Sorting',
                        value: _settingsCtrl.sorting.value,
                        isDark: isDark,
                        onTap: () {},
                        showDivider: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Filter ────────────────────────────
                  _SheetSectionLabel(label: 'FILTER', isDark: isDark),
                  const SizedBox(height: 8),

                  _OptionGroup(
                    isDark: isDark,
                    children: [
                      _OptionTile(
                        label: 'Date',
                        value: _settingsCtrl.dateFilter.value,
                        isDark: isDark,
                        onTap: () {},
                      ),
                      _OptionTile(
                        label: 'Priority',
                        value: _settingsCtrl.priorityFilter.value,
                        isDark: isDark,
                        onTap: () {},
                      ),
                      _OptionTile(
                        label: 'Label',
                        value: _settingsCtrl.labelFilter.value,
                        isDark: isDark,
                        onTap: () {},
                        showDivider: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Footer
            Divider(
              color: isDark ? AppColors.darkBorder : AppColors.borderLight,
              height: 1,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => _settingsCtrl.resetDisplaySettings(),
                    child: const Text(
                      'Reset all',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 110,
                    child: GradientButton(
                      label: 'Done',
                      height: 42,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SheetSectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SheetSectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
      ),
    );
  }
}

class _LayoutCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selected;
  final bool isDark;
  final ValueChanged<int> onTap;

  const _LayoutCard({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSel = index == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 74,
          decoration: BoxDecoration(
            color: isSel
                ? AppColors.primaryColor.withOpacity(0.07)
                : (isDark
                      ? AppColors.darkSurfaceElevated
                      : AppColors.cardSecondary),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSel
                  ? AppColors.primaryColor
                  : (isDark ? AppColors.darkBorder : AppColors.borderLight),
              width: isSel ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSel
                    ? AppColors.primaryColor
                    : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSel
                      ? AppColors.primaryColor
                      : (isDark
                            ? AppColors.darkTextMuted
                            : AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 4),
              // Radio dot
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSel
                        ? AppColors.primaryColor
                        : (isDark
                              ? AppColors.darkBorder
                              : AppColors.borderLight),
                    width: 1.5,
                  ),
                  color: isSel ? AppColors.primaryColor : Colors.transparent,
                ),
                child: isSel
                    ? const Icon(
                        Icons.check_rounded,
                        size: 8,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionGroup extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;
  const _OptionGroup({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final VoidCallback onTap;
  final bool showDivider;

  const _OptionTile({
    required this.label,
    required this.value,
    required this.isDark,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: isDark ? AppColors.darkBorder : AppColors.borderLighter,
            height: 1,
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }
}
