import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/networking/api_client.dart';
import '../domain/user_model.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService(this._apiClient);

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _apiClient.dio.post('/auth/register', data: {
        'email': email,
        'username': username,
        'password': password,
        if (displayName != null) 'displayName': displayName,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Registration failed';
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Login failed';
    }
  }

  Future<AuthResponse> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiClient.dio.post('/auth/verify-otp', data: {
        'email': email,
        'code': code,
      });
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Verification failed';
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      await _apiClient.dio.post('/auth/resend-otp', data: {'email': email});
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to resend OTP';
    }
  }

  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await _apiClient.dio.get('/users/check-username/$username');
      return response.data['available'] as bool;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to check username';
    }
  }
}

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthApiService(apiClient);
});
