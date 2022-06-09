
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_event.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_model.dart';
import 'package:crosscheck/features/authentication/presentation/login/view_models/login_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks([LoginUsecase])
void main() {
  late MockLoginUsecase mockLoginUsecase;
  late LoginBloc bloc;
  late LoginParams loginParams;

  // Mock Result
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    bloc = LoginBloc(loginUsecase: mockLoginUsecase);
    loginParams = LoginParams(username: "fulan@email.com", password: "Password123");
  });

  test("Should return LoginInitial at first time", () {
    expect(bloc.state, const LoginInitial());
  });

  test("Should keep value when each field on login form is entered in separately", () {
    final expacted = [
      const LoginEnterField(model: LoginModel(username: "f", password: "")),
      const LoginEnterField(model: LoginModel(username: "fu", password: "")),
      const LoginEnterField(model: LoginModel(username: "ful", password: "")),
      const LoginEnterField(model: LoginModel(username: "fula", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@e", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@em", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@ema", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@emai", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.c", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.co", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "P")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Pa")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Pas")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Pass")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Passw")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Passwo")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Passwor")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password1")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password12")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password123")),
    ];

    bloc.add(const LoginSetUsername(username: "f"));
    bloc.add(const LoginSetUsername(username: "fu"));
    bloc.add(const LoginSetUsername(username: "ful"));
    bloc.add(const LoginSetUsername(username: "fula"));
    bloc.add(const LoginSetUsername(username: "fulan"));
    bloc.add(const LoginSetUsername(username: "fulan@"));
    bloc.add(const LoginSetUsername(username: "fulan@e"));
    bloc.add(const LoginSetUsername(username: "fulan@em"));
    bloc.add(const LoginSetUsername(username: "fulan@ema"));
    bloc.add(const LoginSetUsername(username: "fulan@emai"));
    bloc.add(const LoginSetUsername(username: "fulan@email"));
    bloc.add(const LoginSetUsername(username: "fulan@email."));
    bloc.add(const LoginSetUsername(username: "fulan@email.c"));
    bloc.add(const LoginSetUsername(username: "fulan@email.co"));
    bloc.add(const LoginSetUsername(username: "fulan@email.com"));
    bloc.add(const LoginSetPassword(password: "P"));
    bloc.add(const LoginSetPassword(password: "Pa"));
    bloc.add(const LoginSetPassword(password: "Pas"));
    bloc.add(const LoginSetPassword(password: "Pass"));
    bloc.add(const LoginSetPassword(password: "Passw"));
    bloc.add(const LoginSetPassword(password: "Passwo"));
    bloc.add(const LoginSetPassword(password: "Passwor"));
    bloc.add(const LoginSetPassword(password: "Password"));
    bloc.add(const LoginSetPassword(password: "Password1"));
    bloc.add(const LoginSetPassword(password: "Password12"));
    bloc.add(const LoginSetPassword(password: "Password123"));

    expectLater(bloc.stream, emitsInOrder(expacted));
  });

  test("Should return LoginLoading on submit login form", () {
    when(mockLoginUsecase(any)).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));

    final expected = [
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123"))
    ];

    bloc.add(const LoginSetUsername(username: "fulan@email.com"));
    bloc.add(const LoginSetPassword(password: "Password123"));
    bloc.add(LoginSubmit());

    expectLater(bloc.stream, emitsInOrder(expected));
  });

  test("Should return LoginSuccess when submit login form is success", () async {
    when(mockLoginUsecase(any)).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));

    final expected = [
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginSuccess(token: token)
    ];

    bloc.add(const LoginSetUsername(username: "fulan@email.com"));
    bloc.add(const LoginSetPassword(password: "Password123"));
    bloc.add(LoginSubmit());

    expectLater(bloc.stream, emitsInOrder(expected));
    await untilCalled(mockLoginUsecase(any));
    
    verify(mockLoginUsecase(loginParams));

  });

  test("Should return LoginGeneralError when submit login form is failed", () async {
    when(mockLoginUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    final expected = [
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginGeneralError(message: Failure.generalError, model: LoginModel(username: "fulan@email.com", password: "Password123"))
    ];

    bloc.add(const LoginSetUsername(username: "fulan@email.com"));
    bloc.add(const LoginSetPassword(password: "Password123"));
    bloc.add(LoginSubmit());

    expectLater(bloc.stream, emitsInOrder(expected));
    await untilCalled(mockLoginUsecase(any));
    
    verify(mockLoginUsecase(loginParams));

  });

  test("Should return LoginGeneralError when submit login form is failed because of NetworkFailure()", () async {
    when(mockLoginUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: NetworkFailure.message)));

    final expected = [
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginGeneralError(message: NetworkFailure.message, model: LoginModel(username: "fulan@email.com", password: "Password123"))
    ];

    bloc.add(const LoginSetUsername(username: "fulan@email.com"));
    bloc.add(const LoginSetPassword(password: "Password123"));
    bloc.add(LoginSubmit());

    expectLater(bloc.stream, emitsInOrder(expected));
    await untilCalled(mockLoginUsecase(any));
    
    verify(mockLoginUsecase(loginParams));

  });

  test("Should return LoginGeneralError when submit login form is failed because of username or password still empty", () async {
    when(mockLoginUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.loginRequiredFieldError)));

    final expected = [
      const LoginLoading(model: LoginModel( username: "", password: "")),
      const LoginGeneralError(message: Failure.loginRequiredFieldError, model: LoginModel( username: "", password: ""))
    ];

    bloc.add(LoginSubmit());

    expectLater(bloc.stream, emitsInOrder(expected));
    await untilCalled(mockLoginUsecase(any));
    
    verify(mockLoginUsecase(LoginParams(username: "", password: "")));

  });

  test("Should return LoginNoGeneralError when button dismissed is clicked after sumbit login form is failed", () async {
    when(mockLoginUsecase(any)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    final expected = [
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "")),
      const LoginEnterField(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginLoading(model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginGeneralError(message: Failure.generalError, model: LoginModel(username: "fulan@email.com", password: "Password123")),
      const LoginNoGeneralError(model: LoginModel(username: "fulan@email.com", password: "Password123"))
    ];

    bloc.add(const LoginSetUsername(username: "fulan@email.com"));
    bloc.add(const LoginSetPassword(password: "Password123"));
    bloc.add(LoginSubmit());
    bloc.add(LoginResetGeneralError());

    expectLater(bloc.stream, emitsInOrder(expected));
    await untilCalled(mockLoginUsecase(any));
    
    verify(mockLoginUsecase(loginParams));

  });
}