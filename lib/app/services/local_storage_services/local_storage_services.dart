import 'package:shared_preferences/shared_preferences.dart';
import '../secure_token_service/secure_token_service.dart';

class LocalStorageService {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // ===================== AUTH & USER =====================
  Future<void> setAuthToken(String token) =>
      sharedPreferences!.setString('authToken', token);
  String getAuthToken() => sharedPreferences!.getString('authToken') ?? '';

  Future<void> setUserId(String id) =>
      sharedPreferences!.setString('userId', id);
  String getUserId() => sharedPreferences!.getString('userId') ?? '';

  Future<void> setUserName(String name) =>
      sharedPreferences!.setString('userName', name);
  String getUserName() => sharedPreferences!.getString('userName') ?? '';
  Future<void> setFirstName(String firstName) =>
      sharedPreferences!.setString('firstName', firstName);
  String getFirstName() => sharedPreferences!.getString('firstName') ?? '';
  Future<void> setLastName(String lastName) =>
      sharedPreferences!.setString('lastName', lastName);
  String getLastName() => sharedPreferences!.getString('lastName') ?? '';

  Future<void> setEmailId(String email) =>
      sharedPreferences!.setString('userEmail', email);
  String getEmailId() => sharedPreferences!.getString('userEmail') ?? '';

  Future<void> setIsOnboardingCompleted(bool value) =>
      sharedPreferences!.setBool('isOnboardingCompleted', value);
  bool getIsOnboardingCompleted() =>
      sharedPreferences!.getBool('isOnboardingCompleted') ?? false;
  Future<void> setHasSeenSplash(bool value) =>
      sharedPreferences!.setBool('hasSeenSplash', value);
  bool getHasSeenSplash() =>
      sharedPreferences!.getBool('hasSeenSplash') ?? false;

  // ===================== LOCATION =====================
  Future<void> setLatitude(String lat) =>
      sharedPreferences!.setString('latitude', lat);
  String? getLatitude() => sharedPreferences!.getString('latitude');

  Future<void> setLongitude(String lng) =>
      sharedPreferences!.setString('longitude', lng);
  String? getLongitude() => sharedPreferences!.getString('longitude');

  Future<void> setAddress(String address) =>
      sharedPreferences!.setString('address', address);
  String? getAddress() => sharedPreferences!.getString('address');

  Future<void> setCountry(String country) =>
      sharedPreferences!.setString('country', country);
  String getCountry() => sharedPreferences!.getString('country') ?? '';
  Future<void> clearCountry() async {
    await sharedPreferences!.remove('country');
  }

  Future<void> setCity(String country) =>
      sharedPreferences!.setString('setCity', country);
  String getCity() => sharedPreferences!.getString('setCity') ?? '';

  Future<void> setPostalCode(String code) =>
      sharedPreferences!.setString('postalCode', code);
  String getPostalCode() => sharedPreferences!.getString('postalCode') ?? '';

  Future<void> setState(String setState) =>
      sharedPreferences!.setString('setState', setState);
  String getState() => sharedPreferences!.getString('setState') ?? '';

  // ===================== LOGIN STATUS =====================
  bool isLoggedIn() => getAuthToken().isNotEmpty;

  /// Cold-start session check: SharedPreferences token **or** secure storage.
  /// Matches [ApiClient] so splash routing works if secure store is broken but
  /// prefs still hold the token from login/register.
  Future<bool> hasAuthSession() async {
    if (getAuthToken().isNotEmpty) return true;
    return (await SecureTokenService().getAuthToken()).isNotEmpty;
  }

  // ===================== THEME & LANGUAGE =====================
  Future<void> setThemeMode(String mode) =>
      sharedPreferences!.setString('themeMode', mode);
  String getThemeMode() =>
      sharedPreferences!.getString('themeMode') ?? 'system';
  Future<void> setLanguageCode(String code) =>
      sharedPreferences!.setString('languageCode', code);
  String getLanguageCode() =>
      sharedPreferences!.getString('languageCode') ?? 'en';

  // ===================== LOGOUT =====================
  Future<void> logout() async {
    await sharedPreferences!.clear();
    await SecureTokenService().clearToken();
  }
}
