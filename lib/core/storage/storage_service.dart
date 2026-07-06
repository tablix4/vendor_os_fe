import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  StorageService._();

  static const _storage = FlutterSecureStorage();

  static const accessTokenKey = "access_token";
  static const refreshTokenKey = "refresh_token";
  static const tempTokenKey = "temp_token";

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: accessTokenKey, value: token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: refreshTokenKey, value: token);
  }

  static Future<void> saveTempToken(String token) async {
    await _storage.write(key: tempTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    return _storage.read(key: accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: refreshTokenKey);
  }

  static Future<String?> getTempToken() async {
    return _storage.read(key: tempTokenKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<void> clearTempToken() async {
    await _storage.delete(key: tempTokenKey);
  }

  static Future<void> clearAccessToken() async {
    await _storage.delete(key: accessTokenKey);
  }

  static Future<void> clearRefreshToken() async {
    await _storage.delete(key: refreshTokenKey);
  }
}
