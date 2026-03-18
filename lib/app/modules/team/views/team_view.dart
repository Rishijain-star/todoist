import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';

// ═══════════════════════════════════════════════════
//  TEAM VIEW  (Browse → Add a team)
// ═══════════════════════════════════════════════════
class TeamView extends StatelessWidget {
  const TeamView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
        ),
        title: Text('Team', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('+ Invite', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w700, fontFamily: 'Nunito')),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Team hero (like home screen but team theme, big icon in middle)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Big team icon (matches "our home screen but big icon in middle" requirement)
                      Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryColor, AppColors.accentBlue],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 28, offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.groups_rounded, color: Colors.white, size: 58),
                      ),
                      const SizedBox(height: 28),
                      Text('Collaborate with your team',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              fontFamily: 'Nunito')),
                      const SizedBox(height: 8),
                      Text('Assign tasks, share projects and finish work together seamlessly.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              fontFamily: 'Nunito')),
                      const SizedBox(height: 32),
                      GradientButton(
                        label: 'Create a Team',
                        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                        onPressed: () => _showCreateTeam(context),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.link_rounded, size: 18,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                          label: Text('Join with invite link',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                  fontFamily: 'Nunito')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Feature chips
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                children: [
                  _FeatureRow(icon: Icons.task_alt_rounded, color: AppColors.green,
                      label: 'Assign tasks to team members'),
                  const SizedBox(height: 12),
                  _FeatureRow(icon: Icons.chat_rounded, color: AppColors.primaryColor,
                      label: 'Real-time comments & conversations'),
                  const SizedBox(height: 12),
                  _FeatureRow(icon: Icons.insights_rounded, color: AppColors.gold,
                      label: 'Team productivity overview'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTeam(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BottomSheetHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
                child: Text('Create a Team', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: ctrl,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Team name',
                    prefixIcon: Icon(Icons.groups_rounded, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GradientButton(
                  label: 'Create Team',
                  height: 46,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/team-workspace');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  const _FeatureRow({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontFamily: 'Nunito')),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════
//  TEAM WORKSPACE VIEW  (after creating team)
// ═══════════════════════════════════════════════════
class TeamWorkspaceView extends StatelessWidget {
  const TeamWorkspaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final members = [
      ('Rohit', 'R', '3 tasks'),
      ('Karan', 'K', '5 tasks'),
      ('Priya', 'P', '2 tasks'),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 26, height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primaryColor, AppColors.accentBlue]),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.groups_rounded, color: Colors.white, size: 14)),
            const SizedBox(width: 8),
            Text('My Team', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
          ],
        ),
        centerTitle: true,
        actions: [
          AppIconButton(icon: Icon(Icons.notifications_none_rounded, size: 17,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary), onTap: () => Get.toNamed(Routes.NOTIFICATIONS)),
          const SizedBox(width: 8),
          AppIconButton(icon: Icon(Icons.person_add_outlined, size: 17,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary), onTap: () {}),
          const SizedBox(width: 8),
          AppIconButton(icon: Icon(Icons.settings_outlined, size: 17,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary), onTap: () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        children: [
          // Overview card
          Padding(
            padding: const EdgeInsets.all(14),
            child: AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Total Tasks', value: '10', color: AppColors.primaryColor)),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(label: 'Completed', value: '4', color: AppColors.green)),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(label: 'Overdue', value: '1', color: AppColors.red)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TaskererProgressBar(value: 0.4),
                  const SizedBox(height: 6),
                  Text('4 of 10 tasks completed',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontFamily: 'Nunito')),
                ],
              ),
            ),
          ),

          // Conversation / Activity section
          SectionHeader(title: 'Conversation', trailing: 'See all', onTrailingTap: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: AppCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _ConvItem(initial: 'R', name: 'Rohit', msg: 'Design review done ✅', time: '2m ago'),
                  const SizedBox(height: 10),
                  _ConvItem(initial: 'K', name: 'Karan', msg: 'API integration is ready', time: '15m ago'),
                  const SizedBox(height: 10),
                  _ConvItem(initial: 'P', name: 'Priya', msg: 'Can someone review PR #42?', time: '1h ago'),
                ],
              ),
            ),
          ),

          // Members
          SectionHeader(title: 'Members', trailing: '+ Invite'),
          ...members.map((m) => Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
            child: AppCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primaryColor, AppColors.accentBlue]),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text(m.$2, style: const TextStyle(color: Colors.white,
                        fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Nunito'))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.$1, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
                        Text(m.$3, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontFamily: 'Nunito')),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                ],
              ),
            ),
          )),
          const SizedBox(height: 100),
        ],
      ),
      floatingActionButton: GradientFAB(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color, fontFamily: 'Nunito')),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontFamily: 'Nunito'),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ConvItem extends StatelessWidget {
  final String initial;
  final String name;
  final String msg;
  final String time;
  const _ConvItem({required this.initial, required this.name, required this.msg, required this.time});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primaryColor, AppColors.accentBlue]),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(initial, style: const TextStyle(color: Colors.white,
                fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Nunito')))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
              Text(msg, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontFamily: 'Nunito'),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Text(time, style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontFamily: 'Nunito')),
      ],
    );
  }
}


// ─── Activity Log View ────────────────────────────────────────────────────────
class ActivityLogView extends StatelessWidget {
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activities = [
      _Act(initial: 'R', type: 'completed', text: 'You completed a task: ', bold: 'Rohit', time: '9:41', project: 'Inbox'),
      _Act(initial: 'R', type: 'comment',   text: 'You added a comment to: ', bold: 'Rohit', time: '9:41', project: 'Inbox'),
      _Act(initial: 'R', type: 'added',     text: 'You added a task: ', bold: 'Call dentist', time: '9:26', project: 'Inbox'),
      _Act(initial: 'R', type: 'deleted',   text: 'You deleted a task: ', bold: 'Meeting notes', time: '9:26', project: 'Inbox'),
      _Act(initial: 'R', type: 'completed', text: 'You completed a task: ', bold: 'Team standup', time: '8:30', project: 'Inbox'),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
        ),
        title: Text('Activity Log', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Row(children: [
              Text('Mar 9 ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
              Text('· ', style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontSize: 12)),
              Text('Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor, fontFamily: 'Nunito')),
            ]),
          ),
          ...activities.map((a) => _ActivityRow(act: a)),
        ],
      ),
    );
  }
}

class _Act {
  final String initial, type, text, bold, time, project;
  const _Act({required this.initial, required this.type, required this.text,
      required this.bold, required this.time, required this.project});
}

class _ActivityRow extends StatelessWidget {
  final _Act act;
  const _ActivityRow({super.key, required this.act});

  Color get _badgeColor {
    switch (act.type) {
      case 'completed': return AppColors.green;
      case 'deleted':   return AppColors.red;
      case 'added':     return AppColors.gold;
      case 'comment':   return AppColors.primaryColor;
      default:          return AppColors.textMuted;
    }
  }

  IconData get _badgeIcon {
    switch (act.type) {
      case 'completed': return Icons.check_rounded;
      case 'deleted':   return Icons.remove_rounded;
      case 'added':     return Icons.add_rounded;
      case 'comment':   return Icons.chat_bubble_rounded;
      default:          return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                ),
                child: Center(child: Text(act.initial, style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w700, color: AppColors.primaryColor, fontFamily: 'Nunito'))),
              ),
              Positioned(
                bottom: -2, right: -3,
                child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: _badgeColor, shape: BoxShape.circle,
                    border: Border.all(color: isDark ? AppColors.darkBackground : AppColors.backgroundLight, width: 2),
                  ),
                  child: Center(child: Icon(_badgeIcon, size: 8, color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, height: 1.4, fontFamily: 'Nunito',
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                    children: [
                      TextSpan(text: act.text),
                      TextSpan(text: act.bold, style: TextStyle(fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(act.time, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontFamily: 'Nunito')),
                    const SizedBox(width: 8),
                    Icon(Icons.inbox_rounded, size: 10, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text(act.project, style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontFamily: 'Nunito')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
