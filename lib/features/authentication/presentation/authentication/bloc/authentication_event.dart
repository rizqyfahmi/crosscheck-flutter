import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationSetToken extends AuthenticationEvent {
  final String token;

  const AuthenticationSetToken({
    required this.token
  });

  @override
  List<Object?> get props => [token];
}

class AuthenticationResetToken extends AuthenticationEvent {}
