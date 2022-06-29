import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/profile/data/datasource/profile_local_data_source.dart';
import 'package:crosscheck/features/profile/data/models/data/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_local_data_source_test.mocks.dart';

@GenerateMocks([
  Box
])
void main() {
  late MockBox<ProfileModel> mockBoxProfileModel;
  late ProfileLocalDataSource profileLocalDataSource;

  setUp(() {
    mockBoxProfileModel = MockBox();
    profileLocalDataSource = ProfileLocalDdataSourceImpl(box: mockBoxProfileModel);
  });

  test('Should set profile properly', () async {
    final model = ProfileModel(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60");
    when(mockBoxProfileModel.isOpen).thenReturn(true);
    when(mockBoxProfileModel.put("currentProfile", model)).thenAnswer((_) async => Future.value());

    await profileLocalDataSource.setProfile(model);
    
    verify(mockBoxProfileModel.isOpen);
    verify(mockBoxProfileModel.put("currentProfile", model));
  });

  test('Should returns CacheException when set profile is failed because of the database is not open', () async {
    final model = ProfileModel(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60");
    when(mockBoxProfileModel.isOpen).thenReturn(false);

    final call = profileLocalDataSource.setProfile;

    expect(() => call(model), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockBoxProfileModel.isOpen);
    verifyNever(mockBoxProfileModel.put("currentProfile", model));
  });

  test('Should get profile properly', () async {
    final model = ProfileModel(id: "123", fullname: "fulan", email: "fulan@email.com", dob: DateTime.parse("1991-01-11"), address: "Indonesia", photoUrl: "https://via.placeholder.com/60x60");
    when(mockBoxProfileModel.isOpen).thenReturn(true);
    when(mockBoxProfileModel.get("currentProfile")).thenReturn(model);

    final result = await profileLocalDataSource.getProfile();
    
    expect(result, model);
    verify(mockBoxProfileModel.isOpen);
    verify(mockBoxProfileModel.get("currentProfile"));
  });

  test('Should returns CacheException when get profile is failed because of the database is not open', () async {
    when(mockBoxProfileModel.isOpen).thenReturn(false);

    final call = profileLocalDataSource.getProfile;

    expect(() => call(), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockBoxProfileModel.isOpen);
    verifyNever(mockBoxProfileModel.get("currentProfile"));
  });

  test('Should returns CacheException when get profile returns null', () async {
    when(mockBoxProfileModel.isOpen).thenReturn(true);
    when(mockBoxProfileModel.get("currentProfile")).thenReturn(null);

    final call = profileLocalDataSource.getProfile;

    expect(() => call(), throwsA(
      predicate((error) => error is CacheException)
    ));
    verify(mockBoxProfileModel.isOpen);
    verify(mockBoxProfileModel.get("currentProfile"));
  });
}