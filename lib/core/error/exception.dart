import 'package:crosscheck/core/error/failure.dart';

class ServerException extends ServerFailure implements Exception {
  ServerException({required super.message, super.errors});
}

class CacheException implements Exception {}