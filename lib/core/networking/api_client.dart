import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../env/env_config.dart';
import '../local/secure_storage.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;
}

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage = SecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await Dio().post(
            '${EnvConfig.apiBaseUrl}/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          final newAccessToken = response.data['accessToken'];
          final newRefreshToken = response.data['refreshToken'];

          await _storage.saveAccessToken(newAccessToken);
          await _storage.saveRefreshToken(newRefreshToken);

          // Retry original request
          final opts = Options(
            method: err.requestOptions.method,
            headers: {
              ...err.requestOptions.headers,
              'Authorization': 'Bearer $newAccessToken',
            },
          );

          final retryResponse = await Dio().request(
            err.requestOptions.path,
            options: opts,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );

          return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh failed, clear tokens
          await _storage.clearTokens();
        }
      }
    }
    handler.next(err);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
