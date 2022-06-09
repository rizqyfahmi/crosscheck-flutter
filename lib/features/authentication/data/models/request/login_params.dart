import 'package:crosscheck/core/param/param.dart';

class LoginParams extends Param {
  final String username;
  final String password;

  LoginParams({
    required this.username,
    required this.password
  });

  @override
  List<Object?> get props => [username, password];
}