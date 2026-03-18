 import 'package:flutter_secure_storage/flutter_secure_storage.dart';
 
 class SecureTokenService {
   static const _keyAuthToken = 'secure_auth_token';
   static const _storage = FlutterSecureStorage();
 
   Future<void> setAuthToken(String token) async {
     await _storage.write(key: _keyAuthToken, value: token, aOptions: const AndroidOptions(encryptedSharedPreferences: true));
   }
 
   Future<String> getAuthToken() async {
     final v = await _storage.read(key: _keyAuthToken);
     return v ?? '';
   }
 
   Future<void> clearToken() async {
     await _storage.delete(key: _keyAuthToken);
   }
 
   Future<bool> isLoggedIn() async {
     return (await getAuthToken()).isNotEmpty;
   }
 }
