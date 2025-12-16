import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String postId,
    required String content,
    required UserModel author,
    @Default(0) int likesCount,
    @Default(false) bool isLikedByMe,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
