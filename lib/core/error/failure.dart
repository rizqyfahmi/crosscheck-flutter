import 'package:equatable/equatable.dart';

/* 
  Failure classes are only focus on error that is resulted by "Either"
*/
abstract class Failure extends Equatable {
  static const generalError = "Something went wrong";
  static const loginRequiredFieldError = "Username and password are required";
  static const validationError = "Error Validation";
  static const cacheError = "Cache data error";
  static const localDatabase = "Database error";
  static const nullError = "Null reference error";
  static const networkError = "Network error";

  final String message;
  final dynamic data;

  const Failure({required this.message, this.data});

  @override
  List<Object?> get props => [message, data];
}

class ServerFailure extends Failure {
  final List<Map<String, dynamic>>? errors;
  
  const ServerFailure({
    required super.message,
    this.errors,
    super.data
  });

  @override
  List<Object?> get props => [message, errors, data];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.data});

  @override
  List<Object?> get props => [message, data];

}

class NullFailure extends Failure {
  const NullFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.data});

  @override
  List<Object?> get props => [message, data];
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.data});
}