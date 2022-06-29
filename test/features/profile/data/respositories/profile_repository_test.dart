import 'dart:io';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/core/network/network_info.dart';
import 'package:crosscheck/features/profile/data/datasource/profile_local_data_source.dart';
import 'package:crosscheck/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';
import 'package:crosscheck/features/profile/data/models/response/profile_response_model.dart';
import 'package:crosscheck/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:crosscheck/features/profile/domain/entities/profile_entity.dart';
import 'package:crosscheck/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repository_test.mocks.dart';

@GenerateMocks([
  ProfileRemoteDataSource,
  ProfileLocalDataSource,
  NetworkInfo
])
void main() {
  late MockProfileRemoteDataSource mockProfileRemoteDataSource;
  late MockProfileLocalDataSource mockProfileLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late ProfileRepository profileRepository;

  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  setUp(() {
    mockProfileRemoteDataSource = MockProfileRemoteDataSource();
    mockProfileLocalDataSource = MockProfileLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    profileRepository = ProfileRepositoryImpl(
      remote: mockProfileRemoteDataSource, 
      local: mockProfileLocalDataSource, 
      networkInfo: mockNetworkInfo
    );
  });

  test("Should returns ProfileEntity from remote data source and set it on local data source when device is online", () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockProfileRemoteDataSource.getProfile(token: token)).thenAnswer((_) async => const ProfileResponseModel(message: "Response OK", data: ProfileModel(fullname: "fulan", email: "fulan@email.com")));

    final result = await profileRepository.getProfile(token: token);

    ProfileEntity expected = const ProfileModel(fullname: "fulan", email: "fulan@email.com");
    expect(result, Right(expected));
    verify(mockNetworkInfo.isConnected);
    verify(mockProfileRemoteDataSource.getProfile(token: token));
    verify(mockProfileLocalDataSource.setProfile(any));
    verifyNever(mockProfileLocalDataSource.getProfile());
  });

  test("Should returns ProfileEntity from local data source when device is offline", () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(mockProfileLocalDataSource.getProfile()).thenAnswer((_) async => const ProfileModel(fullname: "fulan", email: "fulan@email.com"));

    final result = await profileRepository.getProfile(token: token);

    ProfileEntity expected = const ProfileModel(fullname: "fulan", email: "fulan@email.com");
    expect(result, Right(expected));
    verify(mockNetworkInfo.isConnected);
    verifyNever(mockProfileRemoteDataSource.getProfile(token: token));
    verifyNever(mockProfileLocalDataSource.setProfile(any));
    verify(mockProfileLocalDataSource.getProfile());
  });

  test('Should returns ServerFailure when get profile from remote data source throws ServerException', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockProfileRemoteDataSource.getProfile(token: token)).thenThrow(ServerException(message: Failure.generalError));

    final result = await profileRepository.getProfile(token: token);

    expect(result, Left(ServerFailure(message: Failure.generalError)));
    verify(mockNetworkInfo.isConnected);
    verify(mockProfileRemoteDataSource.getProfile(token: token));
    verifyNever(mockProfileLocalDataSource.setProfile(any));
    verifyNever(mockProfileLocalDataSource.getProfile());
  });

  test('Should returns CachedFailure when set profile into local data source throws CacheException', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockProfileRemoteDataSource.getProfile(token: token)).thenAnswer((_) async => const ProfileResponseModel(message: "Response OK", data: ProfileModel(fullname: "fulan", email: "fulan@email.com")));
    when(mockProfileLocalDataSource.setProfile(any)).thenThrow(CacheException(message: Failure.cacheError));

    final result = await profileRepository.getProfile(token: token);

    expect(result, Left(CachedFailure(message: Failure.cacheError)));
    verify(mockNetworkInfo.isConnected);
    verify(mockProfileRemoteDataSource.getProfile(token: token));
    verify(mockProfileLocalDataSource.setProfile(any));
    verifyNever(mockProfileLocalDataSource.getProfile());
  });

  test('Should returns CachedFailure when get profile from local data source throws CacheException', () async {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    when(mockProfileLocalDataSource.getProfile()).thenThrow(CacheException(message: Failure.cacheError));
    
    final result = await profileRepository.getProfile(token: token);

    expect(result, Left(CachedFailure(message: Failure.cacheError)));
    verify(mockNetworkInfo.isConnected);
    verifyNever(mockProfileRemoteDataSource.getProfile(token: token));
    verifyNever(mockProfileLocalDataSource.setProfile(any));
    verify(mockProfileLocalDataSource.getProfile());
  });
}