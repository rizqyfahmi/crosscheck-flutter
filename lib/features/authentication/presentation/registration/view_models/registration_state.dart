import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_model.dart';
import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {

  final RegistrationModel model;

  const RegistrationState({
    required this.model
  });

  @override
  List<Object?> get props => [
    model
  ];
}

class RegistrationInitial extends RegistrationState {
  const RegistrationInitial() : super(model: const RegistrationModel());
}

class RegistrationEnterField extends RegistrationState{
  const RegistrationEnterField({required super.model});
}

class RegistrationLoading extends RegistrationState {
  const RegistrationLoading({required super.model});
}

class RegistrationSuccess extends RegistrationState {
  final String token;

  const RegistrationSuccess({required this.token}) : super(model: const RegistrationModel());
}

class RegistrationGeneralError extends RegistrationState {
  final String message;

  const RegistrationGeneralError({required this.message, required super.model});
}

class RegistrationValidationError extends RegistrationState {
  const RegistrationValidationError({required super.model});
}
