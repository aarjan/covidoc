import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  ServerFailure(this.error);

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'ServerFailure: $error';
  }
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}
