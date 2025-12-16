import '../../domain/repositories/search_repository.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';

/// Mock implementation of SearchRepository for development.
class MockSearchRepository implements SearchRepository {
  final List<UserModel> _mockUsers = [
    UserModel(
      id: 'user-1',
      username: 'alice',
      email: 'alice@prava.app',
      displayName: 'Alice Johnson',
      bio: 'Software Engineer | Flutter enthusiast',
      isOnline: true,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    UserModel(
      id: 'user-2',
      username: 'bob',
      email: 'bob@prava.app',
      displayName: 'Bob Smith',
      bio: 'Designer & Developer',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    UserModel(
      id: 'user-3',
      username: 'charlie',
      email: 'charlie@prava.app',
      displayName: 'Charlie Brown',
      bio: 'Product Manager',
      isOnline: true,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    UserModel(
      id: 'user-4',
      username: 'diana',
      email: 'diana@prava.app',
      displayName: 'Diana Prince',
      bio: 'UX Designer',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<List<UserModel>> searchUsers(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    // TODO: Call API endpoint ApiConstants.searchUsers
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return _mockUsers.where((user) {
      return user.username.toLowerCase().contains(lowerQuery) ||
          (user.displayName?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  @override
  Future<List<PostModel>> searchPosts(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    // TODO: Call API endpoint ApiConstants.searchPosts
    await Future.delayed(const Duration(milliseconds: 800));
    
    // For now, return empty list as we focus on user search
    return [];
  }
}
