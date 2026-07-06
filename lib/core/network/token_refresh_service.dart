import '../../features/authentication/data/models/refresh_token_request.dart';
import '../../features/authentication/data/services/auth_service.dart';

import '../storage/storage_service.dart';

class TokenRefreshService {
  TokenRefreshService._();

  static final AuthService _authService = AuthService();

  static Future<bool> refreshToken() async {
    try {
      final refreshToken = await StorageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _authService.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      await StorageService.saveAccessToken(response.data.accessToken);

      await StorageService.saveRefreshToken(response.data.refreshToken);

      return true;
    } catch (_) {
      return false;
    }
  }
}
