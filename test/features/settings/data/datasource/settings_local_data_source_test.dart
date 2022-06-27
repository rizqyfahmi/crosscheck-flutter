import 'dart:convert';

import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/features/settings/data/datasource/settings_local_data_source.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_local_data_source_test.mocks.dart';

@GenerateMocks([
  SharedPreferences
])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late SettingsLocalDataSource settingsLocalDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    settingsLocalDataSource = SettingsLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  test("Should set theme properly", () async {
    const params = SettingsModel(themeMode: Brightness.light);
    when(mockSharedPreferences.setString("CACHED_SETTINGS", json.encode(params.toJSON()))).thenAnswer((_) async => true);

    await settingsLocalDataSource.setTheme(params);

    verify(mockSharedPreferences.setString("CACHED_SETTINGS", json.encode(params.toJSON())));
  });

  test("Should return CacheException when set theme is failed", () async {
    const params = SettingsModel(themeMode: Brightness.light);
    when(mockSharedPreferences.setString("CACHED_SETTINGS", json.encode(params.toJSON()))).thenAnswer((_) async => false);

    final call = settingsLocalDataSource.setTheme;

    expect(call(params), throwsA(
      predicate((error) => error is CacheException)
    ));

    verify(mockSharedPreferences.setString("CACHED_SETTINGS", json.encode(params.toJSON())));
  });

  test("Should get theme properly", () async {
    final mocked = "{\"themeMode\": ${Brightness.light.index}}";
    when(mockSharedPreferences.getString("CACHED_SETTINGS")).thenReturn(mocked);

    final result = await settingsLocalDataSource.getTheme();

    expect(result, const SettingsModel(themeMode: Brightness.light));
    verify(mockSharedPreferences.getString("CACHED_SETTINGS"));
  });

  test("Should return CachedException when get theme is failed", () async {
    when(mockSharedPreferences.getString("CACHED_SETTINGS")).thenReturn(null);

    final call = settingsLocalDataSource.getTheme;

    expect(() => call(), throwsA(
      predicate((error) => error is CacheException)
    ));

    verify(mockSharedPreferences.getString("CACHED_SETTINGS"));
  });
}