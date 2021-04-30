import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Chat extends Equatable {
  const Chat({
    this.docId,
    this.patId,
    this.docName,
    this.patName,
    this.docAvatar,
    this.patAvatar,
    this.lastMessage,
    this.lastTimestamp,
  });

  final String docId;
  final String patId;
  final String docName;
  final String patName;
  final String docAvatar;
  final String patAvatar;
  final String lastMessage;
  final DateTime lastTimestamp;

  @override
  List<Object> get props => [
        docId,
        patId,
        docName,
        patName,
        docAvatar,
        patAvatar,
        lastMessage,
        lastTimestamp,
      ];

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

@JsonSerializable()
class Message extends Equatable {
  const Message({
    this.id,
    this.docId,
    this.patId,
    this.message,
    this.msgFrom,
    this.documents,
    this.timestamp,
  });

  final String id;
  final String docId;
  final String patId;
  final String message;
  final String msgFrom;
  final String documents;
  final String timestamp;

  @override
  List<Object> get props =>
      [docId, id, msgFrom, patId, message, documents, timestamp];

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({
    String id,
    String docId,
    String patId,
    String message,
    String msgFrom,
    String documents,
    String timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      patId: patId ?? this.patId,
      message: message ?? this.message,
      msgFrom: msgFrom ?? this.msgFrom,
      timestamp: timestamp ?? this.timestamp,
      documents: documents ?? this.documents,
    );
  }
}
