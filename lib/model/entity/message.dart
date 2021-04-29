import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  const Message({
    this.id,
    this.message,
    this.msgFrom,
    this.doctorId,
    this.messageId,
    this.patientId,
    this.documents,
  });

  final String id;
  final String message;
  final String msgFrom;
  final String doctorId;
  final String patientId;
  final String messageId;
  final String documents;

  @override
  List<Object> get props =>
      [id, doctorId, messageId, msgFrom, patientId, message, documents];

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
