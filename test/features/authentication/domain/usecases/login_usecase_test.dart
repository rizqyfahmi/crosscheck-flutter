import 'package:crosscheck/features/authentication/data/models/request/login_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
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

  // Mock Result
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  const AuthenticationEntity authenticationEntity = AuthenticationEntity(token: token);

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = LoginUsecase(repository: mockAuthenticationRepository);
    loginParams = const LoginParams(username: "fulan@email.com", password: "Password123");
  });

  test("Should get the authentication token after login is success", () async {
    when(mockAuthenticationRepository.login(loginParams)).thenAnswer((_) async => const Right(authenticationEntity));

    final result = await usecase(loginParams);

    expect(result, const Right(AuthenticationEntity(token: token)));
    verify(mockAuthenticationRepository.login(loginParams));
  });

}