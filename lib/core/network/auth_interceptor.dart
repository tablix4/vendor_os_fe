import 'package:dio/dio.dart';

import '../storage/storage_service.dart';
import '../auth/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio = Dio();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await StorageService.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshed = await TokenManager.refreshTokens();

    if (!refreshed) {
      return handler.next(err);
    }

    final accessToken = await StorageService.getAccessToken();

    final requestOptions = err.requestOptions;

    requestOptions.headers["Authorization"] = "Bearer $accessToken";

    try {
      final response = await _dio.fetch(requestOptions);

      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }
}
