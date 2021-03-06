import 'package:covidoc/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_request.g.dart';

@JsonSerializable()
@DateTimeConverter()
class MessageRequest extends Equatable {
  final String? id;
  final String message;
  final String postedBy;
  final DateTime? postedAt;
  final String? resolvedBy;
  final Map<String, dynamic> patDetail;
  final Map<String, dynamic>? docDetail;

  @JsonKey(defaultValue: false)
  final bool resolved;
  @JsonKey(defaultValue: false)
  final bool postedAnonymously;

  MessageRequest({
    this.id,
    this.docDetail,
    this.resolvedBy,
    this.postedAt,
    this.resolved = false,
    required this.message,
    required this.postedBy,
    required this.patDetail,
    this.postedAnonymously = false,
  });

  @override
  List<Object?> get props => [
        id,
        message,
        postedAt,
        resolved,
        postedBy,
        patDetail,
        docDetail,
        resolvedBy,
        postedAnonymously
      ];

  factory MessageRequest.fromJson(Map<String, dynamic> json) =>
      _$MessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MessageRequestToJson(this);

  MessageRequest copyWith({
    String? id,
    bool? resolved,
    String? message,
    String? postedBy,
    String? resolvedBy,
    DateTime? postedAt,
    bool? postedAnonymously,
    Map<String, dynamic>? patDetail,
    Map<String, dynamic>? docDetail,
  }) {
    return MessageRequest(
      id: id ?? this.id,
      message: message ?? this.message,
      postedAt: postedAt ?? this.postedAt,
      resolved: resolved ?? this.resolved,
      postedBy: postedBy ?? this.postedBy,
      patDetail: patDetail ?? this.patDetail,
      docDetail: docDetail ?? this.docDetail,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      postedAnonymously: postedAnonymously ?? this.postedAnonymously,
    );
  }
}
