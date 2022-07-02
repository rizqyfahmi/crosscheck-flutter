import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/param/param.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'registration_usecase_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository
])
void main() {
  late MockAuthenticationRepository mockAuthenticationRepository;
  late AuthenticationUsecase authenticationUsecase;

  const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    authenticationUsecase = AuthenticationUsecase(repository: mockAuthenticationRepository);
  });

  test('Should get cached token properly', () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));

    final result = await authenticationUsecase(NoParam());

    expect(result, const Right(AuthenticationEntity(token: token)));
  });

  test('Should returns CacheFailure when get cached token returns CacheFailure', () async {

    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const  Left(CacheFailure(message: Failure.cacheError)));

    final result = await authenticationUsecase(NoParam());

    expect(result, const Left(CacheFailure(message: Failure.cacheError)));
    
  });
}