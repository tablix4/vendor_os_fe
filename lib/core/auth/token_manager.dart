import '../../features/authentication/data/models/refresh_token_request.dart';
import '../../features/authentication/data/services/auth_service.dart';
import '../storage/storage_service.dart';

class TokenManager {
  TokenManager._();

  static final AuthService _authService = AuthService();

  static Future<bool> refreshTokens() async {
    final refreshToken = await StorageService.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _authService.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      await StorageService.saveAccessToken(response.data.accessToken);

      await StorageService.saveRefreshToken(response.data.refreshToken);

      return true;
    } catch (_) {
      await StorageService.clearAll();
      return false;
    }
  }
}
