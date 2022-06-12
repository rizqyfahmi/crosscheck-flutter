import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/main/data/datasource/main_local_data_source.dart';
import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_local_data_source_test.mocks.dart';

@GenerateMocks([
  SharedPreferences
])
void main() {
  late MockSharedPreferences mockSharedPreference;
  late MainLocalDataSource mainLocalDataSource;

  setUp(() {
    mockSharedPreference = MockSharedPreferences();
    mainLocalDataSource = MainLocalDataSourceImpl(sharedPreferences: mockSharedPreference);
  });

  test("Should return BottomNavigationModel when get active bottom navigation is success", () async {
    String jsonString = "{\"currentPageIndex\": 1}";
    when(mockSharedPreference.getString("CACHED_BOTTOM_NAVIGATION")).thenReturn(jsonString);

    final result = await mainLocalDataSource.getActiveBottomNavigation();

    expect(result, const BottomNavigationModel(currentPageIndex: 1));
    verify(mockSharedPreference.getString("CACHED_BOTTOM_NAVIGATION"));
  });

  test("Should throw CacheException when get active bottom navigation is failed", () {
    when(mockSharedPreference.getString("CACHED_BOTTOM_NAVIGATION")).thenReturn(null);

    final call = mainLocalDataSource.getActiveBottomNavigation;

    expect(
      call, 
      throwsA(
        predicate((e) => e is CacheException)
      )
    );
    verify(mockSharedPreference.getString("CACHED_BOTTOM_NAVIGATION"));
  });
}