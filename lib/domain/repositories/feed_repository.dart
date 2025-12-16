import '../../data/models/post_model.dart';
import '../../data/models/comment_model.dart';

/// Repository interface for feed operations.
abstract class FeedRepository {
  /// Get feed posts with pagination
  Future<List<PostModel>> getFeed({int page = 1, int limit = 20});

  /// Get a single post by ID
  Future<PostModel> getPost(String postId);

  /// Create a new post
  Future<PostModel> createPost(String content, {List<String>? imageUrls});

  /// Delete a post
  Future<void> deletePost(String postId);

  /// Like/unlike a post
  Future<void> toggleLike(String postId, bool like);

  /// Repost a post
  Future<PostModel> repost(String postId, {String? comment});

  /// Get comments for a post
  Future<List<CommentModel>> getComments(String postId,
      {int page = 1, int limit = 20});

  /// Add a comment to a post
  Future<CommentModel> addComment(String postId, String content);

  /// Delete a comment
  Future<void> deleteComment(String commentId);

  /// Like/unlike a comment
  Future<void> toggleCommentLike(String commentId, bool like);
}
