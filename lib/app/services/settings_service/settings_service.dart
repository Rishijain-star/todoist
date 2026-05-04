 import 'package:flutter/material.dart';
 import 'package:get/get.dart';
 import '../local_storage_services/local_storage_services.dart';
 
 class SettingsService extends GetxService {
   final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
   final Rx<Locale> locale = const Locale('en').obs;
 
   Future<SettingsService> init() async {
     final mode = LocalStorageService().getThemeMode();
     switch (mode) {
       case 'light':
         themeMode.value = ThemeMode.light;
         break;
       case 'dark':
         themeMode.value = ThemeMode.dark;
         break;
       default:
         themeMode.value = ThemeMode.system;
     }
     final lang = LocalStorageService().getLanguageCode();
     locale.value = Locale(lang);
     return this;
   }
 
   void setThemeMode(ThemeMode mode) {
     themeMode.value = mode;
     LocalStorageService().setThemeMode(_encodeThemeMode(mode));
   }
 
   void toggleTheme() {
     if (themeMode.value == ThemeMode.dark) {
       setThemeMode(ThemeMode.light);
     } else {
       setThemeMode(ThemeMode.dark);
     }
   }
 
   void setLanguage(String languageCode) {
     locale.value = Locale(languageCode);
     LocalStorageService().setLanguageCode(languageCode);
   }
 
   String _encodeThemeMode(ThemeMode mode) {
     switch (mode) {
       case ThemeMode.light:
         return 'light';
       case ThemeMode.dark:
         return 'dark';
       default:
         return 'system';
     }
   }
 }
