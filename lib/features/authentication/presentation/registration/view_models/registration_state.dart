import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {

  final String name;
  final String errorName;
  final String email;
  final String errorEmail;
  final String password;
  final String errorPassword;
  final String confirmPassword;
  final String errorConfirmPassword;

  const RegistrationState({
    this.name = "",
    this.errorName = "",
    this.email = "",
    this.errorEmail = "",
    this.password = "",
    this.errorPassword = "",
    this.confirmPassword = "",
    this.errorConfirmPassword = ""
  });

  RegistrationState copyWith({
    String? name,
    String? errorName,
    String? email,
    String? errorEmail,
    String? password,
    String? errorPassword,
    String? confirmPassword,
    String? errorConfirmPassword
  }) {
    return RegistrationState(
      name: name ?? this.name, 
      errorName: errorName ?? this.errorName, 
      email: email ?? this.email, 
      errorEmail: errorEmail ?? this.errorEmail, 
      password: password ?? this.password, 
      errorPassword: errorPassword ?? this.errorPassword, 
      confirmPassword: confirmPassword ?? this.confirmPassword, 
      errorConfirmPassword: errorConfirmPassword ?? this.errorConfirmPassword
    );
  }

  @override
  List<Object?> get props => [
    name, errorName, email, errorEmail, password, errorPassword, confirmPassword, errorConfirmPassword
  ];
}