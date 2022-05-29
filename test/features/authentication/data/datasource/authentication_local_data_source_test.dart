import 'package:crosscheck/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:crosscheck/features/authentication/domain/entities/authentication_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  test("Should call setToken when token needs to be cached", () async {
    when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

    await localDataSource.setToken(token);

    verify(mockSharedPreferences.setString("token", token));
    verifyNoMoreInteractions(mockSharedPreferences);
  });
}