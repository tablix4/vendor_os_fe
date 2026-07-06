import '../storage/storage_service.dart';

import '../../features/authentication/data/services/auth_service.dart';

class AuthManager {
  AuthManager._();

  static final AuthService _authService = AuthService();

  static Future<void> logout() async {
    final token = await StorageService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      try {
        await _authService.logout(token);
      } catch (_) {
        // Ignore server failure and clear local session anyway.
      }
    }

    await StorageService.clearAll();
  }
}
