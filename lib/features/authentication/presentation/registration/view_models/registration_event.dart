import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegistrationSetName extends RegistrationEvent {
  final String name;

  const RegistrationSetName(this.name);

  @override
  List<Object?> get props => [name];
}

class RegistrationSetEmail extends RegistrationEvent {
  final String email;

  const RegistrationSetEmail(this.email);
  
  @override
  List<Object?> get props => [email];
}

class RegistrationSetPassword extends RegistrationEvent {
  final String password;

  const RegistrationSetPassword(this.password);

  @override
  List<Object?> get props => [password];
}

class RegistrationSetConfirmPassword extends RegistrationEvent {
  final String confirmPassword;

  const RegistrationSetConfirmPassword(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class RegistrationSetErrorFields extends RegistrationEvent {
  final List<Map<String, dynamic>> errors;

  const RegistrationSetErrorFields({
    required this.errors,
  });

  @override
  List<Object?> get props => [errors];
}

class RegistrationResetErrorFields extends RegistrationEvent {}
class RegistrationResetFields extends RegistrationEvent {}