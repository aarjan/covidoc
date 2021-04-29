import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final bool profileVerification;

  LoggedIn({this.profileVerification = false});
}

class LoggedOut extends AuthEvent {}
