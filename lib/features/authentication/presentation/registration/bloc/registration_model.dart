import 'package:equatable/equatable.dart';

// This additional class is used to store value of screen state. So that we can only use stateless widget for the screen
class RegistrationModel extends Equatable {
  
  final String name;
  final String errorName;
  final String email;
  final String errorEmail;
  final String password;
  final String errorPassword;
  final String confirmPassword;
  final String errorConfirmPassword;

  const RegistrationModel({
    this.name = "",
    this.errorName = "",
    this.email = "",
    this.errorEmail = "",
    this.password = "",
    this.errorPassword = "",
    this.confirmPassword = "",
    this.errorConfirmPassword = ""
  });

  RegistrationModel copyWith({
    String? name,
    String? errorName,
    String? email,
    String? errorEmail,
    String? password,
    String? errorPassword,
    String? confirmPassword,
    String? errorConfirmPassword
  }) {
    return RegistrationModel(
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