import '../../data/models/user_model.dart';

/// Repository interface for authentication operations.
/// 
/// Implementations can be mock (for development) or real (production).
abstract class AuthRepository {
  /// Send OTP to email for authentication
  Future<void> sendOtp(String email);

  /// Verify OTP code
  Future<UserModel> verifyOtp(String email, String code);

  /// Send magic link to email
  Future<void> sendMagicLink(String email);

  /// Verify magic link token
  Future<UserModel> verifyMagicLink(String token);

  /// Get current authenticated user
  Future<UserModel?> getCurrentUser();

  /// Logout current user
  Future<void> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
