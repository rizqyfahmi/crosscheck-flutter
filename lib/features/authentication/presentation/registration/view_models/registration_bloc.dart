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
      String errorName = "";
      String errorEmail = "";
      String errorPassword = "";
      String errorConfirmPassword = "";

      for (var error in event.errors) {
        switch (error["field"]) {
          case "name":
            errorName = error["error"];
            break;
          case "email":
            errorEmail = error["error"];
            break;
          case "password":
            errorPassword = error["error"];
            break;
          case "confirmPassword":
            errorConfirmPassword = error["error"];
            break;
        }
      }

      // print("Hello World: $errorName, $errorEmail, $errorPassword, $errorConfirmPassword");

      final result = state.copyWith(
        errorName: errorName,
        errorEmail: errorEmail,
        errorPassword: errorPassword,
        errorConfirmPassword: errorConfirmPassword
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