import 'package:get/get.dart';

class HomeController extends GetxController {
  final greeting = 'Good morning'.obs;
  final name = 'Karan Jain'.obs;
  final date = 'Sunday, 22 March'.obs;
  final completedTasks = 12.obs;
  final totalTasks = 18.obs;
  final motivation = 'You are almost there! Keep it up.'.obs;

  final aiSuggestions = <String>[
    'Finalize Move-Out for Unit 402',
    'Follow up on Unit 105 Lease Renewal',
    'Schedule Periodic Inspection for Block B',
  ].obs;

  void refreshDashboard() {
    // Logic to refresh data
  }
}
