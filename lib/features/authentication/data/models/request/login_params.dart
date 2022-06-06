import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password
  });

  @override
  List<Object?> get props => [username, password];
}