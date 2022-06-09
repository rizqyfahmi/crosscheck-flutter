import 'package:equatable/equatable.dart';

/* 
  Failure classes are only focus on error that is resulted by "Either"
*/
abstract class Failure extends Equatable {
  static const generalError = "Something went wrong";
  static const loginRequiredFieldError = "Username and password are required";
  static const cacheError = "Cache data error";

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;
  final List<Map<String, dynamic>>? errors;

  ServerFailure({
    required this.message,
    this.errors
  });

  @override
  List<Object?> get props => [message, errors];
}

class CachedFailure extends Failure {
  final String message;

  CachedFailure({
    required this.message
  });

  @override
  List<Object?> get props => [message];
}

class NullFailure extends Failure {
  static const message = "Null reference error";
}

class NetworkFailure extends Failure {
  static const message = "Network error";
}