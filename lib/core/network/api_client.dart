import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'token_refresh_service.dart';
import '../constants/api_constants.dart';
import '../storage/storage_service.dart';

class ApiClient {
  ApiClient._();

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await StorageService.getAccessToken();
              debugPrint("========== API REQUEST ==========");
              debugPrint("URL: ${options.uri}");
              debugPrint("TOKEN: $token");

              if (token != null) {
                options.headers["Authorization"] = "Bearer $token";
              }
              debugPrint("HEADERS: ${options.headers}");
              handler.next(options);
            },
            onError: (e, handler) async {
              debugPrint("========== API ERROR ==========");
              debugPrint("STATUS : ${e.response?.statusCode}");

              if (e.response?.statusCode == 401) {
                debugPrint("401 Received");
                debugPrint("Refreshing Token...");

                final refreshed = await TokenRefreshService.refreshToken();

                if (refreshed) {
                  final accessToken = await StorageService.getAccessToken();

                  final request = e.requestOptions;

                  request.headers["Authorization"] = "Bearer $accessToken";

                  final response = await dio.fetch(request);

                  return handler.resolve(response);
                } else {
                  await StorageService.clearAll();
                }
              }

              handler.next(e);
            },
          ),
        );
}
