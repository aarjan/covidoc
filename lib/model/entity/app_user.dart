import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

enum UserType { Doctor, Patient }

@JsonSerializable(includeIfNull: false)
class AppUser extends Equatable {
  const AppUser({
    this.id,
    this.type,
    this.email,
    this.detail,
    this.avatar,
    this.fullname,
    this.providerId,
    this.chatIds = const <String>[],
    this.chatUsers = const <String>[],
    this.profileVerification = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  final String id;
  final String type;
  final String email;
  final String avatar;
  final String fullname;
  final String providerId;
  @JsonKey(defaultValue: <String>[])
  final List<String> chatIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> chatUsers;
  final Map<String, dynamic> detail;
  @JsonKey(defaultValue: false)
  final bool profileVerification;

  @override
  List<Object> get props => [
        id,
        type,
        email,
        avatar,
        detail,
        chatIds,
        fullname,
        chatUsers,
        providerId,
        profileVerification
      ];

  AppUser copyUser(AppUser user) {
    final nDetail = detail ?? <String, dynamic>{};
    if (user.detail != null) {
      nDetail.addAll(user.detail);
    }

    return AppUser(
      detail: nDetail,
      id: user.id ?? id,
      type: user.type ?? type,
      email: user.email ?? email,
      avatar: user.avatar ?? avatar,
      chatIds: user.chatIds ?? chatIds,
      fullname: user.fullname ?? fullname,
      chatUsers: user.chatUsers ?? chatUsers,
      providerId: user.providerId ?? providerId,
      profileVerification: user.profileVerification ?? profileVerification,
    );
  }

  AppUser copyWith({
    String id,
    String type,
    String email,
    String avatar,
    String fullname,
    String providerId,
    List<String> chatIds,
    List<String> chatUsers,
    bool profileVerification,
    Map<String, dynamic> detail,
  }) {
    return AppUser(
      id: id ?? this.id,
      type: type ?? this.type,
      email: email ?? this.email,
      detail: detail ?? this.detail,
      avatar: avatar ?? this.avatar,
      chatIds: chatIds ?? this.chatIds,
      fullname: fullname ?? this.fullname,
      chatUsers: chatUsers ?? this.chatUsers,
      providerId: providerId ?? this.providerId,
      profileVerification: profileVerification ?? this.profileVerification,
    );
  }
}
