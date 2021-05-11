import 'package:covidoc/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

enum MessageType { Text, Audio }

@JsonSerializable()
@DateTimeConverter()
class Message extends Equatable {
  const Message({
    this.id,
    this.chatId,
    this.docId,
    this.patId,
    this.message,
    this.msgFrom,
    this.msgType,
    this.documents = const <String>[],
    this.readStatus,
    this.timestamp,
  });

  final String id;
  final String docId;
  final String patId;
  final String chatId;
  final String message;
  final String msgFrom;
  final bool readStatus;

  final DateTime timestamp;
  final MessageType msgType;

  @JsonKey(defaultValue: <String>[])
  final List<String> documents;

  @override
  List<Object> get props => [
        id,
        docId,
        patId,
        chatId,
        msgFrom,
        message,
        msgType,
        documents,
        timestamp,
        readStatus,
      ];

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({
    String id,
    String docId,
    String patId,
    String chatId,
    String message,
    String msgFrom,
    String timestamp,
    String readStatus,
    MessageType msgType,
    List<String> documents,
  }) {
    return Message(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      patId: patId ?? this.patId,
      chatId: chatId ?? this.chatId,
      message: message ?? this.message,
      msgFrom: msgFrom ?? this.msgFrom,
      msgType: msgType ?? this.msgType,
      timestamp: timestamp ?? this.timestamp,
      documents: documents ?? this.documents,
      readStatus: readStatus ?? this.readStatus,
    );
  }
}
