import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_event.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc({
    required this.loginUsecase
  }) : super(const LoginInitial()) {
    on<LoginSetUsername>((event, emit) {
      emit(LoginEnterField(model: state.model.copyWith(username: event.username)));
    });
    on<LoginSetPassword>((event, emit) {
      emit(LoginEnterField(model: state.model.copyWith(password: event.password)));
    });
    on<LoginSubmit>((event, emit) async {
      emit(LoginLoading(model: state.model));

      final response = await loginUsecase(LoginParams(username: state.model.username, password: state.model.password));
      
      response.fold((error) {
          if (error is! ServerFailure) return;

          emit(LoginGeneralError(message: error.message, model: state.model));
        }, 
        (result) {
          emit(LoginSuccess(token: result.token));
        }
      );
    });
    on<LoginResetGeneralError>((event, emit) {
      emit(LoginNoGeneralError(model: state.model));
    });
  }
  
}