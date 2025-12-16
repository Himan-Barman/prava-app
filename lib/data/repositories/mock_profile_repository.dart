import '../../domain/repositories/profile_repository.dart';
import '../models/user_model.dart';

/// Mock implementation of ProfileRepository for development.
class MockProfileRepository implements ProfileRepository {
  UserModel _currentUser = UserModel(
    id: 'user-1',
    username: 'testuser',
    email: 'test@prava.app',
    displayName: 'Test User',
    bio: 'This is my bio. I love using Prava!',
    status: 'Available',
    isOnline: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  @override
  Future<UserModel> getProfile() async {
    // TODO: Call API endpoint ApiConstants.profile
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentUser;
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    // TODO: Call API endpoint ApiConstants.userProfile(userId)
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock user
    return UserModel(
      id: userId,
      username: 'user$userId',
      email: 'user$userId@prava.app',
      displayName: 'User $userId',
      bio: 'This is a mock user profile',
      isOnline: false,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    );
  }

  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? bio,
    String? status,
  }) async {
    // TODO: Call API endpoint ApiConstants.updateProfile
    await Future.delayed(const Duration(milliseconds: 800));
    
    _currentUser = _currentUser.copyWith(
      displayName: displayName ?? _currentUser.displayName,
      bio: bio ?? _currentUser.bio,
      status: status ?? _currentUser.status,
    );
    
    return _currentUser;
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    // TODO: Call API endpoint ApiConstants.uploadAvatar
    await Future.delayed(const Duration(seconds: 2));
    
    // Return mock URL
    return 'https://via.placeholder.com/150';
  }

  @override
  Future<UserModel> updateAvatar(String avatarUrl) async {
    // TODO: Update user avatar via API
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentUser = _currentUser.copyWith(avatarUrl: avatarUrl);
    return _currentUser;
  }
}
