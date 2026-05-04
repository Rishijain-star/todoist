import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/api_repository.dart';
import '../../../data/models/template_model.dart';
import '../../../services/api_progress_service.dart';

class BrowseController extends GetxController {
  final isProjectsLoading = true.obs;
  final isTemplatesLoading = true.obs;
  final projects = <BrowseProject>[].obs;
  final templates = <TaskTemplate>[].obs;
  final categories = <TemplateCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBrowse();
  }

  Future<void> loadBrowse() async {
    isProjectsLoading.value = true;
    isTemplatesLoading.value = true;
    try {
      // Workflows -> "My Projects" list on Browse tab
      final workflowsPayload = await ApiRepository.listResource(
        resource: "workflows",
        perPage: 20,
        page: 1,
      );
      final workflowRows = (workflowsPayload?['data'] as List?) ?? const [];
      projects.assignAll(
        workflowRows.whereType<Map>().map((m) {
          final w = Map<String, dynamic>.from(m);
          final deadlineRaw = w['deadline']?.toString();
          final deadline = (deadlineRaw != null && deadlineRaw.isNotEmpty)
              ? DateTime.tryParse(deadlineRaw)
              : null;
          final progress = ((w['progress'] ?? 0) is num)
              ? (w['progress'] as num).toDouble() / 100.0
              : 0.0;
          return BrowseProject(
            id: (w['id'] ?? '').toString(),
            name: (w['name'] ?? '').toString(),
            favorite: false,
            layout: BrowseProjectLayout.list,
            progress: progress.clamp(0.0, 1.0),
            status: (w['status'] ?? 'Pending').toString(),
            deadline: deadline,
            assignedUsers: const [],
          );
        }).toList(),
      );

      // Templates in BrowseController are still used by older UI; keep a minimal mapping.
      final templatesPayload = await ApiRepository.listResource(
        resource: "templates",
        perPage: 100,
        page: 1,
      );
      final templateRows = (templatesPayload?['data'] as List?) ?? const [];
      templates.assignAll(
        templateRows.whereType<Map>().map((m) {
          final t = Map<String, dynamic>.from(m);
          return TaskTemplate(
            id: (t['id'] ?? '').toString(),
            title: (t['name'] ?? '').toString(),
            description: (t['description'] ?? '').toString(),
            category: (t['category'] ?? 'General').toString(),
            steps: _stepTitlesFromTemplatePhases(t['phases']),
            icon: Icons.article_outlined,
            color: Colors.blue,
          );
        }).toList(),
      );

      final Map<String, List<TaskTemplate>> grouped = {};
      for (var template in templates) {
        if (!grouped.containsKey(template.category)) {
          grouped[template.category] = [];
        }
        grouped[template.category]!.add(template);
      }
      categories.assignAll(
        grouped.entries.map(
          (e) => TemplateCategory(name: e.key, templates: e.value),
        ),
      );
    } finally {
      isProjectsLoading.value = false;
      isTemplatesLoading.value = false;
    }
  }

  Future<void> addProject({
    required String name,
    BrowseProjectLayout layout = BrowseProjectLayout.list,
    bool favorite = false,
  }) async {
    final api = ApiProgressService.tryGet();
    api?.showIndeterminate('Creating project…');
    try {
      await ApiRepository.create(
        resource: "projects",
        body: {
          "name": name.trim(),
          "category": favorite ? "Favorite" : "General",
          "description": "Layout: ${layout.name}",
        },
      );
      api?.showIndeterminate('Updating browse…');
      await loadBrowse();
    } finally {
      api?.hide();
    }
  }
}

/// Flatten API template `phases[].steps[].title` for browse list / preview.
List<String> _stepTitlesFromTemplatePhases(dynamic phasesRaw) {
  if (phasesRaw is! List) return const [];
  final titles = <String>[];
  for (final p in phasesRaw) {
    if (p is! Map) continue;
    final steps = p['steps'];
    if (steps is! List) continue;
    for (final s in steps) {
      if (s is Map && s['title'] != null) {
        titles.add(s['title'].toString());
      }
    }
  }
  return titles;
}

enum BrowseProjectLayout { list, board, calendar }

class BrowseProject {
  final String id;
  final String name;
  final bool favorite;
  final BrowseProjectLayout layout;
  final double progress;
  final String status;
  final DateTime? deadline;
  final List<String> assignedUsers;

  const BrowseProject({
    required this.id,
    required this.name,
    required this.favorite,
    required this.layout,
    this.progress = 0.0,
    this.status = 'In Progress',
    this.deadline,
    this.assignedUsers = const [],
  });
}
