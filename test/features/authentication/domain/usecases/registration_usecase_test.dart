import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/authentication/domain/usecases/registration_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'registration_usecase_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late RegistrationUsecase usecase;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late RegistrationParams registrationParams;
  
  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = RegistrationUsecase(repository: mockAuthenticationRepository);
    registrationParams = RegistrationParams(name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123");
  });

  test('Should register a new account properly', () async {
    when(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    )).thenAnswer((_) async => const Right(null));

    final result = await usecase(registrationParams);

    expect(result, const Right(null));
    verify(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    ));
  });

  test("Should returns ServerFailure when registration returns ServerFailure", () async {
    when(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    )).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    final result = await usecase(registrationParams);
    
    expect(result, Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    ));
  });

  test("Should returns CacheFailure when registration returns CacheFailure", () async {
    when(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    )).thenAnswer((_) async => Left(CachedFailure(message: Failure.generalError)));

    final result = await usecase(registrationParams);
    
    expect(result, Left(CachedFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    ));
  });

  test("Should returns ServerFailure when register without filling all fields", () async {
    when(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    )).thenAnswer((_) async => const Right(null));

    final result = await usecase(RegistrationParams(name: "", email: "", password: "", confirmPassword: ""));
    
    const expected = [
      {
        "field": "name",
        "message":  "The name field is required"
      },
      {
        "field": "email",
        "message":  "The email field is required"
      },
      {
        "field": "password",
        "message":  "The password field is required"
      },
      {
        "field": "confirmPassword",
        "message":  "The confirmation password field is required"
      },
    ];
    expect(result, Left(ServerFailure(message: Failure.validationError, errors: expected)));
    verifyNever(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    ));
  });

  test("Should returns ServerFailure when register without filling at least one field", () async {
    when(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    )).thenAnswer((_) async => const Right(null));

    final result = await usecase(RegistrationParams(name: "fulan", email: "", password: "Password123", confirmPassword: "Password123"));
    
    const expected = [
      {
        "field": "email",
        "message":  "The email field is required"
      }
    ];
    expect(result, Left(ServerFailure(message: Failure.validationError, errors: expected)));
    verifyNever(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    ));
  });

  test("Should returns ServerFailure when register with password and confirmation password do not match", () async {
    when(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    )).thenAnswer((_) async => const Right(null));

    final result = await usecase(RegistrationParams(name: "fulan", email: "fulan@email.com", password: "Password123", confirmPassword: "Password1234"));
    
    const expected = [
      {
        "field": "confirmPassword",
        "message":  "The password and confirmation password do not match"
      }
    ];
    expect(result, Left(ServerFailure(message: Failure.validationError, errors: expected)));
    verifyNever(mockAuthenticationRepository.registration(
      name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
    ));
  });
}