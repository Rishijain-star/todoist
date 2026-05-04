import 'package:get/get.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../projects/controllers/projects_controller.dart';
import '../../../data/models/task_model.dart';

class TodayController extends GetxController {
  final isLoading = true.obs;
  Worker? _loadingWorker;

  List<Task> get _allTasks {
    final List<Task> all = [];
    if (Get.isRegistered<InboxController>()) {
      all.addAll(Get.find<InboxController>().tasks);
    }
    if (Get.isRegistered<ProjectsController>()) {
      for (var project in Get.find<ProjectsController>().projects) {
        for (var phase in project.phases) {
          all.addAll(phase.tasks);
        }
      }
    }
    return all;
  }

  List<Task> get todayTasks {
    final now = DateTime.now();
    final tasks = _allTasks.where((t) {
      if (t.dueToday) return true;
      if (t.dueDate == null) return false;
      return t.dueDate!.year == now.year &&
          t.dueDate!.month == now.month &&
          t.dueDate!.day == now.day;
    }).toList();

    _sortTasks(tasks);
    return tasks;
  }

  List<Task> get overdueTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tasks = _allTasks.where((t) {
      if (t.dueDate == null || t.isCompleted) return false;
      final taskDate = DateTime(
        t.dueDate!.year,
        t.dueDate!.month,
        t.dueDate!.day,
      );
      return taskDate.isBefore(today);
    }).toList();

    _sortTasks(tasks);
    return tasks;
  }

  void _sortTasks(List<Task> tasks) {
    tasks.sort((a, b) {
      // 1. Sort by Date (ascending)
      if (a.dueDate != null && b.dueDate != null) {
        final dateOnlyA = DateTime(
          a.dueDate!.year,
          a.dueDate!.month,
          a.dueDate!.day,
        );
        final dateOnlyB = DateTime(
          b.dueDate!.year,
          b.dueDate!.month,
          b.dueDate!.day,
        );
        if (dateOnlyA != dateOnlyB) {
          return dateOnlyA.compareTo(dateOnlyB);
        }
      }

      // 2. Sort by Time (ascending chronologically)
      final timeA = a.time != null ? _parseTime(a.time!) : 99.0;
      final timeB = b.time != null ? _parseTime(b.time!) : 99.0;

      if (timeA != timeB) {
        return timeA.compareTo(timeB);
      }

      // 3. Sort by Priority (higher priority first: 1 < 2 < 3 < 4)
      return a.priority.compareTo(b.priority);
    });
  }

  double _parseTime(String timeStr) {
    try {
      final cleanStr = timeStr.trim().toUpperCase();
      final timeRegex = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)?');
      final match = timeRegex.firstMatch(cleanStr);

      if (match != null) {
        double hours = double.tryParse(match.group(1)!) ?? 0;
        double minutes = double.tryParse(match.group(2)!) ?? 0;
        final amPm = match.group(3);

        if (amPm == 'PM' && hours < 12) {
          hours += 12;
        } else if (amPm == 'AM' && hours == 12) {
          hours = 0;
        }

        return hours + (minutes / 60.0);
      }
    } catch (e) {}
    return 0.0;
  }

  int get completedCount => todayTasks.where((t) => t.isCompleted).length;
  int get totalCount => todayTasks.length;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<InboxController>()) {
      final inbox = Get.find<InboxController>();
      isLoading.value = inbox.isLoading.value;
      _loadingWorker = ever<bool>(inbox.isLoading, (v) {
        isLoading.value = v;
      });
      if (inbox.tasks.isEmpty) {
        inbox.loadTasks();
      }
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _loadingWorker?.dispose();
    super.onClose();
  }
}
