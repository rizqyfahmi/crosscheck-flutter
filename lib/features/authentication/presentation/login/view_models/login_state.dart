import 'package:crosscheck/features/authentication/presentation/login/view_models/login_model.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  final LoginModel model;

  const LoginState({
    required this.model
  });

  @override
  List<Object?> get props => [model];
}

class LoginInitial extends LoginState {
  const LoginInitial() : super(model: const LoginModel());
}

class LoginEnterField extends LoginState {
  const LoginEnterField({required super.model});
}

class LoginLoading extends LoginState {
  const LoginLoading({required super.model});
}

class LoginSuccess extends LoginState {
  final String token;

  const LoginSuccess({required this.token}) : super(model: const LoginModel());
}

class LoginGeneralError extends LoginState {
  final String message;

  const LoginGeneralError({required this.message, required super.model});

  @override
  List<Object?> get props => [...super.props, message];
}

class LoginNoGeneralError extends LoginState {
  const LoginNoGeneralError({required super.model});
}