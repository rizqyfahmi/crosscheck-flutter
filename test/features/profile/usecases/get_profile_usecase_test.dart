import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:crosscheck/features/profile/data/models/params/profile_params.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/profile/domain/repositories/profile_repository.dart';
import 'package:crosscheck/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_usecase_test.mocks.dart';

@GenerateMocks([
  ProfileRepository,
  AuthenticationRepository
])
void main() {
  late MockProfileRepository mockProfileRepository;
  late MockAuthenticationRepository mockAuthenticationRepository;
  late GetProfileUsecase usecase;

  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = GetProfileUsecase(
      repository: mockProfileRepository,
      authenticationRepository: mockAuthenticationRepository
    );
  });

  test("Should call profile and authentication repository", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));
    when(mockProfileRepository.getProfile(token: token)).thenAnswer((_) async => const Right(ProfileEntity(fullname: "fulan", email: "fulan@email.com")));

    await usecase(ProfileParams(token: token));

    verify(mockAuthenticationRepository.getToken());
    verify(mockProfileRepository.getProfile(token: token));
  });

  test("Should returns ProfileEntity properly", () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));
    when(mockProfileRepository.getProfile(token: token)).thenAnswer((_) async => const Right(ProfileEntity(fullname: "fulan", email: "fulan@email.com")));

    final result = await usecase(ProfileParams(token: token));

    expect(result, const Right(ProfileEntity(fullname: "fulan", email: "fulan@email.com")));
  });

  test('Should returns ServerFailure when get profile returns ServerFailure', () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => const Right(AuthenticationEntity(token: token)));
    when(mockProfileRepository.getProfile(token: token)).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));

    final result = await usecase(ProfileParams(token: token));

    expect(result, Left(ServerFailure(message: Failure.generalError)));
  });

  test('Should returns ServerFailure when get token returns ServerFailure', () async {
    when(mockAuthenticationRepository.getToken()).thenAnswer((_) async => Left(ServerFailure(message: Failure.generalError)));
    when(mockProfileRepository.getProfile(token: token)).thenAnswer((_) async => const Right(ProfileEntity(fullname: "fulan", email: "fulan@email.com")));

    final result = await usecase(ProfileParams(token: token));

    expect(result, Left(ServerFailure(message: Failure.generalError)));
    verifyNever(mockProfileRepository.getProfile(token: token));
  });
}