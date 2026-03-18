import 'package:get/get.dart';
import '../controllers/upcoming_controller.dart';

class UpcomingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpcomingController>(() => UpcomingController());
  }
}
