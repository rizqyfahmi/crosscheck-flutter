import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {

  final RegistrationUsecase registrationUsecase;

  RegistrationBloc({
    required this.registrationUsecase
  }) : super(const RegistrationState()) {
    on<RegistrationSetName>((event, emit) {
      final result = state.copyWith(name: event.name);
      emit(result);
    });
    on<RegistrationSetEmail>((event, emit) {
      final result = state.copyWith(email: event.email);
      emit(result);
    });
    on<RegistrationSetPassword>((event, emit) {
      final result = state.copyWith(password: event.password);
      emit(result);
    });
    on<RegistrationSetConfirmPassword>((event, emit) {
      final result = state.copyWith(confirmPassword: event.confirmPassword);
      emit(result);
    });
    on<RegistrationSetErrorFields>((event, emit) {
      final result = state.copyWith(
        errorName: event.errorName,
        errorEmail: event.errorEmail,
        errorPassword: event.errorPassword,
        errorConfirmPassword: event.errorConfirmPassword
      );
      emit(result);
    });
    on<RegistrationResetErrorFields>((event, emit) {
      final result = state.copyWith(
        errorName: "",
        errorEmail: "",
        errorPassword: "",
        errorConfirmPassword: "",
      );
      emit(result);
    });
    on<RegistrationResetFields>((event, emit) {
      emit(const RegistrationState());
    });
  }

}