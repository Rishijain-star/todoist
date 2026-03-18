import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../inbox/views/inbox_view.dart' show Task;

// ═══════════════════════════════════════════════════
//  TASK DETAIL SHEET
// ═══════════════════════════════════════════════════
class TaskDetailSheet extends StatelessWidget {
  final Task task;
  const TaskDetailSheet({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const BottomSheetHandle(),

          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Row(
              children: [
                Icon(Icons.inbox_rounded, size: 14, color: AppColors.primaryColor),
                const SizedBox(width: 5),
                Text('Inbox', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor, fontFamily: 'Nunito')),
                Icon(Icons.chevron_right_rounded, size: 14, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                const Spacer(),
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => TaskMenuSheet(task: task),
                  ),
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceElevated : AppColors.cardSecondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
                    ),
                    child: Icon(Icons.more_horiz_rounded, size: 16,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight, height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Title row
                Row(
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderLight, width: 1.5),
                      ),
                      child: const Icon(Icons.check_rounded, size: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(width: 10),
                    Text(task.title,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            fontFamily: 'Nunito')),
                  ],
                ),
                const SizedBox(height: 14),

                // Detail rows
                if (task.desc.isNotEmpty)
                  _DetailRow(
                    icon: Icons.notes_rounded,
                    child: Text(task.desc,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            fontFamily: 'Nunito')),
                  ),
                if (task.dueToday)
                  _DetailRow(
                    icon: Icons.today_rounded,
                    iconColor: AppColors.primaryColor,
                    child: Text('Today',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor, fontFamily: 'Nunito')),
                  ),
                _DetailRow(
                  icon: Icons.inbox_rounded,
                  child: Text('Inbox',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontFamily: 'Nunito')),
                ),
                _DetailRow(
                  icon: Icons.flag_rounded,
                  iconColor: task.priority == 1 ? AppColors.red
                      : task.priority == 2 ? AppColors.gold
                      : task.priority == 3 ? AppColors.primaryColor : null,
                  child: Text('Priority ${task.priority}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontFamily: 'Nunito')),
                ),

                const SizedBox(height: 16),
                Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight),

                // Comments section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Text('Comments',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              fontFamily: 'Nunito')),
                      if (task.commentCount > 0) ...[
                        const SizedBox(width: 5),
                        Text('${task.commentCount}',
                            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                                fontFamily: 'Nunito')),
                      ],
                    ],
                  ),
                ),
                if (task.commentCount > 0)
                  _CommentItem(
                    initial: 'R',
                    name: 'Rohit',
                    text: 'Aaj 6 baje tak lana, budget ₹200.',
                  ),
              ],
            ),
          ),

          // Comment input
          Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight, height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(14, 10, 14, MediaQuery.of(context).padding.bottom + 14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceElevated : AppColors.inputFieldBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontFamily: 'Nunito'),
                      decoration: InputDecoration(
                        hintText: 'Add a comment…',
                        hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontSize: 12.5),
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceElevated : AppColors.cardSecondary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
                  ),
                  child: Icon(Icons.attach_file_rounded, size: 14,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Widget child;
  const _DetailRow({required this.icon, this.iconColor, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : AppColors.cardSecondary,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
            ),
            child: Icon(icon, size: 15, color: iconColor ?? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
          ),
          const SizedBox(width: 10),
          child,
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final String initial;
  final String name;
  final String text;
  const _CommentItem({required this.initial, required this.name, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28, height: 28,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.primaryColor, AppColors.accentBlue]),
            shape: BoxShape.circle,
          ),
          child: Center(child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700, fontFamily: 'Nunito'))),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
              const SizedBox(height: 3),
              Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontFamily: 'Nunito', height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════
//  TASK MENU SHEET (3-dots)
// ═══════════════════════════════════════════════════
class TaskMenuSheet extends StatelessWidget {
  final Task task;
  const TaskMenuSheet({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text('Completed on Mar 9 · 9:41 AM',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontFamily: 'Nunito')),
          ),
          Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight, height: 1),
          _MenuItem(icon: Icons.copy_rounded, label: 'Duplicate task', onTap: () => Navigator.pop(context)),
          _MenuItem(icon: Icons.link_rounded, label: 'Copy link to task', onTap: () => Navigator.pop(context)),
          _MenuItem(icon: Icons.visibility_off_outlined, label: 'Hide completed sub-tasks', onTap: () => Navigator.pop(context)),
          _MenuItem(icon: Icons.history_rounded, label: 'Activity log', onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/activity-log');
          }),
          _MenuItem(icon: Icons.email_outlined, label: 'Email to this task', onTap: () => Navigator.pop(context)),
          Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight, height: 8, indent: 16, endIndent: 16),
          _MenuItem(icon: Icons.delete_outline_rounded, label: 'Delete task', isDestructive: true, onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDestructive ? AppColors.red : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);
    final iconBg = isDestructive
        ? AppColors.red.withOpacity(0.07)
        : (isDark ? AppColors.darkSurfaceElevated : AppColors.cardSecondary);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDestructive ? AppColors.red.withOpacity(0.15)
                      : (isDark ? AppColors.darkBorder : AppColors.borderLight),
                ),
              ),
              child: Icon(icon, size: 17, color: isDestructive ? AppColors.red
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
            ),
            const SizedBox(width: 13),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color, fontFamily: 'Nunito')),
          ],
        ),
      ),
    );
  }
}
