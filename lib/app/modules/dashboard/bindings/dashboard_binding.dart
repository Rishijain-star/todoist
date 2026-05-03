import 'package:get/get.dart';

import '../../browse/controllers/browse_controller.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../today/controllers/today_controller.dart';
import '../../upcoming/controllers/upcoming_controller.dart';
import '../../projects/controllers/projects_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.put<InboxController>(InboxController(), permanent: true);
    Get.put<TodayController>(TodayController());
    Get.put<UpcomingController>(UpcomingController());
    Get.put<BrowseController>(BrowseController());
    Get.put<ProjectsController>(ProjectsController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
