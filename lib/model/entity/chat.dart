import 'package:covidoc/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
@DateTimeConverter()
class Chat extends Equatable {
  const Chat({
    this.id,
    this.docId,
    this.patId,
    this.docName,
    this.patName,
    this.docAvatar,
    this.patAvatar,
    this.requestId,
    this.lastMessage,
    this.lastTimestamp,
    this.patUnreadCount = 0,
    this.docUnreadCount = 0,
  });

  final String id;
  final String docId;
  final String patId;
  final String docName;
  final String patName;
  final String docAvatar;
  final String patAvatar;
  final String requestId;
  final String lastMessage;
  @JsonKey(defaultValue: 0)
  final int patUnreadCount;
  @JsonKey(defaultValue: 0)
  final int docUnreadCount;
  final DateTime lastTimestamp;

  @override
  List<Object> get props => [
        id,
        docId,
        patId,
        docName,
        patName,
        requestId,
        docAvatar,
        patAvatar,
        lastMessage,
        lastTimestamp,
        patUnreadCount,
        docUnreadCount,
      ];

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  Chat copyWith({
    String id,
    String docId,
    String patId,
    String docName,
    String patName,
    String requestId,
    String docAvatar,
    String patAvatar,
    String lastMessage,
    int patUnreadCount,
    int docUnreadCount,
    DateTime lastTimestamp,
  }) {
    return Chat(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      patId: patId ?? this.patId,
      docName: docName ?? this.docName,
      patName: patName ?? this.patName,
      requestId: requestId ?? this.requestId,
      docAvatar: docAvatar ?? this.docAvatar,
      patAvatar: patAvatar ?? this.patAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTimestamp: lastTimestamp ?? this.lastTimestamp,
      patUnreadCount: patUnreadCount ?? this.patUnreadCount,
      docUnreadCount: docUnreadCount ?? this.docUnreadCount,
    );
  }
}
