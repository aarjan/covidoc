import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forum.g.dart';

@JsonSerializable()
class Forum extends Equatable {
  const Forum({
    this.id,
    this.title,
    this.addedBy,
    this.ansCount,
    this.imageUrls,
    this.timestamp,
    this.addedByUserId,
    this.addedByAvatar,
    this.tags = const <String>[],
    this.recentUsersAvatar = const <String>[],
  });

  final String id;
  final String title;
  final String addedBy;
  final String ansCount;
  final String imageUrls;
  final DateTime timestamp;
  final String addedByUserId;
  final String addedByAvatar;

  @JsonKey(defaultValue: <String>[])
  final List<String> tags;
  @JsonKey(defaultValue: <String>[])
  final List<String> recentUsersAvatar;

  @override
  List<Object> get props => [
        id,
        tags,
        title,
        addedBy,
        ansCount,
        imageUrls,
        imageUrls,
        timestamp,
        addedByAvatar,
        addedByUserId,
        recentUsersAvatar
      ];

  factory Forum.fromJson(Map<String, dynamic> json) => _$ForumFromJson(json);

  Map<String, dynamic> toJson() => _$ForumToJson(this);

  Forum copyWith({
    String id,
    String title,
    String addedBy,
    String ansCount,
    String imageUrls,
    List<String> tags,
    DateTime timestamp,
    String addedByUserId,
    String addedByAvatar,
    List<String> recentUsersAvatar,
  }) {
    return Forum(
      id: id ?? this.id,
      tags: tags ?? this.tags,
      title: title ?? this.title,
      addedBy: addedBy ?? this.addedBy,
      ansCount: ansCount ?? this.ansCount,
      imageUrls: imageUrls ?? this.imageUrls,
      timestamp: timestamp ?? this.timestamp,
      addedByUserId: addedByUserId ?? this.addedByUserId,
      addedByAvatar: addedByAvatar ?? this.addedByAvatar,
      recentUsersAvatar: recentUsersAvatar ?? this.recentUsersAvatar,
    );
  }
}

@JsonSerializable()
class Answer extends Equatable {
  const Answer({
    this.id,
    this.title,
    this.addedBy,
    this.imageUrls,
    this.questionId,
    this.addedByUserId,
  });

  final String id;
  final String title;
  final String addedBy;
  final String imageUrls;
  final String questionId;
  final String addedByUserId;

  @override
  List<Object> get props =>
      [id, questionId, title, addedByUserId, addedBy, imageUrls];

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);

  Answer copyWith({
    String id,
    String title,
    String addedBy,
    String addedByUserId,
    String imageUrls,
    String questionId,
  }) {
    return Answer(
      id: id ?? this.id,
      title: title ?? this.title,
      addedBy: addedBy ?? this.addedBy,
      addedByUserId: addedByUserId ?? this.addedByUserId,
      imageUrls: imageUrls ?? this.imageUrls,
      questionId: questionId ?? this.questionId,
    );
  }
}
