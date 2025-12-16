import '../../data/models/user_model.dart';
import '../../data/models/post_model.dart';

/// Repository interface for search operations.
abstract class SearchRepository {
  /// Search users by username or display name
  Future<List<UserModel>> searchUsers(String query, {int page = 1, int limit = 20});

  /// Search posts by content
  Future<List<PostModel>> searchPosts(String query, {int page = 1, int limit = 20});
}
