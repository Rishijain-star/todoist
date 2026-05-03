import 'package:get/get.dart';
import '../../../data/api_repository.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../projects/controllers/projects_controller.dart';
import '../../../data/models/task_model.dart';

class UpcomingController extends GetxController {
  final isLoading = true.obs;
  final selectedDate = Rx<DateTime>(DateTime.now());
  final apiUpcomingTasks = <Task>[].obs;
  Worker? _loadingWorker;

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  List<Task> get _allTasks {
    if (apiUpcomingTasks.isNotEmpty) {
      return apiUpcomingTasks;
    }
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

  Map<DateTime, List<Task>> get groupedTasks {
    final allTasks = List<Task>.from(_allTasks);
    _sortTasks(allTasks);

    final Map<DateTime, List<Task>> grouped = {};
    for (var task in allTasks) {
      if (task.dueDate != null) {
        final dateOnly = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        if (!grouped.containsKey(dateOnly)) {
          grouped[dateOnly] = [];
        }
        grouped[dateOnly]!.add(task);
      }
    }
    return grouped;
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

      // 3. Sort by Priority (highest first: 1 < 2 < 3 < 4)
      return a.priority.compareTo(b.priority);
    });
  }

  double _parseTime(String timeStr) {
    try {
      final cleanStr = timeStr.trim().toUpperCase();

      // Regex for extracting components: Hours, Minutes, and AM/PM
      final timeRegex = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)?');
      final match = timeRegex.firstMatch(cleanStr);

      if (match != null) {
        double hours = double.tryParse(match.group(1)!) ?? 0;
        double minutes = double.tryParse(match.group(2)!) ?? 0;
        final amPm = match.group(3);

        // Convert to 24-hour format decimal value for comparison
        if (amPm == 'PM' && hours < 12) {
          hours += 12;
        } else if (amPm == 'AM' && hours == 12) {
          hours = 0;
        }

        return hours + (minutes / 60.0);
      }

      // Fallback: If it's only digits (e.g., "1500" for 15:00)
      final digitsOnly = cleanStr.replaceAll(RegExp(r'[^0-9]'), '');
      if (digitsOnly.length >= 3) {
        final hours =
            double.tryParse(digitsOnly.substring(0, digitsOnly.length - 2)) ??
            0;
        final minutes =
            double.tryParse(digitsOnly.substring(digitsOnly.length - 2)) ?? 0;
        return hours + (minutes / 60.0);
      }
    } catch (e) {
      // Final fallback
    }
    return 0.0;
  }

  @override
  void onInit() {
    super.onInit();
    loadUpcoming();
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

  Future<void> loadUpcoming({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    try {
      final payload = await ApiRepository.listUpcomingTasks(
        perPage: 200,
        page: 1,
      );
      final rows = (payload?['data'] as List?) ?? const [];
      final mapped = rows
          .whereType<Map>()
          .map((m) => _taskFromApi(Map<String, dynamic>.from(m)))
          .toList();
      apiUpcomingTasks.assignAll(mapped);
    } finally {
      if (!silent) isLoading.value = false;
    }
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

    return Task(
      id: (t['id'] ?? '').toString(),
      title: (t['title'] ?? '').toString(),
      desc: (t['notes'] ?? '').toString(),
      dueToday: dueToday,
      dueDate: dueDate,
      status: status,
      isCompleted: isDone,
    );
  }

  @override
  void onClose() {
    _loadingWorker?.dispose();
    super.onClose();
  }
}
