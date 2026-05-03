import 'package:get/get.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/today_controller.dart';

class TodayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodayController>(() => TodayController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
