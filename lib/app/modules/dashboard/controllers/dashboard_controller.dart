import 'package:get/get.dart';
import '../../inbox/controllers/inbox_controller.dart';
import '../../today/controllers/today_controller.dart';
import '../../upcoming/controllers/upcoming_controller.dart';
import '../../browse/controllers/browse_controller.dart';

class DashboardController extends GetxController {
  final RxInt index = 0.obs;

  void setIndex(int i) {
    index.value = i;
    _triggerLoading(i);
  }

  void _triggerLoading(int i) {
    switch (i) {
      case 0:
        if (Get.isRegistered<InboxController>()) {
          Get.find<InboxController>().startLoading();
        }
        break;
      case 1:
        if (Get.isRegistered<TodayController>()) {
          Get.find<TodayController>().startLoading();
        }
        break;
      case 2:
        if (Get.isRegistered<UpcomingController>()) {
          Get.find<UpcomingController>().startLoading();
        }
        break;
      case 4:
        if (Get.isRegistered<BrowseController>()) {
          final browseCtrl = Get.find<BrowseController>();
          browseCtrl.isProjectsLoading.value = true;
          browseCtrl.isTemplatesLoading.value = true;
          Future.delayed(const Duration(milliseconds: 800), () {
            browseCtrl.isProjectsLoading.value = false;
            browseCtrl.isTemplatesLoading.value = false;
          });
        }
        break;
    }
  }
}
