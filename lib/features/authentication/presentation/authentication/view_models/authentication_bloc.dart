import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  
  final RegistrationUsecase registrationUsecase;

  AuthenticationBloc({
    required this.registrationUsecase
  }) : super(Unauthenticated()) {
    on<AuthenticationSubmitRegistration>((event, emit) {});
  }

}