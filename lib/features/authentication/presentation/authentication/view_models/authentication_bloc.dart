import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  
  AuthenticationBloc() : super(const Unauthenticated()) {
    on<AuthenticationSetToken>((event, emit) {
      emit(Authenticated(token: event.token));
    });
    on<AuthenticationResetToken>((event, emit) {
      emit(const Unauthenticated());
    });
  }

}