import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/user_model.dart';
import '../../../../core/providers/repository_providers.dart';

/// Auth state
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  final UserModel? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _checkAuthStatus();
  }

  final _authRepository;

  Future<void> _checkAuthStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      // Not authenticated
    }
  }

  Future<void> sendOtp(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.sendOtp(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> verifyOtp(String email, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authRepository.verifyOtp(email, code);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMagicLink(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.sendMagicLink(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState();
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
