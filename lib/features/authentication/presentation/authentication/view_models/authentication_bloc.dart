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
    on<AuthenticationSubmitRegistration>((event, emit) async {
      
      emit(AuthenticationLoading());
      final response = await registrationUsecase(event.params);

      response.fold((error) {
        if (error is NullFailure) {
          return emit(AuthenticationGeneralError(message: NullFailure.message));
        }

        if (error is NetworkFailure) {
          return emit(AuthenticationGeneralError(message: NetworkFailure.message));
        }

        if (error is! ServerFailure) return;

        if (error.errors != null) {
          return emit(AuthenticationErrorFields(errors: error.errors!));
        }

        emit(AuthenticationGeneralError(message: error.message));

      }, (result) {

        emit(AuthenticationSuccess(token: result.token));
        
      });

    });
  }

}