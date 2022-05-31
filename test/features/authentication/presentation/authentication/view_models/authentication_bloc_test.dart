import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_event.dart';
import 'package:crosscheck/features/authentication/presentation/authentication/view_models/authentication_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_bloc_test.mocks.dart';

@GenerateMocks([RegistrationUsecase])
void main() {
  late AuthenticationBloc bloc;
  late MockRegistrationUsecase mockRegistrationUseCase;
  late RegistrationParams registrationParams;

  // Mock Result
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  const List <Map<String, dynamic>> errors = [
    {
      "field": "name",
      "error": "Your name should contain at least 8 characters"
    },
    {
      "field": "email",
      "error": "Please enter a valid email address"
    },
    {
      "field": "password",
      "error": "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required."
    },
    {
      "field": "confirmPassword",
      "error": "Your password and confirmation password do not match"
    }
  ];

  setUp(() {
    mockRegistrationUseCase = MockRegistrationUsecase();
    bloc = AuthenticationBloc(registrationUsecase: mockRegistrationUseCase);
    registrationParams = const RegistrationParams(name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123");
  });
  test("Should return Unauthenticated() at first time ", () {
    expect(bloc.state, Unauthenticated());
  });

  test("Should return AuthenticationSuccess() when registration is success", () {

    when(mockRegistrationUseCase(registrationParams)).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));

    bloc.add(AuthenticationSubmitRegistration(params: registrationParams));

    final expected = [
      AuthenticationLoading(),
      const AuthenticationSuccess(token: token)
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

  });

  test("Should return AuthenticationGeneralError(message: NullFailure.message) when registration is failed because of NullFailure()", () {

    when(mockRegistrationUseCase(registrationParams)).thenAnswer((_) async => Left(NullFailure()));

    bloc.add(AuthenticationSubmitRegistration(params: registrationParams));

    final expected = [
      AuthenticationLoading(),
      AuthenticationGeneralError(message: NullFailure.message)
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

  });

  test("Should return AuthenticationGeneralError(message: NetworkFailure.message) when registration is failed because of NetworkFailure()", () {

    when(mockRegistrationUseCase(registrationParams)).thenAnswer((_) async => Left(NetworkFailure()));

    bloc.add(AuthenticationSubmitRegistration(params: registrationParams));

    final expected = [
      AuthenticationLoading(),
      AuthenticationGeneralError(message: NetworkFailure.message)
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

  });

  test("Should return AuthenticationErrorFields() when registration is failed because of validation", () {

    when(mockRegistrationUseCase(registrationParams)).thenAnswer((_) async => Left(ServerFailure(message: "Something went wrong", errors: errors)));

    bloc.add(AuthenticationSubmitRegistration(params: registrationParams));

    final expected = [
      AuthenticationLoading(),
      AuthenticationErrorFields(errors: errors)
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

  });
}