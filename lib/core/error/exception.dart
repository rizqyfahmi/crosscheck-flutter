import 'package:crosscheck/core/error/failure.dart';

class ServerException extends ServerFailure implements Exception {
  ServerException({required super.message, super.errors});
}

class CacheException extends CachedFailure implements Exception {
  CacheException({required super.message});
}