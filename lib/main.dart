import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/translations/app_translations.dart';
import 'app/services/local_storage_services/local_storage_services.dart';
import 'app/services/settings_service/settings_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/services/secure_token_service/secure_token_service.dart';
 
 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await LocalStorageService.init();
   await Get.putAsync<SettingsService>(() async => SettingsService().init());
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
      builder: (_, __) {
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: initial,
            getPages: AppPages.routes,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            translations: AppTranslations(),
            locale: settings.locale.value,
            fallbackLocale: const Locale('en'),
          ),
        );
      },
    );
   }
 }
