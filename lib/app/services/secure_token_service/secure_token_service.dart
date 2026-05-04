import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores the bearer token in encrypted storage.
///
/// Android: [encryptedSharedPreferences] is **off** — EncryptedSharedPreferences
/// (AndroidX Security + Tink) often hits `AEADBadTagException` / Keystore
/// mismatch after updates; the plugin’s legacy Keystore path is more stable for
/// tokens. [resetOnError] wipes corrupt storage so initialization can recover.
///
/// Reads that still fail return '' so callers can fall back to SharedPreferences.
class SecureTokenService {
  static const _keyAuthToken = 'secure_auth_token';

  static final _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: false,
      resetOnError: true,
    ),
  );

  Future<void> setAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  Future<String> getAuthToken() async {
    try {
      final v = await _storage.read(key: _keyAuthToken);
      return v ?? '';
    } catch (e, st) {
      debugPrint('SecureTokenService.getAuthToken failed (clearing key): $e');
      debugPrint('$st');
      try {
        await _storage.delete(key: _keyAuthToken);
      } catch (_) {}
      return '';
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _keyAuthToken);
    } catch (e, st) {
      debugPrint('SecureTokenService.clearToken: $e\n$st');
    }
  }

  Future<bool> isLoggedIn() async {
    return (await getAuthToken()).isNotEmpty;
  }
}
