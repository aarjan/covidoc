import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  const Message({
    this.id,
    this.docId,
    this.patId,
    this.docName,
    this.patName,
    this.docAvatar,
    this.patAvatar,
    this.lastMessage,
    this.lastTimeStamp,
  });

  final String id;
  final String docId;
  final String patId;
  final String docName;
  final String patName;
  final String docAvatar;
  final String patAvatar;
  final String lastMessage;
  final String lastTimeStamp;

  @override
  List<Object> get props => [
        id,
        docId,
        patId,
        docName,
        patName,
        docAvatar,
        patAvatar,
        lastMessage,
        lastTimeStamp,
      ];

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class MessageThread extends Equatable {
  const MessageThread({
    this.id,
    this.message,
    this.msgFrom,
    this.docId,
    this.messageId,
    this.patId,
    this.documents,
  });

  final String id;
  final String message;
  final String msgFrom;
  final String docId;
  final String patId;
  final String messageId;
  final String documents;

  @override
  List<Object> get props =>
      [id, docId, messageId, msgFrom, patId, message, documents];

  factory MessageThread.fromJson(Map<String, dynamic> json) =>
      _$MessageThreadFromJson(json);

  Map<String, dynamic> toJson() => _$MessageThreadToJson(this);
}
