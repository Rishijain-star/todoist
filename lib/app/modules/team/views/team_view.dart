import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/team_controller.dart';

// ═══════════════════════════════════════════════════
//  TEAM VIEW  (Browse → Add a team)
// ═══════════════════════════════════════════════════
class TeamView extends GetView<TeamController> {
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
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showCreateTeam(context),
            icon: Icon(Icons.add_rounded, color: AppColors.primaryColor),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Team list or Empty state
            Expanded(
              child: Obx(() {
                if (controller.teams.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,)),
                          const SizedBox(height: 8),
                          Text('Assign tasks, share projects and finish work together seamlessly.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,)),
                          const SizedBox(height: 32),
                          GradientButton(
                            label: 'Create a Team',
                            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                            onPressed: () => _showCreateTeam(context),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.teams.length,
                  itemBuilder: (ctx, i) {
                    final team = controller.teams[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        onTap: () => Get.to(() => TeamWorkspaceView(team: team)),
                        child: Row(
                          children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.groups_rounded, color: AppColors.primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(team.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
                                  Text('${team.members.length} members', style: TextStyle(fontSize: 12,
                                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted)),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // Feature chips
            if (controller.teams.isEmpty)
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
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,)),
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
                    if (ctrl.text.isNotEmpty) {
                      controller.createTeam(ctrl.text);
                      Navigator.pop(context);
                    }
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
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════
//  TEAM WORKSPACE VIEW  (after creating team)
// ═══════════════════════════════════════════════════
class TeamWorkspaceView extends GetView<TeamController> {
  final Team team;
  const TeamWorkspaceView({super.key, required this.team});

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
            Text(team.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,)),
          ],
        ),
        centerTitle: true,
        actions: [
          AppIconButton(icon: Icon(Icons.notifications_none_rounded, size: 17,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary), onTap: () => Get.toNamed(Routes.NOTIFICATIONS)),
          const SizedBox(width: 8),
          AppIconButton(icon: Icon(Icons.person_add_outlined, size: 17,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary), onTap: () => _showInviteMember(context)),
          const SizedBox(width: 8),
          AppIconButton(icon: Icon(Icons.settings_outlined, size: 17,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary), onTap: () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: Obx(() {
        final currentTeam = controller.teams.firstWhere((t) => t.id == team.id, orElse: () => team);
        return ListView(
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
                            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,)),
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
            SectionHeader(title: 'Members', trailing: '+ Invite', onTrailingTap: () => _showInviteMember(context)),
            ...currentTeam.members.map((m) => Padding(
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
                      child: Center(child: Text(m[0].toUpperCase(), style: const TextStyle(color: Colors.white,
                          fontSize: 14, fontWeight: FontWeight.w700,))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,)),
                          Text('Member', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,)),
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
        );
      }),
      floatingActionButton: GradientFAB(),
    );
  }

  void _showInviteMember(BuildContext context) {
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
                child: Text('Invite Member', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: ctrl,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GradientButton(
                  label: 'Send Invite',
                  height: 46,
                  onPressed: () {
                    if (ctrl.text.isNotEmpty) {
                      controller.inviteMember(team.id, ctrl.text);
                      Navigator.pop(context);
                    }
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
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color,)),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,),
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
                fontSize: 12, fontWeight: FontWeight.w700,)))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,)),
              Text(msg, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Text(time, style: TextStyle(fontSize: 10.5, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,)),
      ],
    );
  }
}
