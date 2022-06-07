import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_event.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc({
    required this.loginUsecase
  }) : super(const LoginInitial());
  
}