import 'failures.dart';

class ServerException implements Exception {
  const ServerException(this.failure);
  final ServerFailure failure;

  @override
  String toString() {
    return 'ServerException: $failure';
  }
}

class CacheException implements Exception {}
