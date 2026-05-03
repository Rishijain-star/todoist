import 'package:get/get.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_models.dart';

class AdminController extends GetxController {
  final selectedSection = AdminSection.dashboard.obs;
  final selectedWorkflowId = RxnString();
  final selectedTemplateId = RxnString();
  final selectedTaskId = RxnString();

  void changeSection(AdminSection section) {
    selectedSection.value = section;
  }

  void openWorkflowDetail(String id) {
    selectedWorkflowId.value = id;
  }

  void closeWorkflowDetail() {
    selectedWorkflowId.value = null;
  }

  void openTemplateDetail(String id) {
    selectedTemplateId.value = id;
  }

  void closeTemplateDetail() {
    selectedTemplateId.value = null;
  }

  void openTaskDetail(String id) {
    selectedTaskId.value = id;
  }

  void closeTaskDetail() {
    selectedTaskId.value = null;
  }

  List<AdminMetric> get dashboardMetrics => AdminMockData.dashboardMetrics;
  List<UserRecord> get users => AdminMockData.users;
  List<WorkflowRecord> get workflows => AdminMockData.workflows;
  List<TemplateRecord> get templates => AdminMockData.templates;
  List<TaskRecord> get tasks => AdminMockData.tasks;
  List<AdminNotification> get notifications => AdminMockData.notifications;
  List<ActivityRecord> get activities => AdminMockData.recentActivities;
  List<ChartPoint> get weeklyTaskChart => AdminMockData.weeklyTaskChart;
  List<ChartPoint> get workflowProgressChart => AdminMockData.workflowProgressChart;
  List<ChartPoint> get reportsDailyChart => AdminMockData.reportsDailyChart;
  List<ChartPoint> get reportsMonthlyChart => AdminMockData.reportsMonthlyChart;

  WorkflowRecord? get selectedWorkflow {
    final id = selectedWorkflowId.value;
    if (id == null) return null;
    return workflows.where((w) => w.id == id).firstOrNull;
  }

  TemplateRecord? get selectedTemplate {
    final id = selectedTemplateId.value;
    if (id == null) return null;
    return templates.where((t) => t.id == id).firstOrNull;
  }

  TaskRecord? get selectedTask {
    final id = selectedTaskId.value;
    if (id == null) return null;
    return tasks.where((t) => t.id == id).firstOrNull;
  }
}
