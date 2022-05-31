import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthenticationState {}
class AuthenticationLoading extends AuthenticationState {}
class AuthenticationSuccess extends AuthenticationState {
  final String token;

  const AuthenticationSuccess({
    required this.token
  });
}

class AuthenticationGeneralError extends Unauthenticated {
  final String message;
  
  AuthenticationGeneralError({
    required this.message
  });
}

class AuthenticationErrorFields extends Unauthenticated {
  final List<Map<String, dynamic>> errors;
  
  AuthenticationErrorFields({
    required this.errors
  });
}