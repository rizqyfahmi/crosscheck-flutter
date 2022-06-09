
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/walkthrough/data/datasource/walkthrough_local_data_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../authentication/data/datasource/authentication_local_data_source_test.mocks.dart';

@GenerateMocks([
  SharedPreferences
])
void main() {
  late MockSharedPreferences mockSharedPreference;
  late WalkthroughLocalDataSource walkthroughLocalDataSource;

  setUp(() {
    mockSharedPreference = MockSharedPreferences();
    walkthroughLocalDataSource = WalkthroughLocalDataSourceImpl(sharedPreferences: mockSharedPreference);
  });

  test("Should set \"isSkip\" status properly", () async {
    when(mockSharedPreference.setBool("isSkip", true)).thenAnswer((_) async => true);

    await walkthroughLocalDataSource.setIsSkip(true);

    verify(mockSharedPreference.setBool("isSkip", true));
  });

  test("Should not set \"is skip\" status and throw CachedExeption when error is happened", () async {
    when(mockSharedPreference.setBool("isSkip", true)).thenAnswer((_) async => false);

    final call = walkthroughLocalDataSource.setIsSkip(true);

    expect(() => call, throwsA(const TypeMatcher<CacheException>()));
  });
}