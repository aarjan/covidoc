import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoadSuccess extends HomeState {
  HomeLoadSuccess(this.user);
  final User user;

  @override
  List<Object> get props => [user];
}

class HomeLoadFailure extends HomeState {
  HomeLoadFailure(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
