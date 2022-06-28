import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:crosscheck/features/authentication/data/models/response/authentication_response_model.dart';
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
  
  // Mock Result
  String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
  AuthenticationResponseModel responseModel = AuthenticationResponseModel(message: "The request has succeeded", data: AuthenticationModel(token: token));
  AuthenticationEntity authenticationEntity = responseModel.data;

  setUp(() {
    mockRemoteDataSource = MockAuthenticationRemoteDataSource();
    mockLocalDataSource = MockAuthenticationLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthenticationRepositoryImpl(
      remote: mockRemoteDataSource,
      local: mockLocalDataSource,
      networkInfo: mockNetworkInfo
    );
  });

  group("Registration", () {
    group("Offline device", () {
      test("Should not register a new account and return NetworkFailure", () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        
        final result = await repository.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        );

        expect(result, Left(NetworkFailure()));
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockRemoteDataSource.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        ));
        verifyNever(mockLocalDataSource.setToken(any));
      });
    });
    group("Online device", () {
      test("Should register a new account and set authentication token properly", () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        )).thenAnswer((_) async => responseModel);

        final result = await repository.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        );

        expect(result, const Right(null));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        ));
        verify(mockLocalDataSource.setToken(any));
      });

      test("Should not register a new account and return ServerFailure when registration returns ServerException", () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        )).thenThrow(ServerException(message: Failure.generalError));
        
        final result = await repository.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        );

        expect(result, Left(ServerFailure(message: Failure.generalError)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        ));
        verifyNever(mockLocalDataSource.setToken(any));
      });

      test("Should not register a new account and return CachedFailure when registration returns CacheException", () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        )).thenAnswer((_) async => responseModel);
        when(mockLocalDataSource.setToken(any)).thenThrow(CacheException(message: Failure.cacheError));
        
        final result = await repository.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        );

        expect(result, Left(CachedFailure(message: Failure.cacheError)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.registration(
          name: "Fulan", email: "fulan@email.com", password: "fulan123", confirmPassword: "fulan123"
        ));
        verify(mockLocalDataSource.setToken(any));
      });
    });
  });

  group("Login", () {
    group("Offline device", () {
      test("Should not logged in and return NetworkFailure", () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        
        final result = await repository.login(
          username: "fulan@email.com", password: "fulan123"
        );

        expect(result, Left(NetworkFailure()));
        verify(mockNetworkInfo.isConnected);
        verifyNever(mockRemoteDataSource.login(
          username: "fulan@email.com", password: "fulan123"
        ));
        verifyNever(mockLocalDataSource.setToken(any));
      });
    });
    group("Online device", () {
      test("Should logged in and set authentication token properly", () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.login(
          username: "fulan@email.com", password: "fulan123"
        )).thenAnswer((_) async => responseModel);

        final result = await repository.login(
          username: "fulan@email.com", password: "fulan123"
        );

        expect(result, const Right(null));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.login(
          username: "fulan@email.com", password: "fulan123"
        ));
        verify(mockLocalDataSource.setToken(any));
      });

      test("Should not logged in and return ServerFailure when registration returns ServerException", () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.login(
          username: "fulan@email.com", password: "fulan123"
        )).thenThrow(ServerException(message: Failure.generalError));
        
        final result = await repository.login(
          username: "fulan@email.com", password: "fulan123"
        );

        expect(result, Left(ServerFailure(message: Failure.generalError)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.login(
          username: "fulan@email.com", password: "fulan123"
        ));
        verifyNever(mockLocalDataSource.setToken(any));
      });

      test("Should not logged in and return CachedFailure when registration returns CacheException", () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.login(
          username: "fulan@email.com", password: "fulan123"
        )).thenAnswer((_) async => responseModel);
        when(mockLocalDataSource.setToken(any)).thenThrow(CacheException(message: Failure.cacheError));
        
        final result = await repository.login(
          username: "fulan@email.com", password: "fulan123"
        );

        expect(result, Left(CachedFailure(message: Failure.cacheError)));
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.login(
          username: "fulan@email.com", password: "fulan123"
        ));
        verify(mockLocalDataSource.setToken(any));
      });
    });
  });

  test("Should get cached token properly", () async {
    when(mockLocalDataSource.getToken()).thenAnswer((_) async => AuthenticationModel(token: token));

    final result = await repository.getToken();

    expect(result, Right(authenticationEntity));
    verify(mockLocalDataSource.getToken());
  });

  test("Should returns CachedFailure when get token returns CacheException ", () async {
    when(mockLocalDataSource.getToken()).thenThrow(CacheException(message: Failure.cacheError));

    final result = await repository.getToken();

    expect(result, Left(CachedFailure(message: Failure.cacheError)));
    verify(mockLocalDataSource.getToken());
  });
}