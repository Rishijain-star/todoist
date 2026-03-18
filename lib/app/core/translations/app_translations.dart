 import 'package:get/get.dart';
 
 class AppTranslations extends Translations {
   @override
   Map<String, Map<String, String>> get keys => {
         'en': {
           'home.title': 'Home',
           'login.title': 'Login',
           'actions.toggle_theme': 'Toggle Theme',
           'actions.change_language': 'Change Language',
           'common.go_home': 'Go to Home',
           'common.back': 'Back',
           'common.try_again': 'Try Again',
         },
         'hi': {
           'home.title': 'होम',
           'login.title': 'लॉगिन',
           'actions.toggle_theme': 'थीम बदलें',
           'actions.change_language': 'भाषा बदलें',
           'common.go_home': 'होम पर जाएं',
           'common.back': 'वापस',
           'common.try_again': 'फिर कोशिश करें',
         },
       };
 }
