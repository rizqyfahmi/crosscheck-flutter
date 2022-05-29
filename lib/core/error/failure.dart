import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/* 
  Failure classes are only focus on error that is resulted by "Either"
*/
abstract class Failure extends Equatable {
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
  List<Object?> get props => [message];
}

class CachedFailure extends Failure {
  final String message;

  CachedFailure({
    required this.message
  });

  @override
  List<Object?> get props => [message];
}

class NullFailure extends Failure {}
class NetworkFailure extends Failure {}