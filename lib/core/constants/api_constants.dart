/// API endpoint constants
class ApiConstants {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  static const String magicLink = '/auth/magic-link';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';

  // Feed endpoints
  static const String posts = '/posts';
  static const String createPost = '/posts';
  static String postDetail(String postId) => '/posts/$postId';
  static String postComments(String postId) => '/posts/$postId/comments';
  static String postReactions(String postId) => '/posts/$postId/reactions';
  static String repost(String postId) => '/posts/$postId/repost';

  // Search endpoints
  static const String searchUsers = '/search/users';
  static const String searchPosts = '/search/posts';

  // Chat endpoints
  static const String conversations = '/conversations';
  static String conversationDetail(String conversationId) =>
      '/conversations/$conversationId';
  static String conversationMessages(String conversationId) =>
      '/conversations/$conversationId/messages';
  static String sendMessage(String conversationId) =>
      '/conversations/$conversationId/messages';
  static String markAsRead(String conversationId) =>
      '/conversations/$conversationId/read';

  // Profile endpoints
  static const String profile = '/profile';
  static const String updateProfile = '/profile';
  static String userProfile(String userId) => '/users/$userId';
  static const String uploadAvatar = '/profile/avatar';

  // WebSocket events
  static const String wsConnect = 'connect';
  static const String wsDisconnect = 'disconnect';
  static const String wsNewMessage = 'message:new';
  static const String wsTyping = 'typing';
  static const String wsReadReceipt = 'read';
  static const String wsPresence = 'presence';
}
