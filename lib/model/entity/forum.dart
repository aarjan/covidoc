import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forum.g.dart';

@JsonSerializable()
class Forum extends Equatable {
  const Forum({
    this.id,
    this.title,
    this.category,
    this.timestamp,
    this.addedById,
    this.addedByType,
    this.addedByName,
    this.ansCount = 0,
    this.addedByAvatar,
    this.isPinned = false,
    this.tags = const <String>[],
    this.imageUrls = const <String>[],
    this.recentUsersAvatar = const <String>[],
  });

  final String id;
  final String title;
  final String category;
  final String addedById;
  final DateTime timestamp;
  final String addedByType;
  final String addedByName;
  final String addedByAvatar;

  @JsonKey(defaultValue: 0)
  final int ansCount;

  @JsonKey(defaultValue: false)
  final bool isPinned;

  @JsonKey(defaultValue: <String>[])
  final List<String> imageUrls;

  @JsonKey(defaultValue: <String>[])
  final List<String> tags;

  @JsonKey(defaultValue: <String>[])
  final List<String> recentUsersAvatar;

  @override
  List<Object> get props => [
        id,
        tags,
        title,
        isPinned,
        ansCount,
        category,
        imageUrls,
        timestamp,
        addedById,
        addedByName,
        addedByType,
        addedByAvatar,
        recentUsersAvatar
      ];

  factory Forum.fromJson(Map<String, dynamic> json) => _$ForumFromJson(json);

  Map<String, dynamic> toJson() => _$ForumToJson(this);

  Forum copyWith({
    String id,
    int ansCount,
    String title,
    bool isPinned,
    String category,
    String addedById,
    List<String> tags,
    DateTime timestamp,
    String addedByName,
    String addedByType,
    String addedByAvatar,
    List<String> imageUrls,
    List<String> recentUsersAvatar,
  }) {
    return Forum(
      id: id ?? this.id,
      tags: tags ?? this.tags,
      title: title ?? this.title,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
      ansCount: ansCount ?? this.ansCount,
      imageUrls: imageUrls ?? this.imageUrls,
      timestamp: timestamp ?? this.timestamp,
      addedById: addedById ?? this.addedById,
      addedByName: addedByName ?? this.addedByName,
      addedByType: addedByType ?? this.addedByType,
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
    this.imageUrls,
    this.timestamp,
    this.questionId,
    this.addedById,
    this.addedByName,
    this.addedByType,
    this.isBestAnswer,
    this.addedByAvatar,
  });

  final String id;
  final String title;
  final String addedById;
  final String imageUrls;
  final String questionId;
  final bool isBestAnswer;
  final DateTime timestamp;
  final String addedByName;
  final String addedByType;
  final String addedByAvatar;

  @override
  List<Object> get props => [
        id,
        title,
        timestamp,
        imageUrls,
        addedById,
        questionId,
        addedByName,
        addedByType,
        isBestAnswer,
        addedByAvatar
      ];

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);

  Answer copyWith({
    String id,
    String title,
    String addedById,
    String imageUrls,
    String questionId,
    bool isBestAnswer,
    DateTime timestamp,
    String addedByName,
    String addedByType,
    String addedByAvatar,
  }) {
    return Answer(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrls: imageUrls ?? this.imageUrls,
      addedById: addedById ?? this.addedById,
      timestamp: timestamp ?? this.timestamp,
      questionId: questionId ?? this.questionId,
      addedByType: addedByType ?? this.addedByType,
      addedByName: addedByName ?? this.addedByName,
      isBestAnswer: isBestAnswer ?? this.isBestAnswer,
      addedByAvatar: addedByAvatar ?? this.addedByAvatar,
    );
  }
}
