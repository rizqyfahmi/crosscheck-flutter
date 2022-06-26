import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/bloc/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  
  AuthenticationBloc() : super(Unauthenticated()) {
    on<AuthenticationSetAuthenticated>((event, emit) {
      emit(Authenticated());
    });
    on<AuthenticationSetUnauthenticated>((event, emit) {
      emit(Unauthenticated());
    });
  }

}