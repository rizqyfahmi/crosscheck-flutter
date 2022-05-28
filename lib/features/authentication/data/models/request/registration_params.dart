import 'package:equatable/equatable.dart';

class RegistrationParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const RegistrationParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword
  });

  @override
  List<Object?> get props => [name, email, password, confirmPassword];
  
}