import 'package:get/get.dart';

class ReportsController extends GetxController {
  final completedTasks = 42.obs;
  final overdueTasks = 5.obs;
  final activeWorkflows = 3.obs;
  final workflowCompletionRate = 0.78.obs;

  final userActivityData = <double>[12, 18, 15, 25, 20, 30, 22].obs; // Sample activity over 7 days
}
