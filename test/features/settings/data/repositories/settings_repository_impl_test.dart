
import 'package:crosscheck/core/error/exception.dart';
import 'package:crosscheck/core/error/failure.dart';
import 'package:crosscheck/features/settings/data/datasource/settings_local_data_source.dart';
import 'package:crosscheck/features/settings/data/models/data/settings_model.dart';
import 'package:crosscheck/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:crosscheck/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_repository_impl_test.mocks.dart';

@GenerateMocks([
  SettingsLocalDataSource
])
void main() {
  late MockSettingsLocalDataSource mockSettingLocalDataSource;
  late SettingsRepository settingsRepository;

  setUp(() {
    mockSettingLocalDataSource = MockSettingsLocalDataSource();
    settingsRepository = SettingsRepositoryImpl(settingsLocalDataSource: mockSettingLocalDataSource);
  });

  test("Should set theme properly", () async {
    when(mockSettingLocalDataSource.setTheme(any)).thenAnswer((_) async => Future.value());

    await settingsRepository.setTheme(const SettingsModel(themeMode: Brightness.light));

    verify(mockSettingLocalDataSource.setTheme(const SettingsModel(themeMode: Brightness.light)));
  });

  test("Should return CacheExpection when set theme is failed", () async {
    const params = SettingsModel(themeMode: Brightness.light);
    when(mockSettingLocalDataSource.setTheme(params)).thenThrow(CacheException(message: Failure.cacheError));

    final call = settingsRepository.setTheme;

    expect(call(params), throwsA(
      predicate((error) => error is CacheException
    )));

    verify(mockSettingLocalDataSource.setTheme(params));
  });
}