import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {

  RegistrationBloc() : super(const RegistrationState()) {
    on<RegistrationSetName>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
    on<RegistrationSetEmail>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<RegistrationSetPassword>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<RegistrationSetConfirmPassword>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
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