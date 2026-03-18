import 'package:get/get.dart';

class UpcomingController extends GetxController {
  final isLoading = true.obs;

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
}
