import '../../domain/repositories/feed_repository.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/user_model.dart';

/// Mock implementation of FeedRepository for development.
/// 
/// TODO: Replace with real implementation when backend is ready.
class MockFeedRepository implements FeedRepository {
  final List<PostModel> _posts = [];
  final List<CommentModel> _comments = [];

  MockFeedRepository() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final mockUser1 = UserModel(
      id: 'user-1',
      username: 'alice',
      email: 'alice@prava.app',
      displayName: 'Alice Johnson',
      avatarUrl: null,
      isOnline: true,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    );

    final mockUser2 = UserModel(
      id: 'user-2',
      username: 'bob',
      email: 'bob@prava.app',
      displayName: 'Bob Smith',
      avatarUrl: null,
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    );

    _posts.addAll([
      PostModel(
        id: 'post-1',
        content: 'Hello Prava! This is my first post on this amazing platform.',
        author: mockUser1,
        likesCount: 42,
        commentsCount: 5,
        repostsCount: 2,
        isLikedByMe: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PostModel(
        id: 'post-2',
        content: 'Just built an amazing new feature! Check it out.',
        author: mockUser2,
        likesCount: 128,
        commentsCount: 15,
        repostsCount: 10,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      PostModel(
        id: 'post-3',
        content: 'What a beautiful day! ☀️',
        author: mockUser1,
        likesCount: 23,
        commentsCount: 3,
        repostsCount: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);

    _comments.addAll([
      CommentModel(
        id: 'comment-1',
        postId: 'post-1',
        content: 'Welcome to Prava!',
        author: mockUser2,
        likesCount: 5,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      CommentModel(
        id: 'comment-2',
        postId: 'post-1',
        content: 'Great to have you here!',
        author: mockUser1,
        likesCount: 3,
        isLikedByMe: true,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ]);
  }

  @override
  Future<List<PostModel>> getFeed({int page = 1, int limit = 20}) async {
    // TODO: Call API endpoint ApiConstants.posts with pagination
    await Future.delayed(const Duration(seconds: 1));
    
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= _posts.length) return [];
    
    return _posts.sublist(
      startIndex,
      endIndex > _posts.length ? _posts.length : endIndex,
    );
  }

  @override
  Future<PostModel> getPost(String postId) async {
    // TODO: Call API endpoint ApiConstants.postDetail(postId)
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _posts.firstWhere(
      (post) => post.id == postId,
      orElse: () => throw Exception('Post not found'),
    );
  }

  @override
  Future<PostModel> createPost(String content, {List<String>? imageUrls}) async {
    // TODO: Call API endpoint ApiConstants.createPost
    await Future.delayed(const Duration(seconds: 1));
    
    final newPost = PostModel(
      id: 'post-${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      author: UserModel(
        id: 'user-1',
        username: 'testuser',
        email: 'test@prava.app',
        displayName: 'Test User',
        createdAt: DateTime.now(),
      ),
      imageUrls: imageUrls ?? [],
      createdAt: DateTime.now(),
    );
    
    _posts.insert(0, newPost);
    return newPost;
  }

  @override
  Future<void> deletePost(String postId) async {
    // TODO: Call API endpoint to delete post
    await Future.delayed(const Duration(milliseconds: 500));
    _posts.removeWhere((post) => post.id == postId);
  }

  @override
  Future<void> toggleLike(String postId, bool like) async {
    // TODO: Call API endpoint ApiConstants.postReactions(postId)
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        isLikedByMe: like,
        likesCount: like ? post.likesCount + 1 : post.likesCount - 1,
      );
    }
  }

  @override
  Future<PostModel> repost(String postId, {String? comment}) async {
    // TODO: Call API endpoint ApiConstants.repost(postId)
    await Future.delayed(const Duration(milliseconds: 500));
    
    final originalPost = await getPost(postId);
    final repost = PostModel(
      id: 'repost-${DateTime.now().millisecondsSinceEpoch}',
      content: comment ?? '',
      author: UserModel(
        id: 'user-1',
        username: 'testuser',
        email: 'test@prava.app',
        displayName: 'Test User',
        createdAt: DateTime.now(),
      ),
      repostOf: postId,
      createdAt: DateTime.now(),
    );
    
    _posts.insert(0, repost);
    
    // Update original post repost count
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        repostsCount: _posts[index].repostsCount + 1,
        isRepostedByMe: true,
      );
    }
    
    return repost;
  }

  @override
  Future<List<CommentModel>> getComments(
    String postId, {
    int page = 1,
    int limit = 20,
  }) async {
    // TODO: Call API endpoint ApiConstants.postComments(postId)
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _comments.where((comment) => comment.postId == postId).toList();
  }

  @override
  Future<CommentModel> addComment(String postId, String content) async {
    // TODO: Call API endpoint to add comment
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newComment = CommentModel(
      id: 'comment-${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      content: content,
      author: UserModel(
        id: 'user-1',
        username: 'testuser',
        email: 'test@prava.app',
        displayName: 'Test User',
        createdAt: DateTime.now(),
      ),
      createdAt: DateTime.now(),
    );
    
    _comments.insert(0, newComment);
    
    // Update post comment count
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        commentsCount: _posts[index].commentsCount + 1,
      );
    }
    
    return newComment;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    // TODO: Call API endpoint to delete comment
    await Future.delayed(const Duration(milliseconds: 300));
    _comments.removeWhere((comment) => comment.id == commentId);
  }

  @override
  Future<void> toggleCommentLike(String commentId, bool like) async {
    // TODO: Call API endpoint to like/unlike comment
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _comments.indexWhere((comment) => comment.id == commentId);
    if (index != -1) {
      final comment = _comments[index];
      _comments[index] = comment.copyWith(
        isLikedByMe: like,
        likesCount: like ? comment.likesCount + 1 : comment.likesCount - 1,
      );
    }
  }
}
