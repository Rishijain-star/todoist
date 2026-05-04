import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_welcome_view.dart';
import '../modules/onboarding/views/onboarding_name_view.dart';
import '../modules/onboarding/views/onboarding_goal_view.dart';
import '../modules/onboarding/views/onboarding_reminders_view.dart';
import '../modules/auth_welcome/views/auth_welcome_view.dart';
import '../modules/auth_email/views/email_login_view.dart';
import '../modules/auth_email/views/email_signup_view.dart';
import '../modules/inbox/views/inbox_view.dart';
import '../modules/today/views/today_view.dart';
import '../modules/upcoming/views/upcoming_view.dart';
import '../modules/browse/views/browse_view.dart';
import '../modules/browse/views/templates_view.dart';
import '../modules/browse/views/templates_list_view.dart';
import '../modules/browse/views/project_calendar_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/team/views/team_view.dart';
import '../modules/reports/views/reports_view.dart';
import '../modules/admin/views/admin_view.dart';
import '../modules/inbox/bindings/inbox_binding.dart';
import '../modules/today/bindings/today_binding.dart';
import '../modules/upcoming/bindings/upcoming_binding.dart';
import '../modules/browse/bindings/browse_binding.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/team/bindings/team_binding.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(name: _Paths.AUTH_WELCOME, page: () => const AuthWelcomeView()),
    GetPage(name: _Paths.AUTH_EMAIL_LOGIN, page: () => const EmailLoginView()),
    GetPage(
      name: _Paths.AUTH_FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(
      name: _Paths.AUTH_EMAIL_SIGNUP,
      page: () => const EmailSignupView(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_WELCOME,
      page: () => const OnboardingWelcomeView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_NAME,
      page: () => const OnboardingNameView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_GOAL,
      page: () => const OnboardingGoalView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_REMINDERS,
      page: () => const OnboardingRemindersView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.INBOX,
      page: () => const InboxView(),
      binding: InboxBinding(),
    ),
    GetPage(
      name: _Paths.TODAY,
      page: () => const TodayView(),
      binding: TodayBinding(),
    ),
    GetPage(
      name: _Paths.UPCOMING,
      page: () => const UpcomingView(),
      binding: UpcomingBinding(),
    ),
    GetPage(
      name: _Paths.BROWSE,
      page: () => const BrowseView(),
      binding: BrowseBinding(),
    ),
    GetPage(
      name: _Paths.BROWSE_PROJECTS,
      page: () => const MyProjectsView(),
      binding: BrowseBinding(),
    ),
    GetPage(
      name: _Paths.BROWSE_ADD_PROJECT,
      page: () => const AddProjectView(),
      binding: BrowseBinding(),
    ),
    GetPage(
      name: _Paths.BROWSE_TEMPLATES,
      page: () => const TemplatesListView(),
      binding: BrowseBinding(),
    ),
    GetPage(
      name: _Paths.BROWSE_CALENDAR,
      page: () => const ProjectCalendarView(),
      binding: BrowseBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.TEAM,
      page: () => const TeamView(),
      binding: TeamBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(name: _Paths.REPORTS, page: () => const ReportsView()),
    GetPage(name: _Paths.ADMIN, page: () => const AdminView()),
  ];
}
