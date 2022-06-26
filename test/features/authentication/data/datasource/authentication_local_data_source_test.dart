import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:crosscheck/features/authentication/data/models/data/authentication_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/stringify.dart';
import 'authentication_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late AuthenticationLocalDataSource localDataSource;

  // Mock Result
  const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = AuthenticationLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  test("Should set token properly", () async {
    when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

    const model = AuthenticationModel(token: token);
    await localDataSource.setToken(model);

    verify(mockSharedPreferences.setString("CACHED_AUTHENTICATION", json.encode(model.toJSON())));
    verifyNoMoreInteractions(mockSharedPreferences);
  });

  test("Should return CacheException when set token is failed", () {
    when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => false);

    final call = localDataSource.setToken;

    expect(
      () => call(const AuthenticationModel(token: token)), 
      throwsA(
        predicate((error) => error is CacheException)
      )
    );
  });

  test("Should get token properly", () async {
    final String response = stringify("test/features/authentication/data/datasource/response/authentication_get_local_token.json");
    when(mockSharedPreferences.getString(any)).thenReturn(response);

    final result = await localDataSource.getToken();

    expect(result, const AuthenticationModel(token: token));
  });

  test("Should return CacheException when get token is failed", () {
    when(mockSharedPreferences.getString(any)).thenReturn(null);

    final call = localDataSource.getToken;

    expect(
      () => call(), 
      throwsA(
        predicate((error) => error is CacheException)
      )
    );
  });
}