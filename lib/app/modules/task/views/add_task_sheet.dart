import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../inbox/views/inbox_view.dart' show Task;

// ═══════════════════════════════════════════════════
//  ADD TASK BOTTOM SHEET
// ═══════════════════════════════════════════════════
class AddTaskSheet extends StatefulWidget {
  final void Function(Task task) onSave;
  const AddTaskSheet({super.key, required this.onSave});
  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _manualTimeCtrl = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _priority = 4;
  bool _hasReminder = false;
  final List<XFile> _attachments = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _manualTimeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _attachments.add(image));
    }
  }

  String get _dateLabel {
    if (_selectedDate == null) return 'Date';
    final now = DateTime.now();
    if (_selectedDate!.day == now.day) return 'Today';
    if (_selectedDate!.day == now.add(const Duration(days: 1)).day) return 'Tomorrow';
    return '${_selectedDate!.day}/${_selectedDate!.month}';
  }

  String get _timeLabel {
    if (_selectedTime == null && _manualTimeCtrl.text.isEmpty) return 'Time';
    if (_manualTimeCtrl.text.isNotEmpty) return _manualTimeCtrl.text;
    final h = _selectedTime!.hour.toString().padLeft(2, '0');
    final m = _selectedTime!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Color get _priorityColor {
    switch (_priority) {
      case 1: return AppColors.red;
      case 2: return AppColors.gold;
      case 3: return AppColors.primaryColor;
      default: return AppColors.textMuted;
    }
  }

  void _openDatePicker() async {
    final date = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _DatePickerSheet(),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _openTimePicker() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
        _manualTimeCtrl.text = time.format(context);
      });
    }
  }

  void _openPriority() async {
    final p = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PrioritySheet(current: _priority),
    );
    if (p != null) setState(() => _priority = p);
  }

  void _openReminder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ReminderSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.borderLight)),
      ),
      padding: EdgeInsets.only(bottom: bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),

          // Title input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: TextField(
              controller: _titleCtrl,
              autofocus: true,
              style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                fontFamily: 'Nunito',
              ),
              decoration: InputDecoration(
                hintText: 'Task name…',
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            child: TextField(
              controller: _descCtrl,
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                fontFamily: 'Nunito',
              ),
              decoration: InputDecoration(
                hintText: 'Description',
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
              ),
            ),
          ),

          if (_attachments.isNotEmpty) ...[
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _attachments.length,
                itemBuilder: (ctx, i) => Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(_attachments[i].path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight, height: 1),

          // Chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                TaskChip(
                  label: _dateLabel,
                  icon: Icons.today_rounded,
                  isActive: _selectedDate != null,
                  onTap: _openDatePicker,
                ),
                const SizedBox(width: 6),
                TaskChip(
                  label: _timeLabel,
                  icon: Icons.access_time_rounded,
                  isActive: _selectedTime != null || _manualTimeCtrl.text.isNotEmpty,
                  onTap: _openTimePicker,
                ),
                const SizedBox(width: 6),
                TaskChip(
                  label: 'P$_priority',
                  icon: Icons.flag_rounded,
                  isActive: _priority != 4,
                  onTap: _openPriority,
                ),
                const SizedBox(width: 6),
                TaskChip(
                  label: _hasReminder ? 'Reminder set' : 'Reminder',
                  icon: Icons.notifications_outlined,
                  isActive: _hasReminder,
                  onTap: _openReminder,
                ),
                const SizedBox(width: 6),
                TaskChip(
                  label: 'Attach',
                  icon: Icons.attach_file_rounded,
                  isActive: _attachments.isNotEmpty,
                  onTap: _pickAttachment,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _manualTimeCtrl,
              style: TextStyle(fontSize: 12, fontFamily: 'Nunito', color: isDark ? Colors.white : Colors.black),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Manual time entry (e.g. 10:00 AM)',
                hintStyle: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                fillColor: isDark ? AppColors.darkSurfaceElevated : AppColors.inputFieldBg,
                filled: true,
              ),
            ),
          ),

          Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight, height: 1),

          // Bottom bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.inbox_rounded, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                const SizedBox(width: 5),
                Text('Inbox ▾',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted, fontFamily: 'Nunito')),
                const Spacer(),
                // Send button
                GestureDetector(
                  onTap: () {
                    if (_titleCtrl.text.trim().isEmpty) return;
                    widget.onSave(Task(
                      title: _titleCtrl.text.trim(),
                      desc: _descCtrl.text.trim(),
                      dueToday: _selectedDate != null,
                      commentCount: 0,
                      priority: _priority,
                    ));
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.primaryColor, AppColors.accentBlue]),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  DATE PICKER SHEET
// ═══════════════════════════════════════════════════
class _DatePickerSheet extends StatefulWidget {
  const _DatePickerSheet();
  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(_focused.year, _focused.month);
    final firstWeekday = DateTime(_focused.year, _focused.month, 1).weekday % 7;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetHandle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
            child: Text('Pick a Date',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
          ),

          // Quick options
          ...[
            ('Today', Icons.today_rounded, AppColors.primaryColor, now),
            ('Tomorrow', Icons.next_week_rounded, AppColors.green, now.add(const Duration(days: 1))),
            ('This weekend', Icons.weekend_rounded, AppColors.gold, _nextWeekend()),
          ].map((e) => _QuickDateRow(label: e.$1 as String, icon: e.$2 as IconData, color: e.$3 as Color,
              onTap: () => Navigator.pop(context, e.$4 as DateTime))),

          Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight, height: 1),

          // Month header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text('${_monthName(_focused.month)} ${_focused.year}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
                const Spacer(),
                _CalArrow(left: true, onTap: () => setState(() =>
                    _focused = DateTime(_focused.year, _focused.month - 1))),
                const SizedBox(width: 4),
                _CalArrow(left: false, onTap: () => setState(() =>
                    _focused = DateTime(_focused.year, _focused.month + 1))),
              ],
            ),
          ),

          // Weekday headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['S','M','T','W','T','F','S'].map((d) => Expanded(
                child: Center(child: Text(d,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                        color: AppColors.textMuted, fontFamily: 'Nunito'))),
              )).toList(),
            ),
          ),
          const SizedBox(height: 4),

          // Calendar grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisExtent: 36),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (_, i) {
                if (i < firstWeekday) return const SizedBox();
                final day = i - firstWeekday + 1;
                final date = DateTime(_focused.year, _focused.month, day);
                final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
                final isSel = _selected?.day == day && _selected?.month == _focused.month;
                return GestureDetector(
                  onTap: () => setState(() => _selected = date),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: (isToday || isSel)
                            ? const LinearGradient(colors: [AppColors.primaryColor, AppColors.accentBlue])
                            : null,
                        color: (!isToday && !isSel) ? Colors.transparent : null,
                      ),
                      child: Center(
                        child: Text('$day',
                            style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600,
                              color: (isToday || isSel) ? Colors.white
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                              fontFamily: 'Nunito',
                            )),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: GradientButton(
              label: 'Save Date',
              height: 46,
              onPressed: _selected == null ? null : () => Navigator.pop(context, _selected),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _nextWeekend() {
    final now = DateTime.now();
    int daysUntilSat = (6 - now.weekday) % 7;
    if (daysUntilSat == 0) daysUntilSat = 7;
    return now.add(Duration(days: daysUntilSat));
  }

  String _monthName(int m) {
    const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return names[m - 1];
  }
}

class _QuickDateRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QuickDateRow({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, size: 18, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _CalArrow extends StatelessWidget {
  final bool left;
  final VoidCallback onTap;
  const _CalArrow({required this.left, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : AppColors.cardSecondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
        ),
        child: Icon(left ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
            size: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  TIME PICKER SHEET
// ═══════════════════════════════════════════════════
class _TimePickerSheet extends StatefulWidget {
  const _TimePickerSheet();
  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  TimeOfDay _time = TimeOfDay.now();

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
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: Text('Pick a Time',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
          ),

          // Clock display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : AppColors.cardSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimeBlock(value: _time.hour, isDark: isDark),
                Text('  :  ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
                _TimeBlock(value: _time.minute, isDark: isDark),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quick options
          ...[
            ('Morning  9:00 AM', const TimeOfDay(hour: 9, minute: 0)),
            ('Afternoon  2:00 PM', const TimeOfDay(hour: 14, minute: 0)),
            ('Evening  7:00 PM', const TimeOfDay(hour: 19, minute: 0)),
          ].map((e) => InkWell(
            onTap: () => setState(() => _time = e.$2 as TimeOfDay),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              child: Row(
                children: [
                  Container(width: 32, height: 32,
                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(9)),
                      child: const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primaryColor)),
                  const SizedBox(width: 12),
                  Text(e.$1 as String,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
                ],
              ),
            ),
          )),

          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GradientButton(
              label: 'Save Time',
              height: 46,
              onPressed: () => Navigator.pop(context, _time),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final int value;
  final bool isDark;
  const _TimeBlock({required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primaryColor, AppColors.accentBlue]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800,
              color: Colors.white, fontFamily: 'Nunito'),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  PRIORITY SHEET
// ═══════════════════════════════════════════════════
class _PrioritySheet extends StatelessWidget {
  final int current;
  const _PrioritySheet({required this.current});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priorities = [
      (1, 'Priority 1', AppColors.red),
      (2, 'Priority 2', AppColors.gold),
      (3, 'Priority 3', AppColors.primaryColor),
      (4, 'Priority 4', AppColors.textMuted),
    ];

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
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
            child: Text('Set Priority',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
          ),
          const SizedBox(height: 8),
          ...priorities.map((p) {
            final isSelected = current == p.$1;
            return InkWell(
              onTap: () => Navigator.pop(context, p.$1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: p.$3.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.flag_rounded, color: p.$3, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Text('${p.$2}',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            fontFamily: 'Nunito')),
                    const Spacer(),
                    Text('P${p.$1}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: p.$3, fontFamily: 'Nunito')),
                    if (isSelected) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.check_rounded, size: 20, color: p.$3),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  REMINDER SHEET
// ═══════════════════════════════════════════════════
class _ReminderSheet extends StatelessWidget {
  const _ReminderSheet();

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
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
            child: Row(
              children: [
                Text('Reminders 🔔',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
              ],
            ),
          ),

          // Upgrade card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.gold.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Text('⭐', textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, height: 2.0)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unlock smart reminders',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                              fontFamily: 'Nunito')),
                      const SizedBox(height: 2),
                      Text('Location-based, recurring & custom reminders in Pro.',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              fontFamily: 'Nunito', height: 1.4)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                        ),
                        child: const Text('UPGRADE TO PRO',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                                color: AppColors.gold, letterSpacing: 0.4)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: isDark ? AppColors.darkBorder : AppColors.borderLight),

          // At time of task
          ListTile(
            leading: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.access_time_filled_rounded, color: AppColors.primaryColor, size: 18),
            ),
            title: Text('At time of task',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary, fontFamily: 'Nunito')),
            trailing: Icon(Icons.chevron_right_rounded, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
            onTap: () {},
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                '→ Add date & time first',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
