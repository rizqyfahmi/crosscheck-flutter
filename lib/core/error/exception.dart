import 'package:crosscheck/core/error/failure.dart';

class ServerException extends ServerFailure implements Exception {
  const ServerException({required super.message, super.errors, super.data});
}

class CacheException extends CacheFailure implements Exception {
  const CacheException({required super.message, super.data});
}