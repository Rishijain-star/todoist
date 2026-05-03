import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/task_action_menu_sheet.dart';
import '../../../data/api_repository.dart';
import '../../../data/models/task_model.dart';
import '../../../services/api_progress_service.dart';
import '../../../services/task_service.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../projects/controllers/projects_controller.dart';

class TaskDetailSheet extends StatefulWidget {
  final Task task;
  final Function(Task)? onUpdate;
  const TaskDetailSheet({super.key, required this.task, this.onUpdate});

  @override
  State<TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<TaskDetailSheet> {
  final _commentCtrl = TextEditingController();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  late Rx<Task> _taskRx;
  final InboxController _inboxController = Get.find<InboxController>();
  Timer? _persistDebounce;

  @override
  void initState() {
    super.initState();
    _taskRx = widget.task.obs;
    _titleCtrl = TextEditingController(text: widget.task.title);
    _descCtrl = TextEditingController(text: widget.task.desc);

    // Listen to changes in InboxController to keep this sheet in sync
    _inboxController.tasks.listen((tasks) {
      final updated = tasks.firstWhereOrNull((t) => t.id == widget.task.id);
      if (updated != null) {
        _taskRx.value = updated;
        if (_titleCtrl.text != updated.title) _titleCtrl.text = updated.title;
        if (_descCtrl.text != updated.desc) _descCtrl.text = updated.desc;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCommentsFromApi();
    });
  }

  Future<void> _loadCommentsFromApi() async {
    final id = widget.task.id;
    if (int.tryParse(id) == null) return;
    final data = await ApiRepository.getOne(resource: 'tasks', id: id);
    if (!mounted || data == null) return;
    final parsed = _inboxController.parseTaskFromApiMap(
      Map<String, dynamic>.from(data),
    );
    if (!mounted) return;
    setState(() {
      _taskRx.value = _taskRx.value.copyWith(comments: parsed.comments);
    });
    widget.onUpdate?.call(_taskRx.value);
  }

  @override
  void dispose() {
    _persistDebounce?.cancel();
    _commentCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  ImageProvider _evidenceImageProvider(String path) {
    final p = path.trim();
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return NetworkImage(p);
    }
    return FileImage(File(p));
  }

  void _schedulePersistTask(Task task) {
    if (int.tryParse(task.id) == null) return;
    _persistDebounce?.cancel();
    _persistDebounce = Timer(const Duration(milliseconds: 650), () {
      _inboxController.persistTaskToApi(task);
    });
  }

  void _updateTask(Task updated) {
    _taskRx.value = updated;
    if (widget.onUpdate != null) {
      widget.onUpdate!(updated);
    } else {
      _inboxController.updateTask(updated);
    }
    _schedulePersistTask(updated);
  }

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isEmpty) return;

    final task = _taskRx.value;
    final paths = images.map((e) => e.path).toList();
    if (int.tryParse(task.id) == null) {
      final updatedPhotos = List<String>.from(task.evidencePhotos)..addAll(paths);
      _updateTask(
        task.copyWith(
          evidencePhotos: updatedPhotos,
          attachments: updatedPhotos,
        ),
      );
      return;
    }

    final api = ApiProgressService.tryGet();
    final n = paths.length;
    var urls = List<String>.from(task.evidencePhotos);

    if (api != null) {
      api.showDeterminate(0, 'Uploading photos…');
    }
    try {
      for (var i = 0; i < paths.length; i++) {
        final path = paths[i];
        final res = await ApiRepository.uploadTaskAttachment(
          taskId: task.id,
          filePath: path,
          onSendProgress: (sent, total) {
            if (total > 0 && api != null) {
              final fileFrac = sent / total;
              final overall = (i + fileFrac) / n;
              api.showDeterminate(
                overall,
                'Photo ${i + 1} of $n',
              );
            }
          },
        );
        final url = res?['url']?.toString();
        if (url != null && url.isNotEmpty) urls.add(url);
        if (api != null) {
          api.showDeterminate((i + 1) / n, 'Photo ${i + 1} of $n');
        }
      }

      if (api != null) {
        api.showDeterminate(0.92, 'Refreshing…');
      }

      _persistDebounce?.cancel();
      final meta =
          task.attachments.where((a) => a.startsWith('project:')).toList();
      final merged = <String>[...meta, ...urls];
      _updateTask(
        task.copyWith(evidencePhotos: urls, attachments: merged),
      );
      await _inboxController.loadTasks();
      if (Get.isRegistered<ProjectsController>()) {
        await Get.find<ProjectsController>().loadAll();
      }

      if (api != null) {
        api.showDeterminate(1.0, 'Done');
        await Future.delayed(const Duration(milliseconds: 200));
      }
    } finally {
      api?.hide();
    }
  }

  void _showImageModal(BuildContext context, String imagePath, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: _evidenceImageProvider(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final task = _taskRx.value;

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
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
                    Icon(
                      Icons.inbox_rounded,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Inbox',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 14,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => showTaskActionMenu(
                        context,
                        task: task,
                        nestedInDetailSheet: true,
                      ),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.cardSecondary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Icon(
                          Icons.more_horiz_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                height: 1,
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  children: [
                    // Title Edit
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            final newVal = !task.isCompleted;
                            Get.find<TaskService>().toggleTaskCompletion(
                              task.id,
                              newVal,
                            );
                            final next = task.copyWith(
                              isCompleted: newVal,
                              status: newVal ? 'Done' : 'In Progress',
                            );
                            _taskRx.value = next;
                            if (widget.onUpdate != null) {
                              widget.onUpdate!(next);
                            } else {
                              _inboxController.updateTask(next);
                            }
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: task.isCompleted
                                    ? AppColors.green
                                    : AppColors.borderLight,
                                width: 1.5,
                              ),
                              color: task.isCompleted
                                  ? AppColors.green.withOpacity(0.1)
                                  : null,
                            ),
                            child: task.isCompleted
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: AppColors.green,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _titleCtrl,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Task title',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (val) =>
                                _updateTask(task.copyWith(title: val)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description / Notes Edit
                    TextField(
                      controller: _descCtrl,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add description or notes...',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.notes_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted,
                        ),
                      ),
                      onChanged: (val) => _updateTask(task.copyWith(desc: val)),
                    ),

                    const SizedBox(height: 16),

                    // Detail Editable Chips/Rows
                    _EditableDetailRow(
                      icon: Icons.calendar_today_rounded,
                      label: task.dueDate != null
                          ? DateFormat('EEE, d MMM').format(task.dueDate!)
                          : 'Set Date',
                      isActive: task.dueDate != null,
                      onTap: () async {
                        final date = await showModalBottomSheet<DateTime>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const DatePickerSheet(),
                        );
                        if (date != null) {
                          _updateTask(
                            task.copyWith(
                              dueDate: date,
                              dueToday: DateUtils.isSameDay(
                                date,
                                DateTime.now(),
                              ),
                            ),
                          );
                        }
                      },
                    ),

                    _EditableDetailRow(
                      icon: Icons.access_time_rounded,
                      label: task.time ?? 'Set Time',
                      isActive: task.time != null,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          _updateTask(
                            task.copyWith(time: time.format(context)),
                          );
                        }
                      },
                    ),

                    _EditableDetailRow(
                      icon: Icons.flag_rounded,
                      iconColor: task.priority == 1
                          ? AppColors.red
                          : task.priority == 2
                          ? AppColors.gold
                          : task.priority == 3
                          ? AppColors.primaryColor
                          : null,
                      label: 'Priority ${task.priority}',
                      isActive: task.priority != 4,
                      onTap: () async {
                        final p = await showModalBottomSheet<int>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => PrioritySheet(current: task.priority),
                        );
                        if (p != null) _updateTask(task.copyWith(priority: p));
                      },
                    ),

                    _EditableDetailRow(
                      icon: Icons.person_outline_rounded,
                      label:
                          task.assignedUser != null &&
                              task.assignedUser!.isNotEmpty
                          ? 'Assigned: ${task.assignedUser}'
                          : 'Assign user (by user ID)',
                      isActive:
                          task.assignedUser != null &&
                          task.assignedUser!.isNotEmpty,
                      onTap: () async {
                        final userId = await _askText(
                          context,
                          title: 'Assign Task',
                          hint: 'Enter user ID',
                        );
                        if (userId != null && userId.trim().isNotEmpty) {
                          await _inboxController.assignTask(
                            taskId: task.id,
                            userId: userId.trim(),
                          );
                        }
                      },
                    ),

                    _EditableDetailRow(
                      icon: Icons.subdirectory_arrow_right_rounded,
                      label: 'Add subtask',
                      isActive: false,
                      onTap: () async {
                        final title = await _askText(
                          context,
                          title: 'New Subtask',
                          hint: 'Subtask title',
                        );
                        if (title != null && title.trim().isNotEmpty) {
                          await _inboxController.addSubtask(
                            parentTaskId: task.id,
                            title: title.trim(),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Evidence Photos section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Evidence Photos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickAttachment,
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            size: 18,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (task.evidencePhotos.isNotEmpty)
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: task.evidencePhotos.length,
                          itemBuilder: (context, index) => Stack(
                            children: [
                              GestureDetector(
                                onTap: () => _showImageModal(
                                  context,
                                  task.evidencePhotos[index],
                                  isDark,
                                ),
                                child: Container(
                                  width: 90,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkBorder
                                          : AppColors.borderLight,
                                    ),
                                    image: DecorationImage(
                                      image: _evidenceImageProvider(
                                        task.evidencePhotos[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 14,
                                child: GestureDetector(
                                  onTap: () {
                                    final updated = List<String>.from(
                                      task.evidencePhotos,
                                    )..removeAt(index);
                                    _updateTask(
                                      task.copyWith(
                                        evidencePhotos: updated,
                                        attachments: updated,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 80,
                        width: double.infinity,
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
                        child: Center(
                          child: Text(
                            'No photos added',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 24),
                    Divider(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.borderLight,
                    ),

                    // Comments section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${task.comments.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (task.comments.isNotEmpty)
                      ...task.comments.map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CommentItem(
                            userName: c.userName,
                            text: c.text,
                            timestamp: c.timestamp,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'No comments yet',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Comment input
              Divider(
                color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  14,
                  10,
                  14,
                  MediaQuery.of(context).padding.bottom + 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.inputFieldBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.borderLight,
                          ),
                        ),
                        child: TextField(
                          controller: _commentCtrl,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Add a comment…',
                            hintStyle: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_commentCtrl.text.isNotEmpty)
                      GestureDetector(
                        onTap: () async {
                          final text = _commentCtrl.text.trim();
                          if (text.isEmpty) return;
                          _commentCtrl.clear();
                          setState(() {});
                          final c = await _inboxController.addComment(
                            task.id,
                            text,
                          );
                          if (!mounted) return;
                          if (c != null &&
                              !_taskRx.value.comments.any((e) => e.id == c.id)) {
                            _taskRx.value = _taskRx.value.copyWith(
                              comments: [..._taskRx.value.comments, c],
                            );
                          }
                          widget.onUpdate?.call(_taskRx.value);
                          setState(() {});
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.accentBlue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: _pickAttachment,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.cardSecondary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: Icon(
                            Icons.attach_file_rounded,
                            size: 16,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<String?> _askText(
    BuildContext context, {
    required String title,
    required String hint,
  }) async {
    final ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    return result;
  }
}

class _EditableDetailRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _EditableDetailRow({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceElevated
                    : AppColors.cardSecondary,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.borderLight,
                ),
              ),
              child: Icon(
                icon,
                size: 16,
                color:
                    iconColor ??
                    (isActive
                        ? AppColors.primaryColor
                        : (isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted)),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color: isActive
                    ? (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary)
                    : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.edit_outlined,
              size: 14,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// Re-using simplified components from add_task_sheet or re-defining for standalone use
class DatePickerSheet extends StatefulWidget {
  const DatePickerSheet({super.key});
  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

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
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Pick a Date',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          CalendarDatePicker(
            initialDate: _focused,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateChanged: (date) => setState(() => _selected = date),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GradientButton(
              label: 'Save Date',
              onPressed: () => Navigator.pop(context, _selected),
            ),
          ),
        ],
      ),
    );
  }
}

class PrioritySheet extends StatelessWidget {
  final int current;
  const PrioritySheet({super.key, required this.current});

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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Set Priority',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
          ...priorities.map(
            (p) => ListTile(
              leading: Icon(Icons.flag_rounded, color: p.$3),
              title: Text(
                p.$2,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing: current == p.$1
                  ? const Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
              onTap: () => Navigator.pop(context, p.$1),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final String userName;
  final String text;
  final DateTime timestamp;
  const CommentItem({
    super.key,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primaryColor,
          child: Text(
            userName[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

