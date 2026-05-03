import 'package:get/get.dart';
import '../../../data/api_repository.dart';
import '../../../data/models/task_model.dart';
import '../../../services/api_progress_service.dart';

class ProjectsController extends GetxController {
  final templates = <ProjectTemplate>[].obs;
  final projects = <Project>[].obs;
  final isLoading = true.obs;
  final isCreating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    try {
      final templatesPayload = await ApiRepository.listResource(
        resource: "templates",
        perPage: 200,
        page: 1,
      );
      final templateRows = (templatesPayload?['data'] as List?) ?? const [];
      templates.assignAll(
        templateRows
            .whereType<Map>()
            .map((m) => _templateFromApi(Map<String, dynamic>.from(m)))
            .toList(),
      );

      final projectsPayload = await ApiRepository.listResource(
        resource: "projects",
        perPage: 100,
        page: 1,
      );
      final projectRows = (projectsPayload?['data'] as List?) ?? const [];

      final tasksPayload = await ApiRepository.listResource(
        resource: "tasks",
        perPage: 200,
        page: 1,
      );
      final taskRows = (tasksPayload?['data'] as List?) ?? const [];
      final tasksMapped = taskRows
          .whereType<Map>()
          .map((m) => _taskFromApi(Map<String, dynamic>.from(m)))
          .toList();

      projects.assignAll(
        projectRows.whereType<Map>().map((m) {
          final p = Map<String, dynamic>.from(m);
          final pid = (p['id'] ?? '').toString();
          final projectTasks = tasksMapped
              .where((t) => t.attachments.contains("project:$pid"))
              .toList();
          return Project(
            id: pid,
            title: (p['name'] ?? '').toString(),
            phases: [Phase(id: "main", title: "Tasks", tasks: projectTasks)],
            createdAt:
                DateTime.tryParse((p['created_at'] ?? '').toString()) ??
                DateTime.now(),
          );
        }).toList(),
      );
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  /// Creates a real project on the API and one task per template step.
  Future<bool> createProjectFromTemplate(ProjectTemplate template) async {
    final api = ApiProgressService.tryGet();
    var taskCount = 0;
    for (final phase in template.phases) {
      taskCount += phase.tasks.length;
    }
    final totalSteps = 1 + taskCount + 1;

    api?.showDeterminate(0, 'Creating project…');
    try {
      final created = await ApiRepository.create(
        resource: 'projects',
        body: {
          'name': template.name,
          'category': template.category,
          'description': 'Created from template',
        },
      );
      final projectId = (created?['id'] ?? '').toString();
      if (projectId.isEmpty) {
        return false;
      }

      var done = 1;
      api?.showDeterminate(done / totalSteps, 'Adding tasks…');

      for (final phase in template.phases) {
        for (final task in phase.tasks) {
          await ApiRepository.createTask(
            title: task.title,
            notes: task.desc.isNotEmpty ? task.desc : null,
            status: task.status.isNotEmpty ? task.status : 'Pending',
            priority: _priorityIntToApi(task.priority),
            projectId: projectId,
          );
          done++;
          api?.showDeterminate(done / totalSteps, 'Adding tasks…');
        }
      }

      api?.showDeterminate((totalSteps - 1) / totalSteps, 'Syncing…');
      await loadAll();
      api?.showDeterminate(1.0, 'Done');
      await Future.delayed(const Duration(milliseconds: 220));
      return true;
    } finally {
      api?.hide();
    }
  }

  Future<void> createProject({
    required String name,
    String? description,
  }) async {
    isCreating.value = true;
    try {
      await ApiRepository.create(
        resource: 'projects',
        body: {
          'name': name,
          if (description != null && description.isNotEmpty)
            'description': description,
        },
      );
      await loadAll();
    } finally {
      isCreating.value = false;
    }
  }

  Task _cloneTask(Task task) {
    return Task(
      id: '${task.id}_${DateTime.now().millisecondsSinceEpoch}',
      title: task.title,
      desc: task.desc,
      dueToday: task.dueToday,
      dueDate: task.dueDate,
      priority: task.priority,
      assignedUser: task.assignedUser,
      status: task.status,
      time: task.time,
      isCompleted: false,
      comments: [],
      attachments: [],
      evidencePhotos: [],
      subtasks: task.subtasks.map((st) => _cloneTask(st)).toList(),
    );
  }

  void updateProject(Project updatedProject) {
    final index = projects.indexWhere((p) => p.id == updatedProject.id);
    if (index != -1) {
      projects[index] = updatedProject;
      projects.refresh();
    }
  }

  Future<void> deleteProject(String projectId) async {
    final api = ApiProgressService.tryGet();
    api?.showIndeterminate('Deleting project…');
    try {
      await ApiRepository.remove(resource: 'projects', id: projectId);
      api?.showIndeterminate('Syncing…');
      await loadAll();
    } finally {
      api?.hide();
    }
  }

  String _priorityIntToApi(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
      case 3:
        return 'Medium';
      case 4:
      default:
        return 'Low';
    }
  }

  void renamePhase(String projectId, String phaseId, String newTitle) {
    final projectIndex = projects.indexWhere((p) => p.id == projectId);
    if (projectIndex != -1) {
      final project = projects[projectIndex];
      final phaseIndex = project.phases.indexWhere((ph) => ph.id == phaseId);
      if (phaseIndex != -1) {
        final updatedPhases = List<Phase>.from(project.phases);
        updatedPhases[phaseIndex] = updatedPhases[phaseIndex].copyWith(
          title: newTitle,
        );
        projects[projectIndex] = project.copyWith(phases: updatedPhases);
      }
    }
  }

  void deletePhase(String projectId, String phaseId) {
    final projectIndex = projects.indexWhere((p) => p.id == projectId);
    if (projectIndex != -1) {
      final project = projects[projectIndex];
      final updatedPhases = List<Phase>.from(project.phases)
        ..removeWhere((ph) => ph.id == phaseId);
      projects[projectIndex] = project.copyWith(phases: updatedPhases);
    }
  }

  void duplicatePhase(String projectId, String phaseId) {
    final projectIndex = projects.indexWhere((p) => p.id == projectId);
    if (projectIndex != -1) {
      final project = projects[projectIndex];
      final phaseIndex = project.phases.indexWhere((ph) => ph.id == phaseId);
      if (phaseIndex != -1) {
        final phase = project.phases[phaseIndex];
        final clonedPhase = Phase(
          id: '${phase.id}_${DateTime.now().millisecondsSinceEpoch}',
          title: '${phase.title} (Copy)',
          tasks: phase.tasks.map((t) => _cloneTask(t)).toList(),
        );
        final updatedPhases = List<Phase>.from(project.phases);
        updatedPhases.insert(phaseIndex + 1, clonedPhase);
        projects[projectIndex] = project.copyWith(phases: updatedPhases);
      }
    }
  }

  void addTaskToPhase(String projectId, String phaseId, Task task) {
    final projectIndex = projects.indexWhere((p) => p.id == projectId);
    if (projectIndex != -1) {
      final project = projects[projectIndex];
      final phaseIndex = project.phases.indexWhere((ph) => ph.id == phaseId);
      if (phaseIndex != -1) {
        final updatedPhases = List<Phase>.from(project.phases);
        final updatedTasks = List<Task>.from(updatedPhases[phaseIndex].tasks)
          ..add(task);
        updatedPhases[phaseIndex] = updatedPhases[phaseIndex].copyWith(
          tasks: updatedTasks,
        );
        projects[projectIndex] = project.copyWith(phases: updatedPhases);
      }
    }
  }

  void archivePhase(String projectId, String phaseId) {
    // For now, just a snackbar placeholder as we don't have an archive system yet
    Get.snackbar(
      'Archive',
      'Section archived successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void copyPhaseLink(String phaseId) {
    // Placeholder for copying link
    Get.snackbar(
      'Success',
      'Section link copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  ProjectTemplate _templateFromApi(Map<String, dynamic> t) {
    final phasesRaw = (t['phases'] as List?) ?? const [];
    final phases = phasesRaw.whereType<Map>().map((p) {
      final pMap = Map<String, dynamic>.from(p);
      final stepsRaw = (pMap['steps'] as List?) ?? const [];
      final tasks = stepsRaw.whereType<Map>().map((s) {
        final sMap = Map<String, dynamic>.from(s);
        return Task(
          id: (sMap['id'] ?? '').toString(),
          title: (sMap['title'] ?? '').toString(),
          desc: (sMap['paragraph'] ?? '').toString(),
          dueToday: false,
          dueDate: null,
          status: 'Pending',
        );
      }).toList();
      return Phase(
        id: (pMap['id'] ?? '').toString(),
        title: (pMap['title'] ?? 'Phase').toString(),
        tasks: tasks,
      );
    }).toList();

    return ProjectTemplate(
      id: (t['id'] ?? '').toString(),
      name: (t['name'] ?? '').toString(),
      category: (t['category'] ?? 'General').toString(),
      phases: phases,
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

    String? assignedName;
    final assigned = t['assigned_user'];
    if (assigned is Map && assigned['name'] != null) {
      assignedName = assigned['name'].toString();
    }

    final meta = <String>[];
    final project = t['project'];
    if (project is Map && project['id'] != null) {
      meta.add("project:${project['id']}");
    } else if (t['project_id'] != null) {
      meta.add("project:${t['project_id']}");
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
      attachments: [...meta, ...attachmentUrls],
      evidencePhotos: attachmentUrls,
      subtasks: subtasks,
    );
  }

  void mergeCommentIntoTask(String taskId, Comment comment) {
    projects.assignAll(
      projects.map((proj) {
        return proj.copyWith(
          phases: proj.phases
              .map(
                (ph) => ph.copyWith(
                  tasks: _mergeCommentInTasks(ph.tasks, taskId, comment),
                ),
              )
              .toList(),
        );
      }).toList(),
    );
  }

  List<Task> _mergeCommentInTasks(
    List<Task> taskList,
    String taskId,
    Comment comment,
  ) {
    return taskList.map((t) {
      if (t.id == taskId) {
        if (t.comments.any((c) => c.id == comment.id)) return t;
        return t.copyWith(comments: [...t.comments, comment]);
      }
      if (t.subtasks.isEmpty) return t;
      return t.copyWith(
        subtasks: _mergeCommentInTasks(t.subtasks, taskId, comment),
      );
    }).toList();
  }
}
