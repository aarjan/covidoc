import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthInProgress extends AuthState {}

class Authenticated extends AuthState {
  final bool profileVerification;

  const Authenticated({this.profileVerification = true});
}

class UnAuthenticated extends AuthState {}
