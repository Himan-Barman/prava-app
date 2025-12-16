import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_api_service.dart';
import '../domain/user_model.dart';
import '../../../core/local/secure_storage.dart';
import '../../../core/networking/websocket_client.dart';

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthApiService _authApi;
  final SecureStorage _storage;
  final WebSocketClient _wsClient;

  AuthController(this._authApi, this._storage, this._wsClient)
      : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final token = await _storage.getAccessToken();
      if (token != null) {
        // TODO: Fetch user profile
        state = const AsyncValue.data(null);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> checkUsernameAvailability(String username) async {
    return await _authApi.checkUsernameAvailability(username);
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authApi.register(
        email: email,
        username: username,
        password: password,
        displayName: displayName,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authApi.login(email: email, password: password);
      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);
      await _storage.saveUserId(response.user.id);
      await _wsClient.connect();
      state = AsyncValue.data(response.user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String code,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authApi.verifyOtp(email: email, code: code);
      await _storage.saveAccessToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);
      await _storage.saveUserId(response.user.id);
      await _wsClient.connect();
      state = AsyncValue.data(response.user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> resendOtp(String email) async {
    await _authApi.resendOtp(email);
  }

  Future<void> logout() async {
    await _storage.clearTokens();
    _wsClient.disconnect();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  final authApi = ref.watch(authApiServiceProvider);
  final wsClient = ref.watch(webSocketClientProvider);
  return AuthController(authApi, SecureStorage(), wsClient);
});
