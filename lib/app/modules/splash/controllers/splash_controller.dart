import 'package:get/get.dart';
import '../../../services/local_storage_services/local_storage_services.dart';
import '../../../services/secure_token_service/secure_token_service.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/views/dashboard_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.microtask(_goNext);
  }

  Future<void> _goNext() async {
    print("SplashController: start");

    // Always wait for a bit so splash animation can be seen
    await Future.delayed(const Duration(seconds: 2));

    final hasSeen = LocalStorageService().getHasSeenSplash();
    print("SplashController: hasSeenSplash=$hasSeen");
    if (!hasSeen) {
      await LocalStorageService().setHasSeenSplash(true);
      print("SplashController: set hasSeenSplash=true");
    }

    // Check if user is logged in
    bool loggedIn = false;
    try {
      loggedIn = await SecureTokenService().isLoggedIn();
    } catch (_) {
      loggedIn = false;
    }
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
