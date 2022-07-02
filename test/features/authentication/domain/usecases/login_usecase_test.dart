import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/data/models/request/login_params.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/authentication/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late LoginUsecase usecase;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late LoginParams loginParams;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = LoginUsecase(repository: mockAuthenticationRepository);
    loginParams = LoginParams(username: "fulan@email.com", password: "Password123");
  });

  test("Should logged in properly", () async {
    when(mockAuthenticationRepository.login(
      username: "fulan@email.com", password: "Password123"
    )).thenAnswer((_) async => const Right(null));

    final result = await usecase(loginParams);

    expect(result, const Right(null));
    verify(mockAuthenticationRepository.login(
      username: "fulan@email.com", password: "Password123"
    ));
  });

  test("Should returns ServerFailure when login returns ServerFailure", () async {
    when(mockAuthenticationRepository.login(
      username: "fulan@email.com", password: "Password123"
    )).thenAnswer((_) async => const Left(ServerFailure(message: Failure.generalError)));

    final result = await usecase(loginParams);
    
    expect(result, const Left(ServerFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.login(
      username: "fulan@email.com", password: "Password123"
    ));
  });

  test("Should returns CacheFailure when login returns CacheFailure", () async {
    when(mockAuthenticationRepository.login(
      username: "fulan@email.com", password: "Password123"
    )).thenAnswer((_) async => const Left(CacheFailure(message: Failure.generalError)));

    final result = await usecase(loginParams);
    
    expect(result, const Left(CacheFailure(message: Failure.generalError)));
    verify(mockAuthenticationRepository.login(
      username: "fulan@email.com", password: "Password123"
    ));
  });

  test("Should returns ServerFailure when login with username or password that is still empty", () async {
    when(mockAuthenticationRepository.login(
      username: "fulan@email.com", password: "Password123"
    )).thenAnswer((_) async => const Left(ServerFailure(message: Failure.loginRequiredFieldError)));

    final result = await usecase(LoginParams(username: "", password: ""));
    
    expect(result, const Left(ServerFailure(message: Failure.loginRequiredFieldError)));
    verifyNever(mockAuthenticationRepository.login(
      username: "fulan@email.com", password: "Password123"
    ));
  });

}