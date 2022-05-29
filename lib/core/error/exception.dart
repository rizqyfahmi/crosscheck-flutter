import 'package:crosscheck/core/error/failure.dart';

class ServerException extends ServerFailure implements Exception {
  ServerException({required super.message});
}

class CacheException implements Exception {}

class NetworkException implements Exception {}