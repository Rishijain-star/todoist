import 'package:get/get.dart';
import '../../../data/api_repository.dart';
import '../../../data/models/task_model.dart';
import '../../../services/api_progress_service.dart';
import '../../projects/controllers/projects_controller.dart';

enum InboxLayoutMode { list, board, calendar }

class InboxController extends GetxController {
  final isLoading = true.obs;
  final tasks = <Task>[].obs;
  final layoutMode = InboxLayoutMode.list.obs;
  final uploadProgressByPath = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  /// [fullScreenLoader]: false for pull-to-refresh (keeps list visible, no shimmer takeover).
  Future<void> loadTasks({bool fullScreenLoader = true}) async {
    if (fullScreenLoader) isLoading.value = true;
    try {
      final payload = await ApiRepository.listResource(
        resource: "tasks",
        perPage: 50,
        page: 1,
      );
      final data = (payload?['data'] as List?) ?? const [];
      final mapped = data
          .whereType<Map>()
          .map((m) => _taskFromApi(Map<String, dynamic>.from(m)))
          .toList();
      tasks.assignAll(mapped);
    } catch (_) {
      // ApiClient already surfaces errors/toasts.
    } finally {
      if (fullScreenLoader) isLoading.value = false;
    }
  }

  /// Pull-to-refresh: reload tasks (no full-screen shimmer) + projects cache for Today/Upcoming.
  Future<void> refreshTasks() async {
    await loadTasks(fullScreenLoader: false);
    if (Get.isRegistered<ProjectsController>()) {
      await Get.find<ProjectsController>().loadAll(silent: true);
    }
  }

  void addTask(Task task) {
    tasks.add(task);
  }

  Future<void> createTaskFromSheet(Task task, {String? projectId}) async {
    final api = ApiProgressService.tryGet();
    final localPaths = task.attachments
        .where(
          (p) =>
              p.isNotEmpty &&
              !p.startsWith('http://') &&
              !p.startsWith('https://'),
        )
        .toList();
    final totalSteps = 1 + localPaths.length;

    if (api != null) {
      if (totalSteps == 1) {
        api.showIndeterminate('Creating task…');
      } else {
        api.showDeterminate(0, 'Creating task…');
      }
    }

    try {
      final dueDate = task.dueDate?.toIso8601String().split('T').first;
      final created = await ApiRepository.createTask(
        title: task.title,
        notes: task.desc,
        dueDate: dueDate,
        priority: _priorityToApi(task.priority),
        status: task.status,
        projectId: projectId,
        assignedUserId: null,
      );
      final taskId = (created?['id'] ?? '').toString();
      if (taskId.isEmpty) {
        addTask(task);
        return;
      }

      if (localPaths.isNotEmpty) {
        api?.showDeterminate(1 / totalSteps, 'Uploading files…');
      }

      for (var i = 0; i < localPaths.length; i++) {
        final path = localPaths[i];
        uploadProgressByPath[path] = 0.0;
        await ApiRepository.uploadTaskAttachment(
          taskId: taskId,
          filePath: path,
          onSendProgress: (sent, total) {
            if (total > 0) {
              final fileFrac = sent / total;
              uploadProgressByPath[path] = fileFrac;
              if (api != null && totalSteps > 1) {
                final overall = (1 + i + fileFrac) / totalSteps;
                api.showDeterminate(
                  overall,
                  'File ${i + 1} of ${localPaths.length}',
                );
              }
            }
          },
        );
        uploadProgressByPath[path] = 1.0;
      }

      if (api != null && totalSteps > 1) {
        api.showDeterminate(0.94, 'Refreshing…');
      }

      await loadTasks();
      if (projectId != null && Get.isRegistered<ProjectsController>()) {
        await Get.find<ProjectsController>().loadAll();
      }

      if (api != null && totalSteps > 1) {
        api.showDeterminate(1.0, 'Done');
        await Future.delayed(const Duration(milliseconds: 220));
      }
    } finally {
      api?.hide();
    }
  }

  Future<void> addSubtask({
    required String parentTaskId,
    required String title,
  }) async {
    final api = ApiProgressService.tryGet();
    api?.showIndeterminate('Adding subtask…');
    try {
      await ApiRepository.createTask(
        title: title,
        parentTaskId: parentTaskId,
        status: 'Pending',
      );
      await loadTasks();
    } finally {
      api?.hide();
    }
  }

  Future<void> assignTask({
    required String taskId,
    required String userId,
  }) async {
    final api = ApiProgressService.tryGet();
    api?.showIndeterminate('Assigning…');
    try {
      await ApiRepository.update(
        resource: 'tasks',
        id: taskId,
        body: {'assigned_user_id': int.tryParse(userId) ?? userId},
      );
      await loadTasks();
    } finally {
      api?.hide();
    }
  }

  /// Persists editable fields for a task that already exists on the API.
  Future<void> persistTaskToApi(Task task) async {
    if (int.tryParse(task.id) == null) return;
    final due = task.dueDate?.toIso8601String().split('T').first;
    await ApiRepository.update(
      resource: 'tasks',
      id: task.id,
      body: {
        'title': task.title,
        'notes': task.desc,
        if (due != null && due.isNotEmpty) 'due_date': due,
        'priority': _priorityToApi(task.priority),
        'status': task.status,
      },
    );
  }

  void setLayoutMode(InboxLayoutMode mode) {
    layoutMode.value = mode;
  }

  /// When true, completed subtasks are hidden in inbox list trees.
  final RxBool hideCompletedSubtasks = false.obs;

  void toggleHideCompletedSubtasks() {
    hideCompletedSubtasks.value = !hideCompletedSubtasks.value;
    tasks.refresh();
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }

  void toggleTaskCompletion(String id, bool isCompleted) {
    final updatedTasks = _updateTaskInList(tasks, id, isCompleted);
    if (updatedTasks != null) {
      tasks.assignAll(updatedTasks);
      tasks.refresh();
    }

    // Fire-and-forget API update (members/managers can update).
    ApiRepository.update(
      resource: "tasks",
      id: id,
      body: {"status": isCompleted ? "Done" : "In Progress"},
    );
  }

  Task _taskFromApi(Map<String, dynamic> t) {
    final dueRaw = t['due_date']?.toString();
    DateTime? dueDate;
    if (dueRaw != null && dueRaw.isNotEmpty) {
      dueDate = DateTime.tryParse(dueRaw);
    }
    final status = (t['status'] ?? 'Pending').toString();
    final isDone =
        status.toLowerCase() == 'done' || status.toLowerCase() == 'completed';
    final today = DateTime.now();
    final dueToday =
        dueDate != null &&
        dueDate.year == today.year &&
        dueDate.month == today.month &&
        dueDate.day == today.day;

    final pr = (t['priority'] ?? 'Medium').toString().toLowerCase();
    final priority = pr == 'high'
        ? 1
        : pr == 'medium'
        ? 3
        : pr == 'low'
        ? 4
        : 4;

    final assigned = t['assigned_user'];
    String? assignedName;
    if (assigned is Map && assigned['name'] != null) {
      assignedName = assigned['name'].toString();
    }

    final attachmentUrls = <String>[];
    final attachmentsRaw = t['attachments'];
    if (attachmentsRaw is List) {
      for (final a in attachmentsRaw) {
        if (a is Map && a['url'] != null) {
          attachmentUrls.add(a['url'].toString());
        }
      }
    }

    final subtasksRaw = t['subtasks'];
    final subtasks = <Task>[];
    if (subtasksRaw is List) {
      for (final st in subtasksRaw.whereType<Map>()) {
        subtasks.add(_taskFromApi(Map<String, dynamic>.from(st)));
      }
    }

    return Task(
      id: (t['id'] ?? '').toString(),
      title: (t['title'] ?? '').toString(),
      desc: (t['notes'] ?? '').toString(),
      dueToday: dueToday,
      dueDate: dueDate,
      comments: commentsFromApiJson(t['comments']),
      priority: priority,
      assignedUser: assignedName,
      status: status,
      isCompleted: isDone,
      attachments: attachmentUrls,
      evidencePhotos: attachmentUrls,
      subtasks: subtasks,
    );
  }

  /// Same mapping as inbox list / `GET tasks/:id` payloads.
  Task parseTaskFromApiMap(Map<String, dynamic> m) => _taskFromApi(m);

  String _priorityToApi(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
      case 4:
      default:
        return 'Low';
    }
  }

  List<Task>? _updateTaskInList(
    List<Task> tasks,
    String taskId,
    bool isCompleted,
  ) {
    final taskIndex = tasks.indexWhere((t) => t.id == taskId);

    if (taskIndex != -1) {
      final updatedTasks = List<Task>.from(tasks);
      final task = tasks[taskIndex];
      updatedTasks[taskIndex] = task.copyWith(
        isCompleted: isCompleted,
        status: isCompleted ? 'Done' : 'In Progress',
      );
      return updatedTasks;
    }

    // Check subtasks recursively
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      if (task.subtasks.isNotEmpty) {
        final updatedSubtasks = _updateTaskInList(
          task.subtasks,
          taskId,
          isCompleted,
        );
        if (updatedSubtasks != null) {
          final updatedTasks = List<Task>.from(tasks);
          updatedTasks[i] = task.copyWith(subtasks: updatedSubtasks);
          return updatedTasks;
        }
      }
    }

    return null;
  }

  Future<Comment?> addComment(String taskId, String text) async {
    final trimmed = text.trim();
    if (int.tryParse(taskId) == null || trimmed.isEmpty) return null;

    final res = await ApiRepository.createTaskComment(
      taskId: taskId,
      body: trimmed,
    );
    if (res == null) return null;

    final c = commentFromApiMap(Map<String, dynamic>.from(res));
    if (c == null) return null;

    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = tasks[index];
      if (!task.comments.any((e) => e.id == c.id)) {
        tasks[index] = task.copyWith(comments: [...task.comments, c]);
        tasks.refresh();
      }
    }

    if (Get.isRegistered<ProjectsController>()) {
      Get.find<ProjectsController>().mergeCommentIntoTask(taskId, c);
    }

    return c;
  }

  void duplicateTask(Task original) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${original.title} (Copy)',
      desc: original.desc,
      dueToday: original.dueToday,
      dueDate: original.dueDate,
      priority: original.priority,
      assignedUser: original.assignedUser,
      attachments: List<String>.from(original.attachments),
      evidencePhotos: List<String>.from(original.evidencePhotos),
      comments: [], // Don't duplicate comments as it's a new task
      status: original.status,
      time: original.time,
      isCompleted: false, // New tasks are not completed
    );
    tasks.add(newTask);
    tasks.refresh();
  }

  void updateTask(Task updated) {
    final index = tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      tasks[index] = updated;
      tasks.refresh();
    }
  }
}
