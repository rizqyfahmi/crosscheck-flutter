import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationSubmitRegistration extends AuthenticationEvent {
  final RegistrationParams params;

  const AuthenticationSubmitRegistration({
    required this.params
  });
}
