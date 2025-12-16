import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';
import 'message_model.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

enum ConversationType { direct, group }

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    String? name,
    String? avatarUrl,
    @Default(ConversationType.direct) ConversationType type,
    @Default([]) List<UserModel> participants,
    MessageModel? lastMessage,
    @Default(0) int unreadCount,
    @Default(false) bool isMuted,
    @Default(false) bool isArchived,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}
