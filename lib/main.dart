import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/translations/app_translations.dart';
import 'app/core/error_handling/app_release_error_handler.dart';
import 'app/services/local_storage_services/local_storage_services.dart';
import 'app/services/settings_service/settings_service.dart';
import 'app/services/task_service.dart';
import 'app/services/api_progress_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/core/widgets/app_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  installAppReleaseErrorHandlers();
  await LocalStorageService.init();
  await Get.putAsync<SettingsService>(() async => SettingsService().init());
  Get.put(TaskService());
  Get.put(ApiProgressService());
  final initial = Routes.SPLASH;
  runApp(MyApp(initial: initial));
}

class MyApp extends StatelessWidget {
  final String initial;
  const MyApp({super.key, required this.initial});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Taskerer",
            initialRoute: initial,
            getPages: AppPages.routes,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            translations: AppTranslations(),
            locale: settings.locale.value,
            fallbackLocale: const Locale('en'),
            builder: (context, child) {
              // This builder ensures that we can apply global responsive adjustments
              // or handle safe areas if needed for all screens.
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  // Clamp text scaling for better control across devices
                  textScaler: MediaQuery.of(
                    context,
                  ).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.2),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    child!,
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: TaskererApiProgressHost(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
