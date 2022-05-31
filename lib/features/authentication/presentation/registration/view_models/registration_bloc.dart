import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/view_models/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {

  final RegistrationUsecase registrationUsecase;

  RegistrationBloc({
    required this.registrationUsecase
  }) : super(const RegistrationState()) {
    on<RegistrationSetName>((event, emit) {});
    on<RegistrationSetEmail>((event, emit) {});
    on<RegistrationSetPassword>((event, emit) {});
    on<RegistrationSetConfirmPassword>((event, emit) {});
    on<RegistrationSetErrorFields>((event, emit) {});
    on<RegistrationResetErrorFields>((event, emit) {});
    on<RegistrationResetFields>((event, emit) {});
  }

}