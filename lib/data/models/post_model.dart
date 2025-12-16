import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String id,
    required String content,
    required UserModel author,
    @Default([]) List<String> imageUrls,
    @Default(0) int likesCount,
    @Default(0) int commentsCount,
    @Default(0) int repostsCount,
    @Default(false) bool isLikedByMe,
    @Default(false) bool isRepostedByMe,
    String? repostOf,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
