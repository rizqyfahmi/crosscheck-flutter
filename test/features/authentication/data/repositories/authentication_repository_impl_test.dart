

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:crosscheck/features/authentication/data/models/request/registration_params.dart';
import 'package:crosscheck/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:crosscheck/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthenticationRemoteDataSource,
  AuthenticationLocalDataSource,
  NetworkInfo
])
void main() {
  late MockAuthenticationRemoteDataSource mockRemoteDataSource;
  late MockAuthenticationLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late AuthenticationRepository repository;
  late RegistrationParams params;
  
  // Mock Result
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  const AuthenticationEntity authenticationEntity = AuthenticationModel(token: token);

  void setToken() {}

  setUp(() {
    mockRemoteDataSource = MockAuthenticationRemoteDataSource();
    mockLocalDataSource = MockAuthenticationLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthenticationRepositoryImpl(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
      networkInfo: mockNetworkInfo
    );
    params = const RegistrationParams(
      name: "Fulan",
      email: "fulan@email.com",
      password: "fulan123",
      confirmPassword: "fulan123"
    );
  });

  test("Should get AunthenticationModel on registration when device is online", () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockRemoteDataSource.registration(params)).thenAnswer((_) async => const AuthenticationModel(token: token));

    final result = await repository.registration(params);

    expect(result, const Right(authenticationEntity));
    verify(mockNetworkInfo.isConnected);
    verifyNoMoreInteractions(mockNetworkInfo);
    verify(mockRemoteDataSource.registration(params));
    verifyNoMoreInteractions(mockRemoteDataSource);
  });

  test("Should get NetworkException on registration when device is offline", () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(mockRemoteDataSource.registration(params)).thenThrow(NetworkException());

    final result = await repository.registration(params);

    expect(result, Left(NetworkFailure()));
    verify(mockNetworkInfo.isConnected);
    verifyNoMoreInteractions(mockNetworkInfo);
  });

  test("Should setToken is called when token would be cached", () async {
    await repository.setToken(token);

    verify(mockLocalDataSource.setToken(token));
    verifyNoMoreInteractions(mockLocalDataSource);
  });

}