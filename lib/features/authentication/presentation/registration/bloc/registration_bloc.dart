import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_model.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {

  final RegistrationUsecase registrationUsecase;

  RegistrationBloc({
    required this.registrationUsecase
  }) : super(const RegistrationInitial()) {
    on<RegistrationSetName>((event, emit) {
      final RegistrationModel model = state.model.copyWith(name: event.name, errorName: "");
      emit(RegistrationEnterField(model: model));
    });
    on<RegistrationSetEmail>((event, emit) {
      final RegistrationModel model = state.model.copyWith(email: event.email, errorEmail: "");
      emit(RegistrationEnterField(model: model));
    });
    on<RegistrationSetPassword>((event, emit) {
      final RegistrationModel model = state.model.copyWith(password: event.password, errorPassword: "");
      emit(RegistrationEnterField(model: model));
    });
    on<RegistrationSetConfirmPassword>((event, emit) {
      final RegistrationModel model = state.model.copyWith(confirmPassword: event.confirmPassword, errorConfirmPassword: "");
      emit(RegistrationEnterField(model: model));
    });
    on<RegistrationSetValidationError>((event, emit) {
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

      final RegistrationModel model = state.model.copyWith(
        errorName: errorName,
        errorEmail: errorEmail,
        errorPassword: errorPassword,
        errorConfirmPassword: errorConfirmPassword
      );

      emit(RegistrationValidationError(model: model));
    });
    on<RegistrationResetGeneralError>((event, emit) {
      emit(RegistrationNoGeneralError(model: state.model));
    });
    on<RegistrationSubmit>((event, emit) async {
      // Reset validation error before registrartion submit
      final RegistrationModel model = state.model.copyWith(
        errorName: "",
        errorEmail: "",
        errorPassword: "",
        errorConfirmPassword: ""
      );
      emit(RegistrationLoading(model: model));

      final RegistrationParams params = RegistrationParams(
        name: model.name, 
        email: model.email, 
        password: model.password, 
        confirmPassword: model.confirmPassword
      );
      final response =  await registrationUsecase(params);

      response.fold((error) {
        if (error is NullFailure) return emit(RegistrationGeneralError(message: NullFailure.message, model: model));
        if (error is NetworkFailure) return emit(RegistrationGeneralError(message: NetworkFailure.message, model: model));
        if (error is! ServerFailure) return; // prevent other failures, except ServerFailure
        if (error.errors != null) return add(RegistrationSetValidationError(errors: error.errors!));

        emit(RegistrationGeneralError(message: error.message, model: model));
      }, (result) {
        emit(RegistrationSuccess(token: result.token));
      });
    });
  }

}