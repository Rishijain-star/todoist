import 'package:get/get.dart';

class TodayController extends GetxController {
  final isLoading = true.obs;

  // Mock data for progress
  final completedCount = 3.obs;
  final totalCount = 5.obs;

  @override
  void onInit() {
    super.onInit();
    startLoading();
  }

  void startLoading() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!isClosed) isLoading.value = false;
    });
  }

  void toggleTask(bool isDone) {
    if (isDone) {
      completedCount.value++;
    } else {
      completedCount.value--;
    }
  }
}
