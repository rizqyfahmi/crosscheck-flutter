import 'package:crosscheck/core/param/param.dart';

class RegistrationParams extends Param {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegistrationParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword
  });

  @override
  List<Object?> get props => [name, email, password, confirmPassword];
  
}