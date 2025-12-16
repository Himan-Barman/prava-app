import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/user_model.dart';

/// Repository interface for chat operations.
abstract class ChatRepository {
  /// Get all conversations for current user
  Future<List<ConversationModel>> getConversations();

  /// Get a single conversation by ID
  Future<ConversationModel> getConversation(String conversationId);

  /// Get messages for a conversation with pagination
  Future<List<MessageModel>> getMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  });

  /// Send a message in a conversation
  Future<MessageModel> sendMessage(
    String conversationId,
    String content, {
    MessageType type = MessageType.text,
    String? mediaUrl,
  });

  /// Mark messages as read
  Future<void> markAsRead(String conversationId);

  /// Create a new direct conversation
  Future<ConversationModel> createDirectConversation(String userId);

  /// Create a new group conversation
  Future<ConversationModel> createGroupConversation(
    String name,
    List<String> userIds,
  );

  /// Add member to group
  Future<void> addGroupMember(String conversationId, String userId);

  /// Remove member from group
  Future<void> removeGroupMember(String conversationId, String userId);

  /// Leave group
  Future<void> leaveGroup(String conversationId);

  /// Update group info
  Future<ConversationModel> updateGroupInfo(
    String conversationId, {
    String? name,
    String? avatarUrl,
  });

  /// Get typing status stream
  Stream<Map<String, bool>> getTypingStatus(String conversationId);

  /// Send typing indicator
  Future<void> sendTypingIndicator(String conversationId, bool isTyping);
}
