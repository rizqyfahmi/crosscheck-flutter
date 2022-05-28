import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
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
  
  // Mock Result
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  const AuthenticationEntity authenticationEntity = AuthenticationEntity(token: token);

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = RegistrationUsecase(repository: mockAuthenticationRepository);
    registrationParams = const RegistrationParams(name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123");
  });

  test("Should get authentication token after registration", () async {
    when(mockAuthenticationRepository.registration(registrationParams)).thenAnswer((_) async => const Right(authenticationEntity));

    final result = await usecase(registrationParams);
    
    expect(result, const Right(AuthenticationEntity(token: token)));
    verify(mockAuthenticationRepository.registration(registrationParams));
    verifyNoMoreInteractions(mockAuthenticationRepository);
  });
}