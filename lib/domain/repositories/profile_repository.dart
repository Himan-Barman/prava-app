import '../../data/models/user_model.dart';

/// Repository interface for profile operations.
abstract class ProfileRepository {
  /// Get current user profile
  Future<UserModel> getProfile();

  /// Get another user's profile
  Future<UserModel> getUserProfile(String userId);

  /// Update current user profile
  Future<UserModel> updateProfile({
    String? displayName,
    String? bio,
    String? status,
  });

  /// Upload avatar
  Future<String> uploadAvatar(String filePath);

  /// Update avatar URL
  Future<UserModel> updateAvatar(String avatarUrl);
}
