import 'package:equatable/equatable.dart';

class SignInEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInStarted extends SignInEvent {
  final SignInType type;

  SignInStarted(this.type);
}

class SignOutStarted extends SignInEvent {}

enum SignInType { Google, Facebook, Twitter }
