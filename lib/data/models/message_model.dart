import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

enum MessageType { text, image, video, audio, file }

enum MessageStatus { sending, sent, delivered, read, failed }

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String content,
    @Default(MessageType.text) MessageType type,
    @Default(MessageStatus.sending) MessageStatus status,
    String? mediaUrl,
    @Default(false) bool isEncrypted,
    required DateTime createdAt,
    DateTime? readAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
