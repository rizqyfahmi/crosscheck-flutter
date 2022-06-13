import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/main/data/datasource/main_local_data_source.dart';
import 'package:crosscheck/features/main/data/model/bottom_navigation_model.dart';
import 'package:crosscheck/features/main/domain/entities/bottom_navigation_entity.dart';
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
    String jsonString = "{\"currentPage\": ${BottomNavigation.event.index}}";
    
    when(mockSharedPreference.getString("CACHED_BOTTOM_NAVIGATION")).thenReturn(jsonString);

    final result = await mainLocalDataSource.getActiveBottomNavigation();

    expect(result, const BottomNavigationModel(currentPage: BottomNavigation.event));
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

  test("Should not throw CacheException when set active bottom navigation is success", () async {
    const param = BottomNavigationModel(currentPage: BottomNavigation.event);
    when(mockSharedPreference.setString("CACHED_BOTTOM_NAVIGATION", json.encode(param.toJSON()))).thenAnswer((_) async => true);

    await mainLocalDataSource.setActiveBottomNavigation(param);

    verify(mockSharedPreference.setString("CACHED_BOTTOM_NAVIGATION", json.encode(param.toJSON())));
  });

  test("Should throw CacheException when set active bottom navigation is failed", () async {
    const param = BottomNavigationModel(currentPage: BottomNavigation.event);
    when(mockSharedPreference.setString("CACHED_BOTTOM_NAVIGATION", json.encode(param.toJSON()))).thenAnswer((_) async => false);

    final call = mainLocalDataSource.setActiveBottomNavigation;

    expect(call(param), throwsA(
      predicate((e) => e is CacheException)
    ));

    verify(mockSharedPreference.setString("CACHED_BOTTOM_NAVIGATION", json.encode(param.toJSON())));
  });
}