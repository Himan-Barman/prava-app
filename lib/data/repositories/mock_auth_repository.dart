import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Mock implementation of AuthRepository for development.
/// 
/// TODO: Replace with real implementation when backend is ready.
/// Integration points:
/// - Connect to real API endpoints (see core/constants/api_constants.dart)
/// - Handle JWT token storage and refresh
/// - Implement proper error handling
class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;

  // Mock users for testing
  final _mockUser = UserModel(
    id: 'user-1',
    username: 'testuser',
    email: 'test@prava.app',
    displayName: 'Test User',
    avatarUrl: null,
    bio: 'This is a test user',
    status: 'Available',
    isOnline: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  @override
  Future<void> sendOtp(String email) async {
    // TODO: Call API endpoint ApiConstants.sendOtp
    await Future.delayed(const Duration(seconds: 1));
    // Simulate sending OTP
    print('Mock: OTP sent to $email (code: 123456)');
  }

  @override
  Future<UserModel> verifyOtp(String email, String code) async {
    // TODO: Call API endpoint ApiConstants.verifyOtp
    await Future.delayed(const Duration(seconds: 1));
    
    // Accept any code for mock
    _currentUser = _mockUser;
    return _mockUser;
  }

  @override
  Future<void> sendMagicLink(String email) async {
    // TODO: Call API endpoint ApiConstants.magicLink
    await Future.delayed(const Duration(seconds: 1));
    print('Mock: Magic link sent to $email');
  }

  @override
  Future<UserModel> verifyMagicLink(String token) async {
    // TODO: Call API endpoint to verify magic link token
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = _mockUser;
    return _mockUser;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // TODO: Get user from stored token or API
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    // TODO: Call API endpoint ApiConstants.logout
    // TODO: Clear stored tokens
    _currentUser = null;
  }

  @override
  Future<bool> isAuthenticated() async {
    // TODO: Check if valid token exists
    return _currentUser != null;
  }
}
