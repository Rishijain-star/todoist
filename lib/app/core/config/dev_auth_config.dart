import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../services/local_storage_services/local_storage_services.dart';

/// Optional dev-only shortcut to skip network login (debug UI prototyping).
/// Keep [devBypassAuthentication] `false` so email/social flows hit the real API
/// at `https://todoist.jamesbrookit.com/api/v1/` and [ApiClient] enforces 401 logout.
///
/// **Safety:** [shouldBypassAuth] is `false` in release/profile builds even if the
/// flag is left `true`, so store builds never skip authentication accidentally.
class DevAuthConfig {
  DevAuthConfig._();

  static const bool devBypassAuthentication = false;

  /// Use this for all “pretend login succeeded” checks.
  static bool get shouldBypassAuth =>
      kDebugMode && devBypassAuthentication;

  /// Matches successful **login** navigation (`EmailLoginView` / social).
  static void navigateAfterLoggedIn() {
    final done = LocalStorageService().getIsOnboardingCompleted();
    Get.offAllNamed(
      done ? Routes.DASHBOARD : Routes.ONBOARDING_WELCOME,
    );
  }

  /// Matches successful **register** navigation (`EmailSignupView`).
  static void navigateAfterRegistered() {
    Get.offAllNamed(Routes.ONBOARDING_WELCOME);
  }
}
