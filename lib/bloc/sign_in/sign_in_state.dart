import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {}

class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInProgress extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInSuccess extends SignInState {
  SignInSuccess({this.profileVerification = false});

  final bool profileVerification;

  @override
  List<Object> get props => [profileVerification];
}

class SignInFailure extends SignInState {
  SignInFailure(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
