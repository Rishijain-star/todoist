import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../today/controllers/today_controller.dart';
import '../../upcoming/controllers/upcoming_controller.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../browse/controllers/browse_controller.dart';
import '../../team/controllers/team_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    if (!Get.isRegistered<TodayController>()) {
      Get.lazyPut<TodayController>(() => TodayController());
    }
    if (!Get.isRegistered<UpcomingController>()) {
      Get.lazyPut<UpcomingController>(() => UpcomingController());
    }
    if (!Get.isRegistered<InboxController>()) {
      Get.lazyPut<InboxController>(() => InboxController());
    }
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(() => SettingsController());
    }
    if (!Get.isRegistered<BrowseController>()) {
      Get.lazyPut<BrowseController>(() => BrowseController());
    }
    if (!Get.isRegistered<TeamController>()) {
      Get.lazyPut<TeamController>(() => TeamController());
    }
  }
}
