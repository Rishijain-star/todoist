import 'package:get/get.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.microtask(_goNext);
  }

  Future<void> _goNext() async {
    print("SplashController: start");

    // Logo scale (~0.2s) + rotation (~1.2s) + exit fade (~0.5s) — keep buffer for polish
    await Future.delayed(const Duration(milliseconds: 2600));

    final hasSeen = LocalStorageService().getHasSeenSplash();
    print("SplashController: hasSeenSplash=$hasSeen");
    if (!hasSeen) {
      await LocalStorageService().setHasSeenSplash(true);
      print("SplashController: set hasSeenSplash=true");
    }

    // Token in prefs and/or secure storage (secure alone can fail on some devices)
    final loggedIn = await LocalStorageService().hasAuthSession();
    print("SplashController: loggedIn=$loggedIn");

    // Check if onboarding is completed
    final isOnboardingCompleted = LocalStorageService()
        .getIsOnboardingCompleted();

    if (!loggedIn) {
      // If not logged in, always show Auth Welcome (Login/Signup)
      Get.offAllNamed(Routes.AUTH_WELCOME);
    } else {
      // If logged in, check if they finished onboarding
      if (!isOnboardingCompleted) {
        Get.offAllNamed(Routes.ONBOARDING_WELCOME);
      } else {
        Get.offAllNamed(Routes.DASHBOARD);
      }
    }
    print("SplashController: navigation dispatched");
  }
}
