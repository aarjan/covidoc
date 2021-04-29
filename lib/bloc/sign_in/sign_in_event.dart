import 'package:equatable/equatable.dart';

class SignInEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInStarted extends SignInEvent {}

class SignOutStarted extends SignInEvent {}
