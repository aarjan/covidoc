import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forum.g.dart';

@JsonSerializable()
class Forum extends Equatable {
  const Forum({
    this.id,
    this.title,
    this.userId,
    this.addedBy,
    this.documents,
  });

  final String id;
  final String title;
  final String userId;
  final String addedBy;
  final String documents;

  @override
  List<Object> get props => [id, title, userId, addedBy, documents];

  factory Forum.fromJson(Map<String, dynamic> json) => _$ForumFromJson(json);

  Map<String, dynamic> toJson() => _$ForumToJson(this);

  Forum copyWith({
    String id,
    String title,
    String userId,
    String addedBy,
    String documents,
  }) {
    return Forum(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      addedBy: addedBy ?? this.addedBy,
      documents: documents ?? this.documents,
    );
  }
}

@JsonSerializable()
class Answer extends Equatable {
  const Answer({
    this.id,
    this.title,
    this.userId,
    this.addedBy,
    this.documents,
    this.questionId,
  });

  final String id;
  final String title;
  final String addedBy;
  final String userId;
  final String documents;
  final String questionId;

  @override
  List<Object> get props => [id, questionId, title, addedBy, userId, documents];

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);

  Answer copyWith({
    String id,
    String title,
    String userId,
    String addedBy,
    String documents,
    String questionId,
  }) {
    return Answer(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      addedBy: addedBy ?? this.addedBy,
      documents: documents ?? this.documents,
      questionId: questionId ?? this.questionId,
    );
  }
}
