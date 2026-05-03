import 'package:get/get.dart';
import '../../browse/controllers/browse_controller.dart';
import '../../projects/controllers/projects_controller.dart';

class DashboardController extends GetxController {
  final RxInt index = 0.obs;

  void setIndex(int i) {
    if (index.value == i) return;
    index.value = i;
    // Inbox / Today / Upcoming: do not refetch on every tab switch — use pull-to-refresh there.
    _maybeRefreshSecondaryTabs(i);
  }

  void _maybeRefreshSecondaryTabs(int i) {
    switch (i) {
      case 3:
        if (Get.isRegistered<ProjectsController>()) {
          Get.find<ProjectsController>().loadAll();
        }
        break;
      case 4:
        if (Get.isRegistered<BrowseController>()) {
          Get.find<BrowseController>().loadBrowse();
        }
        break;
    }
  }
}
