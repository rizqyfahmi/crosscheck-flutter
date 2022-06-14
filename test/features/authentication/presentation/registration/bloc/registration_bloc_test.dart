import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_bloc.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_event.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_model.dart';
import 'package:crosscheck/features/authentication/presentation/registration/bloc/registration_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'registration_bloc_test.mocks.dart';

@GenerateMocks([RegistrationUsecase])
void main() {
  late MockRegistrationUsecase mockRegistrationUseCase;
  late RegistrationBloc bloc;
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
    bloc = RegistrationBloc(registrationUsecase: mockRegistrationUseCase);
  });

  test("Should return RegistrationInitial at first time", () {
    expect(bloc.state, const RegistrationInitial());
  });

  group("Manage state on field", () {
    setUp(() {
      mockRegistrationUseCase = MockRegistrationUsecase();
      bloc = RegistrationBloc(registrationUsecase: mockRegistrationUseCase);
      registrationParams = RegistrationParams(name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123");
    });

    test("Should keep value when each field is entered in separately", () {
      final expected = [
        const RegistrationEnterField(model: RegistrationModel(name: "F", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fu", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Ful", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fula", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "f", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fu", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "ful", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fula", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@e", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@em", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@ema", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@emai", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.c", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.co", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "P", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Pa", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Pas", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Pass", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Passw", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Passwo", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Passwor", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password1", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password12", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "P", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Pa", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Pas", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Pass", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Passw", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Passwo", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Passwor", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password1", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password12", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email.com", errorEmail: "", password: "Password123", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
      ];

      bloc.add(const RegistrationSetName("F"));
      bloc.add(const RegistrationSetName("Fu"));
      bloc.add(const RegistrationSetName("Ful"));
      bloc.add(const RegistrationSetName("Fula"));
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("f"));
      bloc.add(const RegistrationSetEmail("fu"));
      bloc.add(const RegistrationSetEmail("ful"));
      bloc.add(const RegistrationSetEmail("fula"));
      bloc.add(const RegistrationSetEmail("fulan"));
      bloc.add(const RegistrationSetEmail("fulan@"));
      bloc.add(const RegistrationSetEmail("fulan@e"));
      bloc.add(const RegistrationSetEmail("fulan@em"));
      bloc.add(const RegistrationSetEmail("fulan@ema"));
      bloc.add(const RegistrationSetEmail("fulan@emai"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetEmail("fulan@email."));
      bloc.add(const RegistrationSetEmail("fulan@email.c"));
      bloc.add(const RegistrationSetEmail("fulan@email.co"));
      bloc.add(const RegistrationSetEmail("fulan@email.com"));
      bloc.add(const RegistrationSetPassword("P"));
      bloc.add(const RegistrationSetPassword("Pa"));
      bloc.add(const RegistrationSetPassword("Pas"));
      bloc.add(const RegistrationSetPassword("Pass"));
      bloc.add(const RegistrationSetPassword("Passw"));
      bloc.add(const RegistrationSetPassword("Passwo"));
      bloc.add(const RegistrationSetPassword("Passwor"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetPassword("Password1"));
      bloc.add(const RegistrationSetPassword("Password12"));
      bloc.add(const RegistrationSetPassword("Password123"));
      bloc.add(const RegistrationSetConfirmPassword("P"));
      bloc.add(const RegistrationSetConfirmPassword("Pa"));
      bloc.add(const RegistrationSetConfirmPassword("Pas"));
      bloc.add(const RegistrationSetConfirmPassword("Pass"));
      bloc.add(const RegistrationSetConfirmPassword("Passw"));
      bloc.add(const RegistrationSetConfirmPassword("Passwo"));
      bloc.add(const RegistrationSetConfirmPassword("Passwor"));
      bloc.add(const RegistrationSetConfirmPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password1"));
      bloc.add(const RegistrationSetConfirmPassword("Password12"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));

      // expect stream value
      expectLater(bloc.stream, emitsInOrder(expected));
    });

    test("Should keep value even though return error fields", () {
      final expected = [
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationValidationError(model: RegistrationModel(name: "Fulan", errorName: "Your name should contain at least 8 characters", email: "fulan@email", errorEmail: "Please enter a valid email address", password: "Password", errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.", confirmPassword: "Password123", errorConfirmPassword: "Your password and confirmation password do not match")),
      ];
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(const RegistrationSetValidationError(errors: errors));

      // expect stream value
      expectLater(bloc.stream, emitsInOrder(expected));
    });
  });

  group("Submit registration form", () {
    setUp(() {
      mockRegistrationUseCase = MockRegistrationUsecase();
      bloc = RegistrationBloc(registrationUsecase: mockRegistrationUseCase);
      registrationParams = RegistrationParams(name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123");
    });

    test("Should return RegistrationGeneralError(message: NullFailure.message) when registration is failed because of NullFailure()", () async {
      when(mockRegistrationUseCase(any)).thenAnswer((_) async => Left(NullFailure()));

      final expected = [
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationLoading(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationGeneralError(message: NullFailure.message, model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: ""))
      ];
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(RegistrationSubmit());

      /**
       * - expect stream value
       * - It's placed here because it has to stream value of bloc. So that we can't place this "expectLater" after "untileCalled" 
       *  because "untilCalled" make "expectLater" the last streamed value after call "mockRegistrationUseCase(any)"
       * */ 
      expectLater(bloc.stream, emitsInOrder(expected));
      
      await untilCalled(mockRegistrationUseCase(any));
      
      final result = await mockRegistrationUseCase(registrationParams);
      
      expect(result, Left(NullFailure()));
      verify(mockRegistrationUseCase(registrationParams));

    });

    test("Should return RegistrationGeneralError(message: NetworkFailure.message) when registration is failed because of NetworkFailure()", () async {
      when(mockRegistrationUseCase(any)).thenAnswer((_) async => Left(NetworkFailure()));

      final expected = [
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationLoading(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationGeneralError(message: NetworkFailure.message, model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: ""))
      ];
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(RegistrationSubmit());

      /**
       * - expect stream value
       * - It's placed here because it has to stream value of bloc. So that we can't place this "expectLater" after "untileCalled" 
       *  because "untilCalled" make "expectLater" the last streamed value after call "mockRegistrationUseCase(any)"
       * */ 
      expectLater(bloc.stream, emitsInOrder(expected));
      
      await untilCalled(mockRegistrationUseCase(any));
      
      final result = await mockRegistrationUseCase(registrationParams);
      
      expect(result, Left(NetworkFailure()));
      verify(mockRegistrationUseCase(registrationParams));

    });

    test("Should return RegistrationGeneralError(message: 'Something went wrong') when registration is failed because of other reasons", () async {
      when(mockRegistrationUseCase(any)).thenAnswer((_) async => Left(ServerFailure(message: "Something went wrong")));

      final expected = [
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationLoading(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationGeneralError(message: "Something went wrong", model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: ""))
      ];
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(RegistrationSubmit());

      /**
       * - expect stream value
       * - It's placed here because it has to stream value of bloc. So that we can't place this "expectLater" after "untileCalled" 
       *  because "untilCalled" make "expectLater" the last streamed value after call "mockRegistrationUseCase(any)"
       * */ 
      expectLater(bloc.stream, emitsInOrder(expected));
      
      await untilCalled(mockRegistrationUseCase(any));
      
      final result = await mockRegistrationUseCase(registrationParams);
      
      expect(result, Left(ServerFailure(message: "Something went wrong")));
      verify(mockRegistrationUseCase(registrationParams));

    });

    test("Should return error fields when registration is failed because of validation error", () async {
      when(mockRegistrationUseCase(any)).thenAnswer((_) async => Left(ServerFailure(message: "Something went wrong", errors: errors)));

      final expected = [
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationLoading(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationValidationError(model: RegistrationModel(name: "Fulan", errorName: "Your name should contain at least 8 characters", email: "fulan@email", errorEmail: "Please enter a valid email address", password: "Password", errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.", confirmPassword: "Password123", errorConfirmPassword: "Your password and confirmation password do not match")),
      ];
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(RegistrationSubmit());
      bloc.add(const RegistrationSetValidationError(errors: errors));

      // expect stream value
      expectLater(bloc.stream, emitsInOrder(expected));

      await untilCalled(mockRegistrationUseCase(any));
      
      final result = await mockRegistrationUseCase(registrationParams);

      expect(result, Left(ServerFailure(message: "Something went wrong", errors: errors)));
      verify(mockRegistrationUseCase(registrationParams));

    });

    test("Should reset error fields on loading/before registration submit", () async {
      when(mockRegistrationUseCase(any)).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));

      final expected = [
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationValidationError(model: RegistrationModel(name: "Fulan", errorName: "Your name should contain at least 8 characters", email: "fulan@email", errorEmail: "Please enter a valid email address", password: "Password", errorPassword: "A minimum 8 characters password contains a combination of uppercase and lowercase letter and number are required.", confirmPassword: "Password123", errorConfirmPassword: "Your password and confirmation password do not match")),
        const RegistrationLoading(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
      ];
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(const RegistrationSetValidationError(errors: errors));
      bloc.add(RegistrationSubmit());

      // expect stream value
      expectLater(bloc.stream, emitsInOrder(expected));

      await untilCalled(mockRegistrationUseCase(any));

    });

    test("Should return RegistrationSuccess(token: token) when registration is success", () async {
      when(mockRegistrationUseCase(any)).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));

      final expected = [
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "", errorConfirmPassword: "")),
        const RegistrationEnterField(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationLoading(model: RegistrationModel(name: "Fulan", errorName: "", email: "fulan@email", errorEmail: "", password: "Password", errorPassword: "", confirmPassword: "Password123", errorConfirmPassword: "")),
        const RegistrationSuccess(token: token)
      ];
      
      bloc.add(const RegistrationSetName("Fulan"));
      bloc.add(const RegistrationSetEmail("fulan@email"));
      bloc.add(const RegistrationSetPassword("Password"));
      bloc.add(const RegistrationSetConfirmPassword("Password123"));
      bloc.add(RegistrationSubmit());

      // expect stream value
      expectLater(bloc.stream, emitsInOrder(expected));

      await untilCalled(mockRegistrationUseCase(any));
      
      final result = await mockRegistrationUseCase(registrationParams);

      expect(result, const Right(AuthenticationEntity(token: token)));
      verify(mockRegistrationUseCase(registrationParams));

    });
  });
}