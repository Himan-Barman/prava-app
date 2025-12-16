import 'dart:async';
import '../../domain/repositories/chat_repository.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

/// Mock implementation of ChatRepository for development.
class MockChatRepository implements ChatRepository {
  final List<ConversationModel> _conversations = [];
  final List<MessageModel> _messages = [];
  final _typingController = StreamController<Map<String, bool>>.broadcast();

  MockChatRepository() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final mockUser1 = UserModel(
      id: 'user-2',
      username: 'alice',
      email: 'alice@prava.app',
      displayName: 'Alice Johnson',
      isOnline: true,
      createdAt: DateTime.now(),
    );

    final mockUser2 = UserModel(
      id: 'user-3',
      username: 'bob',
      email: 'bob@prava.app',
      displayName: 'Bob Smith',
      isOnline: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
      createdAt: DateTime.now(),
    );

    // Create mock messages
    _messages.addAll([
      MessageModel(
        id: 'msg-1',
        conversationId: 'conv-1',
        senderId: 'user-2',
        content: 'Hey! How are you?',
        status: MessageStatus.read,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        readAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MessageModel(
        id: 'msg-2',
        conversationId: 'conv-1',
        senderId: 'user-1',
        content: 'I\'m doing great! Thanks for asking.',
        status: MessageStatus.read,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        readAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MessageModel(
        id: 'msg-3',
        conversationId: 'conv-1',
        senderId: 'user-2',
        content: 'Want to grab coffee later?',
        status: MessageStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ]);

    // Create mock conversations
    _conversations.addAll([
      ConversationModel(
        id: 'conv-1',
        type: ConversationType.direct,
        participants: [mockUser1],
        lastMessage: _messages.last,
        unreadCount: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ConversationModel(
        id: 'conv-2',
        name: 'Project Team',
        type: ConversationType.group,
        participants: [mockUser1, mockUser2],
        lastMessage: MessageModel(
          id: 'msg-4',
          conversationId: 'conv-2',
          senderId: 'user-3',
          content: 'Meeting at 3pm tomorrow',
          status: MessageStatus.read,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          readAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ]);
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    // TODO: Call API endpoint ApiConstants.conversations
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_conversations);
  }

  @override
  Future<ConversationModel> getConversation(String conversationId) async {
    // TODO: Call API endpoint ApiConstants.conversationDetail
    await Future.delayed(const Duration(milliseconds: 500));
    return _conversations.firstWhere((conv) => conv.id == conversationId);
  }

  @override
  Future<List<MessageModel>> getMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  }) async {
    // TODO: Call API endpoint ApiConstants.conversationMessages
    await Future.delayed(const Duration(milliseconds: 800));
    
    return _messages
        .where((msg) => msg.conversationId == conversationId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<MessageModel> sendMessage(
    String conversationId,
    String content, {
    MessageType type = MessageType.text,
    String? mediaUrl,
  }) async {
    // TODO: Call API endpoint ApiConstants.sendMessage
    // Simulate optimistic update
    final newMessage = MessageModel(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'user-1',
      content: content,
      type: type,
      status: MessageStatus.sending,
      mediaUrl: mediaUrl,
      createdAt: DateTime.now(),
    );
    
    _messages.add(newMessage);
    
    // Simulate sending delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Update status to sent
    final index = _messages.indexWhere((msg) => msg.id == newMessage.id);
    if (index != -1) {
      _messages[index] = newMessage.copyWith(status: MessageStatus.sent);
    }
    
    // Update conversation last message
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
        lastMessage: _messages[index],
        updatedAt: DateTime.now(),
      );
    }
    
    return _messages[index];
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    // TODO: Call API endpoint ApiConstants.markAsRead
    await Future.delayed(const Duration(milliseconds: 200));
    
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      _conversations[convIndex] = _conversations[convIndex].copyWith(
        unreadCount: 0,
      );
    }
  }

  @override
  Future<ConversationModel> createDirectConversation(String userId) async {
    // TODO: Call API endpoint to create direct conversation
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newConversation = ConversationModel(
      id: 'conv-${DateTime.now().millisecondsSinceEpoch}',
      type: ConversationType.direct,
      participants: [
        UserModel(
          id: userId,
          username: 'newuser',
          email: 'newuser@prava.app',
          displayName: 'New User',
          createdAt: DateTime.now(),
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _conversations.insert(0, newConversation);
    return newConversation;
  }

  @override
  Future<ConversationModel> createGroupConversation(
    String name,
    List<String> userIds,
  ) async {
    // TODO: Call API endpoint to create group conversation
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newConversation = ConversationModel(
      id: 'conv-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: ConversationType.group,
      participants: userIds.map((id) => UserModel(
        id: id,
        username: 'user$id',
        email: 'user$id@prava.app',
        displayName: 'User $id',
        createdAt: DateTime.now(),
      )).toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _conversations.insert(0, newConversation);
    return newConversation;
  }

  @override
  Future<void> addGroupMember(String conversationId, String userId) async {
    // TODO: Call API endpoint to add group member
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final conversation = _conversations[index];
      final newParticipant = UserModel(
        id: userId,
        username: 'user$userId',
        email: 'user$userId@prava.app',
        displayName: 'User $userId',
        createdAt: DateTime.now(),
      );
      
      _conversations[index] = conversation.copyWith(
        participants: [...conversation.participants, newParticipant],
      );
    }
  }

  @override
  Future<void> removeGroupMember(String conversationId, String userId) async {
    // TODO: Call API endpoint to remove group member
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final conversation = _conversations[index];
      _conversations[index] = conversation.copyWith(
        participants: conversation.participants
            .where((p) => p.id != userId)
            .toList(),
      );
    }
  }

  @override
  Future<void> leaveGroup(String conversationId) async {
    // TODO: Call API endpoint to leave group
    await Future.delayed(const Duration(milliseconds: 300));
    _conversations.removeWhere((c) => c.id == conversationId);
  }

  @override
  Future<ConversationModel> updateGroupInfo(
    String conversationId, {
    String? name,
    String? avatarUrl,
  }) async {
    // TODO: Call API endpoint to update group info
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      _conversations[index] = _conversations[index].copyWith(
        name: name ?? _conversations[index].name,
        avatarUrl: avatarUrl ?? _conversations[index].avatarUrl,
      );
      return _conversations[index];
    }
    
    throw Exception('Conversation not found');
  }

  @override
  Stream<Map<String, bool>> getTypingStatus(String conversationId) {
    // TODO: Connect to WebSocket for real-time typing status
    return _typingController.stream;
  }

  @override
  Future<void> sendTypingIndicator(String conversationId, bool isTyping) async {
    // TODO: Send typing indicator via WebSocket
    _typingController.add({conversationId: isTyping});
  }

  void dispose() {
    _typingController.close();
  }
}
