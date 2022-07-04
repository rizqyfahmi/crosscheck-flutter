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

  const Failure({
    required this.message
  });

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final List<Map<String, dynamic>>? errors;

  const ServerFailure({
    required super.message,
    this.errors
  });

  @override
  List<Object?> get props => [super.message, errors];
}

class CacheFailure extends Failure {
  
  const CacheFailure({
    required super.message,
  });

}

class NullFailure extends Failure {
  const NullFailure({required super.message});
}

class NetworkFailure extends Failure {
  final dynamic data;

  const NetworkFailure({required super.message, this.data});

  @override
  List<Object?> get props => [...super.props, data];
}