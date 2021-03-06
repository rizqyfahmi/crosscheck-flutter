import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSetUsername extends LoginEvent {
  final String username;

  const LoginSetUsername({
    required this.username
  });

  @override
  List<Object?> get props => [username];
}

class LoginSetPassword extends LoginEvent {
  final String password;

  const LoginSetPassword({
    required this.password
  });

  @override
  List<Object?> get props => [password];
}

class LoginSubmit extends LoginEvent {}
class LoginResetGeneralError extends LoginEvent {}