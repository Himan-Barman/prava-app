import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../env/env_config.dart';
import '../local/secure_storage.dart';

class WebSocketClient {
  io.Socket? _socket;
  final SecureStorage _storage = SecureStorage();

  Future<void> connect() async {
    final token = await _storage.getAccessToken();
    if (token == null) return;

    _socket = io.io(
      EnvConfig.wsUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket?.onConnect((_) {
      print('WebSocket connected');
    });

    _socket?.onDisconnect((_) {
      print('WebSocket disconnected');
    });

    _socket?.onConnectError((error) {
      print('WebSocket connection error: $error');
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void joinConversation(String conversationId) {
    _socket?.emit('join_conversation', {'conversationId': conversationId});
  }

  void leaveConversation(String conversationId) {
    _socket?.emit('leave_conversation', {'conversationId': conversationId});
  }

  void startTyping(String conversationId) {
    _socket?.emit('typing_start', {'conversationId': conversationId});
  }

  void stopTyping(String conversationId) {
    _socket?.emit('typing_stop', {'conversationId': conversationId});
  }

  void onNewMessage(Function(dynamic) callback) {
    _socket?.on('new_message', callback);
  }

  void onUserTyping(Function(dynamic) callback) {
    _socket?.on('user_typing', callback);
  }

  void onNotification(Function(dynamic) callback) {
    _socket?.on('notification', callback);
  }

  void off(String event) {
    _socket?.off(event);
  }
}

final webSocketClientProvider = Provider<WebSocketClient>((ref) => WebSocketClient());
